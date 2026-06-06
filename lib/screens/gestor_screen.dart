import 'package:flutter/material.dart';
import '../widgets/gestor_modals.dart';

class GestorScreen extends StatefulWidget {
  const GestorScreen({super.key});

  @override
  State<GestorScreen> createState() => _GestorScreenState();
}

class _GestorScreenState extends State<GestorScreen> {
  // Lista de membros da equipe (dados mockados)
  final List<Map<String, dynamic>> membros = [
    {'nome': 'João Silva', 'cargo': 'Analista', 'ativo': true, 'email': 'joao@email.com'},
    {'nome': 'Maria Souza', 'cargo': 'Monitor', 'ativo': true, 'email': 'maria@email.com'},
    {'nome': 'Pedro Lima', 'cargo': 'Analista', 'ativo': true, 'email': 'pedro@email.com'},
    {'nome': 'Ana Costa', 'cargo': 'Monitor', 'ativo': false, 'email': 'ana@email.com'},
  ];

  // Metas (mockadas)
  int metaDiretas = 75;
  int metaIndiretas = 25;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // ========== BOTÃO LOGOFF (canto superior direito) ==========
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.red, size: 30),
                  onPressed: () {
                    _mostrarLogoff();
                  },
                ),
              ),

              const SizedBox(height: 10),

              // ========== TÍTULO "GERENCIAR EQUIPE" ==========
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.cyan,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Gerenciar equipe',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ========== LISTA DE MEMBROS DA EQUIPE ==========
              Expanded(
                child: ListView.builder(
                  itemCount: membros.length,
                  itemBuilder: (context, index) {
                    final membro = membros[index];
                    return _buildMembroCard(membro, index);
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
              // Botão: Alterar meta de ações (⚙️ preto)
              _buildBottomButton(
                icon: Icons.settings,
                color: Colors.black,
                onPressed: () {
                  _mostrarAlterarMeta();
                },
              ),
              // Botão: Incluir novo cadastro (+ verde)
              _buildBottomButton(
                icon: Icons.add_circle,
                color: Colors.green,
                onPressed: () {
                  _mostrarNovoUsuario();
                },
              ),
              // Botão: Cadastrar ações via planilha (+ azul/ciano)
              _buildBottomButton(
                icon: Icons.add,
                color: Colors.cyan,
                onPressed: () {
                  _mostrarInserirAcoes();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ========== WIDGET: Card de cada membro ==========
  Widget _buildMembroCard(Map<String, dynamic> membro, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 2),
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
                  membro['nome'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  membro['cargo'],
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          // Botão: Excluir (X vermelho)
          IconButton(
            icon: const Icon(Icons.close, color: Colors.red),
            onPressed: () {
              _mostrarExcluirMembro(membro['nome'], index);
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
              membro['ativo'] ? Icons.block : Icons.check_circle,
              color: membro['ativo'] ? Colors.red : Colors.green,
            ),
            onPressed: () {
              _mostrarBloquearUsuario(membro, index);
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
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
  void _mostrarExcluirMembro(String nome, int index) {
    ModalExcluirMembro.mostrar(
      context,
      nome,
          () {
        setState(() {
          membros.removeAt(index);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$nome foi excluído!')),
        );
      },
    );
  }

  // 3. EDITAR CADASTRO
  void _mostrarEditarCadastro(Map<String, dynamic> membro) {
    ModalEditarCadastro.mostrar(
      context,
      membro,
          () {
        setState(() {
          // Aqui você salvaria as alterações no backend
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cadastro alterado!')),
        );
      },
    );
  }

  // 4. BLOQUEAR USUÁRIO
  void _mostrarBloquearUsuario(Map<String, dynamic> membro, int index) {
    final bool estaAtivo = membros[index]['ativo'];

    ModalBloquearUsuario.mostrar(
      context,
      membro['nome'],
      estaAtivo,
          () {

        setState(() {
          membros[index]['ativo'] = !estaAtivo;
        });

        final novoStatus = !estaAtivo ? 'ativado' : 'bloqueado';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${membro['nome']} foi $novoStatus!')),
        );
      },
    );
  }


  // 5. ALTERAR META
  void _mostrarAlterarMeta() {
    ModalAlterarMeta.mostrar(
      context,
      metaDiretas,
      metaIndiretas,
          (novasDiretas, novasIndiretas) {
        setState(() {
          metaDiretas = novasDiretas;
          metaIndiretas = novasIndiretas;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Meta alterada com sucesso!')),
        );
      },
    );
  }

  // 6. NOVO USUÁRIO
  void _mostrarNovoUsuario() {
    ModalNovoUsuario.mostrar(
      context,
          () {
        setState(() {
          membros.add({
            'nome': 'Novo Usuário ${membros.length + 1}',
            'cargo': 'Analista',
            'ativo': true,
            'email': 'novo${membros.length + 1}@email.com',
          });
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Novo usuário cadastrado!')),
        );
      },
    );
  }

  // 7. INSERIR AÇÕES VIA PLANILHA
  void _mostrarInserirAcoes() {
    ModalInserirAcoes.mostrar(
      context,
          () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ações inseridas com sucesso!')),
        );
      },
    );
  }
}