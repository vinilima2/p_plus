import 'package:cloud_firestore/cloud_firestore.dart';

class Gestor {

  String? id;
  String? nome;
  String? email;
  String? senha;

  Gestor({
    this.id,
    required this.nome,
    required this.email,
    required this.senha
  });
  
  factory Gestor.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Gestor(
      id: doc.id,
      nome: data['nome'] ?? '<desconhecido>',
      email: data['email'] ?? '<desconhecido>',
      senha: data['senha'] ?? '<desconhecido>'
    );
  }
}