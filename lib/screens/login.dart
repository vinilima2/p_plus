import 'package:flutter/material.dart';
import 'package:p_plus/providers/autenticacao_provider.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            toolbarHeight:
            WidgetsBinding.instance.window.physicalSize.flipped.height / 4,
            flexibleSpace: Container(
               child: Icon(Icons.supervised_user_circle, size: 45,),),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Text('Bem vindo!'),
              Form(
                child: Card(
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(prefixText: 'E-mail'),
                      ),
                      TextFormField(
                        decoration: InputDecoration(prefixText: 'Senha'),
                      ),
                      FilledButton(onPressed: () {
                        context.read<AutenticacaoProvider>().atualizarDados(
                          token: 'abc123',
                          nome: 'Teste',
                          email: 'Teste',
                        );
                        Navigator.of(context).pushNamed('home');
                      }, child: Text('Entrar')),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        persistentFooterButtons: [
          Image.asset('assets/logo.png')
        ]
      ),
    );
  }
}
