import 'package:flutter/material.dart';
import 'package:p_plus/providers/autenticacao_provider.dart';
import 'package:p_plus/screens/detalhes_screen.dart';
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

  void mudarTela(int novoIndice) {
    setState(() {
      indice = novoIndice;
    });
  }

  String _formatarDataHora(DateTime dataHora) {
    final diasSemana = [
      'Segunda-feira',
      'Terça-feira',
      'Quarta-feira',
      'Quinta-feira',
      'Sexta-feira',
      'Sábado',
      'Domingo',
    ];

    final dia = dataHora.day.toString().padLeft(2, '0');
    final mes = dataHora.month.toString().padLeft(2, '0');
    final hora = dataHora.hour.toString().padLeft(2, '0');
    final minuto = dataHora.minute.toString().padLeft(2, '0');
    final semana = diasSemana[dataHora.weekday - 1];

    return '$dia/$mes/${dataHora.year} - $semana - $hora:$minuto';
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
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Você atingiu 30% da sua meta diária!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
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
                      _formatarDataHora(DateTime.now()),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  indicadorCard(
                    titulo: 'Ações realizadas',
                    valor: '100',
                    cor: Colors.indigo,
                  ),
                  indicadorCard(
                    titulo: 'Ações diretas',
                    valor: '75',
                    cor: Colors.green,
                  ),
                  indicadorCard(
                    titulo: 'Ações indiretas',
                    valor: '25',
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