import 'package:cloud_firestore/cloud_firestore.dart';

class Gestor {

  String? id;
  String? nome;
  String? email;
  String? senha;
  String? idEquipe;

  Gestor({
    this.id,
    required this.nome,
    required this.email,
    required this.senha,
    required this.idEquipe
  });
  
  factory Gestor.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Gestor(
      id: doc.id,
      nome: data['nome'] ?? '<desconhecido>',
      email: data['email'] ?? '<desconhecido>',
      senha: data['senha'] ?? '<desconhecido>',
      idEquipe: data['id_equipe'] ?? '<desconhecido>'
    );
  }
}