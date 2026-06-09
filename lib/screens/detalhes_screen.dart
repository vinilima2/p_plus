import 'package:flutter/material.dart';

class DetalhesScreen extends StatefulWidget {
  const DetalhesScreen({super.key});

  @override
  State<DetalhesScreen> createState() => _DetalhesScreenState();
}

class _DetalhesScreenState extends State<DetalhesScreen> {
  int periodoSelecionado = 0;

  final List<String> periodos = const [
    'Dia',
    'Semana',
    '15 dias',
    'Mês atual',
    'Mês anterior',
  ];

  final List<_CelulaResumo> celulas = const [
    _CelulaResumo('Retenção', 40, 12, Color(0xFF056D10)),
    _CelulaResumo('SAC', 35, 10, Color(0xFFD5007D)),
    _CelulaResumo('Suporte', 27, 8, Color(0xFF2AB7A9)),
    _CelulaResumo('Ouvidoria', 25, 6, Color(0xFFE46A00)),
  ];

  final List<_AcaoRanking> ranking = const [
    _AcaoRanking('Feedback de empatia', 40),
    _AcaoRanking('Correção de script obrigatório', 35),
    _AcaoRanking('Ajuste de tabulação no CRM', 27),
    _AcaoRanking('Coaching de encerramento', 25),
    _AcaoRanking('Reescuta de atendimento crítico', 21),
    _AcaoRanking('Orientação sobre sondagem', 18),
    _AcaoRanking('Tratativa de rechamada', 15),
    _AcaoRanking('Alinhamento de oferta/benefício', 12),
    _AcaoRanking('Calibração de nota QA', 10),
    _AcaoRanking('Registro de oportunidade de melhoria', 8),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top 4 células no período',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          GridView.builder(
            itemCount: celulas.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.5,
            ),
            itemBuilder: (context, index) {
              return _CelulaCard(celula: celulas[index]);
            },
          ),

          const SizedBox(height: 24),

          const Text(
            'Top 10 ações realizadas',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Container(
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
              children: List.generate(ranking.length, (index) {
                final item = ranking[index];

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

          const SizedBox(height: 24),

          const Text(
            'Período',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Wrap(
            spacing: 8,
            children: List.generate(periodos.length, (index) {
              return ChoiceChip(
                label: Text(periodos[index]),
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
                  });
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _CelulaCard extends StatelessWidget {
  const _CelulaCard({
    required this.celula,
  });

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
                child: _MiniIndicador(
                  titulo: 'D',
                  valor: celula.diretas,
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: _MiniIndicador(
                  titulo: 'I',
                  valor: celula.indiretas,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniIndicador extends StatelessWidget {
  const _MiniIndicador({
    required this.titulo,
    required this.valor,
  });

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
  const _CelulaResumo(
    this.nome,
    this.diretas,
    this.indiretas,
    this.cor,
  );

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