import 'package:flutter/material.dart';
import 'package:p_plus/providers/autenticacao_provider.dart';
import 'package:p_plus/screens/detalhes_screen.dart';
import 'package:p_plus/services/analista_service.dart';
import 'package:p_plus/services/equipe_service.dart';
import 'package:p_plus/services/acao_service.dart';
import 'package:p_plus/utils/custom_date_utils.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int indice = 0;
  bool _carregando = true;
  int _totalAcoes = 0;
  int _acoesDiretas = 0;
  int _acoesIndiretas = 0;
  int _porcentagemMeta = 0;

  void mudarTela(int novoIndice) {
    setState(() {
      indice = novoIndice;
    });
    if (novoIndice == 0) {
      _carregarDados();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _carregarDados();
  }


  Future<void> _carregarDados() async {
    final autenticacao = context.read<AutenticacaoProvider>();
    final idAnalista = autenticacao.token;
    if (idAnalista == null || idAnalista.isEmpty) return;

    try {
      final analistaService = AnalistaService();
      final equipeService = EquipeService();
      final acaoService = AcaoService();

      final analista = await analistaService.obterAnalista(idAnalista);
      if (analista != null && analista.idEquipe != null) {
        final equipe = await equipeService.obterEquipe(analista.idEquipe!);
        
        final dataHoje = CustomDateUtils.dataAtualString();
        final acoesTotais = await acaoService.obterAcoesTotaisPorAnalista(idAnalista, dataHoje) ?? [];
        final acoesDiretas = await acaoService.obterAcoesDiretasPorAnalista(idAnalista, dataHoje) ?? [];
        final acoesIndiretas = await acaoService.obterAcoesIndiretasPorAnalista(idAnalista, dataHoje) ?? [];

        final metaTotal = (equipe?.metaAcoesDiretas ?? 0) + (equipe?.metaAcoesIndiretas ?? 0);
        final totalRealizado = acoesTotais.length;
        final porcentagem = metaTotal > 0 ? ((totalRealizado / metaTotal) * 100).round() : 0;

        if (mounted) {
          setState(() {
            _totalAcoes = totalRealizado;
            _acoesDiretas = acoesDiretas.length;
            _acoesIndiretas = acoesIndiretas.length;
            _porcentagemMeta = porcentagem;
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



  Widget indicadorCard({
    required String titulo,
    required String valor,
    required Color cor,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 20,
      ),
      decoration: BoxDecoration(
        color: cor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            titulo,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            valor,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final autenticacao = context.read<AutenticacaoProvider>();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            'Bem-vindo ${autenticacao.nome ?? ""}',
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, 'login');
              },
              icon: const Icon(
                Icons.close,
                color: Colors.red,
              ),
            ),
          ],
        ),
        body: IndexedStack(
          index: indice,
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      _carregando
                          ? 'Carregando metas...'
                          : 'Você atingiu $_porcentagemMeta% da sua meta diária!',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.cyan,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      CustomDateUtils.formatarDataHora(DateTime.now()),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  indicadorCard(
                    titulo: 'Ações realizadas',
                    valor: _carregando ? '...' : '$_totalAcoes',
                    cor: Colors.indigo,
                  ),
                  indicadorCard(
                    titulo: 'Ações diretas',
                    valor: _carregando ? '...' : '$_acoesDiretas',
                    cor: Colors.green,
                  ),
                  indicadorCard(
                    titulo: 'Ações indiretas',
                    valor: _carregando ? '...' : '$_acoesIndiretas',
                    cor: Colors.purple,
                  ),
                ],
              ),
            ),
            const DetalhesScreen(),
            const Center(
              child: Text(
                'Tela 3',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: indice,
          onTap: mudarTela,
          items: const [
            BottomNavigationBarItem(
              label: '',
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              label: '',
              icon: Icon(Icons.phonelink_lock_rounded),
            ),
            BottomNavigationBarItem(
              label: '',
              icon: Icon(Icons.calendar_month),
            ),
          ],
        ),
      ),
    );
  }
}