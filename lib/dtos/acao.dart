import 'package:cloud_firestore/cloud_firestore.dart';

class Acao {

  String? id;
  String? idAnalista;
  String? operador;
  String? matriculaOperador;
  String? turnoOperador;
  String? tipoAcao;
  String? acao;
  String? dataAcao;
  String? quartil;
  String? operacao;
  String? celula;

  Acao({
    this.id,
    required this.idAnalista,
    required this.operador,
    required this.matriculaOperador,
    required this.turnoOperador,
    required this.tipoAcao,
    required this.acao,
    required this.dataAcao,
    required this.quartil,
    required this.operacao,
    required this.celula
  });
  
  factory Acao.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Acao(
      id: doc.id,
      idAnalista: data['id_analista'] ?? data['analista_id'] ?? '<desconhecido>',
      operador: data['operador'] ?? '<desconhecido>',
      matriculaOperador: data['matricula_operador'] ?? '<desconhecido>',
      turnoOperador: data['turno_operador'] ?? '<desconhecido>',
      tipoAcao: data['tipo_acao'] ?? '<desconhecido>',
      acao: data['acao'] ?? data['tipo_acao'] ?? '<desconhecido>',
      dataAcao: data['data_acao'] ?? '<desconhecido>',
      quartil: data['quartil'] ?? '<desconhecido>',
      operacao: data['operacao'] ?? '<desconhecido>',
      celula: data['celula'] ?? '<desconhecido>' 
    );
  }
}