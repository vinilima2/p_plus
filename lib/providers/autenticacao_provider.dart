import 'package:flutter/material.dart';

class AutenticacaoProvider extends ChangeNotifier {
  String? token;
  String? nome;
  String? email;

  void atualizarDados({required String nome, required String email, required String token}) {
    this.nome = nome;
    this.email = email;
    this.token = token;
    notifyListeners();
  }
}