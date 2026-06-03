import 'package:flutter/material.dart';
import 'package:p_plus/providers/autenticacao_provider.dart';
import 'package:p_plus/routes/routes.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AutenticacaoProvider>(
      create: (_) => AutenticacaoProvider(),
      child: MaterialApp(
        title: 'P+',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blueAccent,
          ),
        ),
        routes: Routes.rotasPadrao,
        initialRoute: 'login',
      ),
    );
  }
}
