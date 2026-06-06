import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; 
import 'package:p_plus/firebase_options.dart'; // O arquivo gerado pelo FlutterFire

import 'package:p_plus/providers/autenticacao_provider.dart';
import 'package:p_plus/routes/routes.dart';
import 'package:provider/provider.dart';

void main() async {
  // As duas linhas abaixo iniciam o Firebase antes de desenhar a tela
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform, name: 'app-p-plus');

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
        debugShowCheckedModeBanner: false, // Tira a faixa de "Debug" do canto
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        ),
        routes: Routes.rotasPadrao,
        initialRoute: 'login',
      ),
    );
  }
}
