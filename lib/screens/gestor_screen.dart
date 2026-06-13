import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:p_plus/providers/autenticacao_provider.dart';
import 'package:p_plus/services/analista_service.dart';
import 'package:p_plus/services/gestor_service.dart';
import 'package:p_plus/services/equipe_service.dart';
import 'package:p_plus/dtos/analista.dart';
import '../widgets/gestor_modals.dart';

class GestorScreen extends StatefulWidget {
  const GestorScreen({super.key});

  @override
  State<GestorScreen> createState() => _GestorScreenState();
}

class _GestorScreenState extends State<GestorScreen> {
  bool _carregando = true;
  String? _idEquipe;
  List<Analista> membros = [];

  int metaDiretas = 75;
  int metaIndiretas = 25;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    final autenticacao = context.read<AutenticacaoProvider>();
    final idGestor = autenticacao.token;
    if (idGestor == null || idGestor.isEmpty) return;

    try {
      final gestorService = GestorService();
      final equipeService = EquipeService();
      final analistaService = AnalistaService();

      final gestor = await gestorService.obterGestor(idGestor);
      if (gestor != null && gestor.idEquipe != null) {
        _idEquipe = gestor.idEquipe;
        final equipe = await equipeService.obterEquipe(gestor.idEquipe!);
        final listaMembros =
            await analistaService.obterAnalistasPorEquipe(gestor.idEquipe!) ??
            [];

        if (mounted) {
          setState(() {
            metaDiretas = equipe?.metaAcoesDiretas ?? 0;
            metaIndiretas = equipe?.metaAcoesIndiretas ?? 0;
            membros = listaMembros;
            _carregando = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _carregando = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _carregando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 10),

              // ========== TÍTULO "GERENCIAR EQUIPE" ==========
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.cyan,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Gerenciar equipe',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ========== LISTA DE MEMBROS DA EQUIPE ==========
              Expanded(
                child: _carregando
                    ? const Center(child: CircularProgressIndicator())
                    : membros.isEmpty
                    ? const Center(child: Text('Nenhum analista na equipe.'))
                    : ListView.builder(
                        itemCount: membros.length,
                        itemBuilder: (context, index) {
                          final membro = membros[index];
                          return _buildMembroCard(membro);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),

      // ========== BOTTOM NAVIGATION BAR (3 botões) ==========
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBottomButton(
                icon: Icons.track_changes_outlined,
                color: Colors.black,
                onPressed: () {
                  _mostrarAlterarMeta();
                },
              ),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(40),
                  onTap: _mostrarLogoff,
                  child: const Center(
                    child: Icon(Icons.logout, color: Colors.grey, size: 23),
                  ),
                ),
              ),
              _buildBottomButton(
                icon: Icons.person_add,
                color: Colors.green,
                onPressed: () {
                  _mostrarNovoUsuario();
                },
              ),
              /*   _buildBottomButton(
                icon: Icons.cloud_upload_sharp,
                color: Colors.cyan,
                onPressed: () {
                  _mostrarInserirAcoes();
                },
              ), */
            ],
          ),
        ),
      ),
    );
  }

  // ========== WIDGET: Card de cada membro ==========
  Widget _buildMembroCard(Analista membro) {
    final bool estaAtivo = membro.status ?? true;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
        border: Border(
          left: BorderSide(
            color: estaAtivo ? Colors.green : Colors.red,
            width: 15,
          ),
        ),
        // border: Border.all(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Nome e Cargo
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  membro.nome ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  estaAtivo ? 'Ativo' : 'Bloqueado',
                  style: TextStyle(
                    fontSize: 14,
                    color: estaAtivo ? Colors.grey : Colors.red,
                  ),
                ),
              ],
            ),
          ),

          // Botão: Excluir (X vermelho)
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              _mostrarExcluirMembro(membro);
            },
          ),

          // Botão: Alterar cadastro (ícone laranja)
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.orange),
            onPressed: () {
              _mostrarEditarCadastro(membro);
            },
          ),

          // Botão: Bloquear/Desativar (ícone vermelho com barra ou verde)
          IconButton(
            icon: Icon(
              estaAtivo ? Icons.block : Icons.check_circle,
              color: estaAtivo ? Colors.red : Colors.green,
            ),
            onPressed: () {
              _mostrarBloquearUsuario(
                membro
              ); // NÃO ENTENDI O QUE A VARIÁVEL 'INDEX' SIGNIFICA!!
            },
          ),
        ],
      ),
    );
  }

  // ========== WIDGET: Botão da barra inferior ==========
  Widget _buildBottomButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      icon: Icon(icon, color: color, size: 35),
      onPressed: onPressed,
    );
  }

  // ========== AÇÕES DOS BOTÕES ==========

  // 1. LOGOFF
  void _mostrarLogoff() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Deseja sair?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('NÃO', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Volta para a tela de login
              Navigator.pushReplacementNamed(context, 'login');
            },
            child: const Text('SIM', style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }

  // 2. EXCLUIR MEMBRO
  void _mostrarExcluirMembro(Analista membro) {
    ModalExcluirMembro.mostrar(context, membro.nome ?? '', () async {
      try {
        await AnalistaService().excluirAnalista(membro.id ?? '');
        _carregarDados();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${membro.nome} foi excluído!')),
          );
        }
      } catch (error) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error.toString())));
        }
      }
    });
  }

  // 3. EDITAR CADASTRO
  void _mostrarEditarCadastro(Analista membro) {
    final Map<String, dynamic> membroMap = {
      'nome': membro.nome,
      'email': membro.email,
      'ativo': membro.status ?? true,
    };
    ModalEditarCadastro.mostrar(context, membroMap, (
      novoNome,
      novoEmail,
    ) async {
      try {
        await AnalistaService().editarDadosAnalista(
          membro.id ?? '',
          novoNome,
          novoEmail,
        );
        _carregarDados();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cadastro alterado com sucesso!')),
          );
        }
      } catch (error) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error.toString())));
        }
      }
    });
  }

  // 4. BLOQUEAR USUÁRIO (ATUALIZADO COM MOTIVO)
  void _mostrarBloquearUsuario(Analista membro) {
    final bool estaAtivo = membro.status ?? false;

    ModalBloquearUsuario.mostrar(context, membro.nome ?? '', estaAtivo, (
      String motivo,
    ) {
      // ← Agora recebe o motivo!
      setState(() {
        membro.status = !estaAtivo;
        // Guarda o motivo no membro (para mostrar depois ou enviar pra API)
        membro.descricaoStatus = motivo;
      });

      AnalistaService service = AnalistaService();
      if (estaAtivo) {
        service.bloquearAnalista(membro.id ?? '', 'Bloqueado');
      } else {
        service.desbloquearAnalista(membro.id ?? '');
      }

      final acao = !estaAtivo ? 'ativado' : 'bloqueado';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${membro.nome ?? ''} foi $acao\nMotivo: $motivo'),
          duration: const Duration(seconds: 3),
        ),
      );
    });
  }

  // 5. ALTERAR META
  void _mostrarAlterarMeta() {
    ModalAlterarMeta.mostrar(context, metaDiretas, metaIndiretas, (
      novasDiretas,
      novasIndiretas,
    ) async {
      if (_idEquipe == null) return;
      try {
        await EquipeService().editarMetas(
          _idEquipe!,
          novasIndiretas,
          novasDiretas,
        );
        _carregarDados();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Meta alterada com sucesso!')),
          );
        }
      } catch (error) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error.toString())));
        }
      }
    });
  }

  // 6. NOVO USUÁRIO
  void _mostrarNovoUsuario() {
    ModalNovoUsuario.mostrar(context, (nome, email, senha) async {
      if (_idEquipe == null) return;
      if (nome.isEmpty || email.isEmpty || senha.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Preencha todos os campos!')),
        );
        return;
      }
      try {
        final analista = Analista(
          nome: nome,
          email: email,
          senha: senha,
          idEquipe: _idEquipe!,
          status: true,
          descricaoStatus: 'Ativo',
        );
        String? novoId = await AnalistaService().criarAnalista(analista);
        if (novoId == null) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Erro: E-mail já cadastrado!')),
            );
          }
        } else {
          _carregarDados();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Novo analista cadastrado com sucesso!'),
              ),
            );
          }
        }
      } catch (error) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error.toString())));
        }
      }
    });
  }

  // 7. INSERIR AÇÕES VIA PLANILHA
  void _mostrarInserirAcoes() {
    ModalInserirAcoes.mostrar(context, () {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ações inseridas com sucesso!')),
      );
    });
  }
}
