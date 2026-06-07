import 'package:cloud_firestore/cloud_firestore.dart';

class AcessoUsuario {
  String? idUsuario;
  String? tipoUsuario;

  AcessoUsuario({
    required this.idUsuario,
    required this.tipoUsuario
  });
}

class LoginService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<AcessoUsuario?> login(String email, String senha) async {
    try {
      QuerySnapshot snapshot = await _db.collection('analista').where(
        'email', isEqualTo: email
      ).where(
        'senha', isEqualTo: senha
      ).get();
      if (snapshot.size != 0) {
        return AcessoUsuario(idUsuario: snapshot.docs.first.id, tipoUsuario: 'Analista');
      }
      snapshot = await _db.collection('gestor').where(
        'email', isEqualTo: email
      ).where(
        'senha', isEqualTo: senha
      ).get();
      if (snapshot.size != 0) {
        return AcessoUsuario(idUsuario: snapshot.docs.first.id, tipoUsuario: 'Gestor');
      }
      return null;
    } catch(error) {
      throw "Erro durante tentativa de login: ${error.toString()}";
    }
  } 
}