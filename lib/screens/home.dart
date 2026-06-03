import 'package:flutter/material.dart';
import 'package:p_plus/providers/autenticacao_provider.dart';
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

  @override
  void initState() {
    super.initState();
  }

  void mudarTela(int novoIndice) {
    setState(() {
      indice = novoIndice;
    });
  }


  @override
  Widget build(BuildContext context) {
    final autenticacao = context.read<AutenticacaoProvider>();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            Text(autenticacao.nome ?? ''),
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.logout),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: IndexedStack(
            index: indice,
            children: [
              Container(child: Column(
                children: [
                  Text('Tela 1'),
                  ElevatedButton(onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext modalContext) {
                        return AlertDialog(
                            title: SingleChildScrollView(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Titulo do Modal'
                                  ),
                                ],
                              ),
                            ),
                            content: Container(
                              child:Text('Condeúdo'),
                            ),
                            actionsAlignment: MainAxisAlignment.center,
                            actions: [
                              IconButton(onPressed: (){}, icon: Icon(Icons.save))
                            ]);
                      },
                    );
                  }, child: Text('Exemplo do modal'))
                ],
              )),
              Container(child: Text('2')),
              Container(child: Text('3')),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: mudarTela,
          currentIndex: indice,
          items: [
            BottomNavigationBarItem(label: '', icon: Icon(Icons.home)),
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
