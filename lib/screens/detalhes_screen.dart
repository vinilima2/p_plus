import 'package:flutter/material.dart';
import 'package:p_plus/utils/constants.dart';
import 'package:p_plus/utils/custom_date_utils.dart';
import 'package:provider/provider.dart';
import 'package:p_plus/providers/autenticacao_provider.dart';
import 'package:p_plus/services/acao_service.dart';
import 'package:p_plus/dtos/acao.dart';

class DetalhesScreen extends StatefulWidget {
  const DetalhesScreen({super.key});

  @override
  State<DetalhesScreen> createState() => _DetalhesScreenState();
}

class _DetalhesScreenState extends State<DetalhesScreen> {
  int periodoSelecionado = 0;
  bool _carregando = true;
  List<Acao> _todasAcoes = [];
  List<_CelulaResumo> _celulasExibidas = [];
  List<_AcaoRanking> _rankingExibido = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _carregarAcoes();
  }

  Future<void> _carregarAcoes() async {
    final autenticacao = context.read<AutenticacaoProvider>();
    final idAnalista = autenticacao.token;
    if (idAnalista == null || idAnalista.isEmpty) return;

    try {
      final acaoService = AcaoService();
      final acoes = await acaoService.obterAcoesTotaisPorAnalista(idAnalista, null) ?? [];
      _todasAcoes = acoes;
      _atualizarPeriodo();
    } catch (e) {
      if (mounted) {
        setState(() {
          _carregando = false;
        });
      }
    }
  }


  bool _isNoPeriodo(DateTime date, int periodoIdx) {
    final now = DateTime.now();
    final hoje = DateTime(now.year, now.month, now.day);
    final dataAcao = DateTime(date.year, date.month, date.day);

    // Posição presente nos períodos do arquivo constants.dart
    switch (periodoIdx) {
      case 0: // Dia (Hoje)
        return dataAcao.isAtSameMomentAs(hoje);
      case 1: // Semana (últimos 7 dias)
        final limiteSemana = hoje.subtract(const Duration(days: 7));
        return dataAcao.isAfter(limiteSemana.subtract(const Duration(seconds: 1))) && 
               dataAcao.isBefore(hoje.add(const Duration(days: 1)));
      case 2: // 15 dias (últimos 15 dias)
        final limite15 = hoje.subtract(const Duration(days: 15));
        return dataAcao.isAfter(limite15.subtract(const Duration(seconds: 1))) && 
               dataAcao.isBefore(hoje.add(const Duration(days: 1)));
      case 3: // Mês atual
        return dataAcao.year == hoje.year && dataAcao.month == hoje.month;
      case 4: // Mês anterior
        final mesAnterior = hoje.month == 1 ? 12 : hoje.month - 1;
        final anoAnterior = hoje.month == 1 ? hoje.year - 1 : hoje.year;
        return dataAcao.year == anoAnterior && dataAcao.month == mesAnterior;
      default:
        return false;
    }
  }

  bool _isDireta(String tipoAcao) {
    final lower = tipoAcao.toLowerCase();
    if (lower == 'direta') return true;
    if (lower == 'indireta') return false;
    return false;
  }

  void _atualizarPeriodo() {
    final acoesNoPeriodo = _todasAcoes.where((acao) {
      final date = CustomDateUtils.converterData(acao.dataAcao);
      if (date == null) return false;
      return _isNoPeriodo(date, periodoSelecionado);
    }).toList();


    final Map<String, List<Acao>> porCelula = {};
    for (var acao in acoesNoPeriodo) {
      final cel = acao.celula ?? '<desconhecido>';
      porCelula.putIfAbsent(cel, () => []).add(acao);
    }

    final coresCelulas = const [
      Color(0xFF056D10),
      Color(0xFFD5007D),
      Color(0xFF2AB7A9),
      Color(0xFFE46A00),
    ];

    final List<_CelulaResumo> listCelulas = [];
    porCelula.forEach((celula, acoes) {
      int diretas = acoes.where((a) => _isDireta(a.tipoAcao ?? '')).length;
      int indiretas = acoes.length - diretas;
      listCelulas.add(_CelulaResumo(celula, diretas, indiretas, Colors.grey));
    });

    listCelulas.sort((a, b) => (b.diretas + b.indiretas).compareTo(a.diretas + a.indiretas));
    
    final List<_CelulaResumo> top4Celulas = [];
    for (int i = 0; i < listCelulas.length && i < 4; i++) {
      final c = listCelulas[i];
      top4Celulas.add(_CelulaResumo(
        c.nome,
        c.diretas,
        c.indiretas,
        coresCelulas[i % coresCelulas.length],
      ));
    }


    final Map<String, int> contagemAcoes = {};
    for (var acao in acoesNoPeriodo) {
      final desc = acao.acao ?? '<desconhecido>';
      contagemAcoes[desc] = (contagemAcoes[desc] ?? 0) + 1;
    }

    final List<_AcaoRanking> listRanking = [];
    contagemAcoes.forEach((nome, total) {
      listRanking.add(_AcaoRanking(nome, total));
    });

    listRanking.sort((a, b) => b.total.compareTo(a.total));

    final top10Ranking = listRanking.take(10).toList();

    if (mounted) {
      setState(() {
        _celulasExibidas = top4Celulas;
        _rankingExibido = top10Ranking;
        _carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Período',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          Wrap(
            spacing: 8,
            children: List.generate(PERIODOS.length, (index) {
              return ChoiceChip(
                label: Text(PERIODOS[index]),
                selected: periodoSelecionado == index,
                selectedColor: const Color(0xFF00AEEF),
                labelStyle: TextStyle(
                  color: periodoSelecionado == index
                      ? Colors.white
                      : Colors.black,
                ),
                onSelected: (_) {
                  setState(() {
                    periodoSelecionado = index;
                    _carregando = true;
                  });
                  _atualizarPeriodo();
                },
              );
            }),
          ),
          const SizedBox(height: 24),
          const Text(
            'Top 4 células no período',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _celulasExibidas.isEmpty
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text('Nenhuma ação realizada neste período.'),
                )
              : GridView.builder(
                  itemCount: _celulasExibidas.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.5,
                  ),
                  itemBuilder: (context, index) {
                    return _CelulaCard(celula: _celulasExibidas[index]);
                  },
                ),

          const SizedBox(height: 24),

          const Text(
            'Top 10 ações realizadas',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          _rankingExibido.isEmpty
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text('Nenhuma ação realizada neste período.'),
                )
              : Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x12000000),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: List.generate(_rankingExibido.length, (index) {
                      final item = _rankingExibido[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            Text(
                              '${index + 1}.',
                              style: const TextStyle(
                                color: Color(0xFF00AEEF),
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(width: 10),

                            Expanded(
                              child: Text(
                                item.nome,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                            Text(
                              item.total.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
        ],
      ),
    );
  }
}

class _CelulaCard extends StatelessWidget {
  const _CelulaCard({required this.celula});

  final _CelulaResumo celula;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: celula.cor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            celula.nome,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const Spacer(),

          Row(
            children: [
              Expanded(
                child: _MiniIndicador(titulo: 'D', valor: celula.diretas),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: _MiniIndicador(titulo: 'I', valor: celula.indiretas),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniIndicador extends StatelessWidget {
  const _MiniIndicador({required this.titulo, required this.valor});

  final String titulo;
  final int valor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$titulo $valor',
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _CelulaResumo {
  const _CelulaResumo(this.nome, this.diretas, this.indiretas, this.cor);

  final String nome;
  final int diretas;
  final int indiretas;
  final Color cor;
}

class _AcaoRanking {
  const _AcaoRanking(this.nome, this.total);

  final String nome;
  final int total;
}
