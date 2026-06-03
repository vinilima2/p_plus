import 'package:cloud_firestore/cloud_firestore.dart';

class AcaoModel {
  final String? id; // Pode ser nulo antes de salvar no banco
  final String usuarioId;
  final String analistaNome;
  final String tipoAcao;
  final DateTime? dataRealizacao;

  AcaoModel({
    this.id,
    required this.usuarioId,
    required this.analistaNome,
    required this.tipoAcao,
    this.dataRealizacao,
  });

  // Lê do Firestore e converte a Data do formato Timestamp para DateTime do Flutter
  factory AcaoModel.fromMap(Map<String, dynamic> map, String documentId) {
    return AcaoModel(
      id: documentId,
      usuarioId: map['usuario_id'] ?? '',
      analistaNome: map['analista_nome'] ?? '',
      tipoAcao: map['tipo_acao'] ?? '',
      dataRealizacao: map['data_realizacao'] != null
          ? (map['data_realizacao'] as Timestamp).toDate()
          : null,
    );
  }

  // Envia para o Firestore transformando novamente em Timestamp ou pegando a hora do servidor
  Map<String, dynamic> toMap() {
    return {
      'usuario_id': usuarioId,
      'analista_nome': analistaNome,
      'tipo_acao': tipoAcao,
      'data_realizacao': dataRealizacao != null
          ? Timestamp.fromDate(dataRealizacao!)
          : FieldValue.serverTimestamp(),
    };
  }
}
