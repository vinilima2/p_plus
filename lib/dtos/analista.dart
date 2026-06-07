import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:p_plus/dtos/gestor.dart';

class Analista extends Gestor {
  bool? status; // 1 = ATIVO <---> 0 = INATIVO
  String? descricaoStatus; // descreve a justificativa do status do analista para detalhamento

  Analista({ 
    super.id,
    required super.nome,
    required super.email,
    required super.senha,
    required super.idEquipe,
    required this.status,
    required this.descricaoStatus,
  });

  factory Analista.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Analista(
      id: doc.id,
      idEquipe: data['id_equipe'] ?? '<desconhecido>',
      nome: data['nome'] ?? '<desconhecido>',
      email: data['email'] ?? '<desconhecido>',
      senha: data['senha'] ?? '<desconhecido>',
      status: data['status'] ?? '<desconhecido>',
      descricaoStatus: data['descricao_status'] ?? '<desconhecido>'
    );
  }
}