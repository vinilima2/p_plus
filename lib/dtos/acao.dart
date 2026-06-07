import 'package:cloud_firestore/cloud_firestore.dart';

class Acao {

  String? id;
  String? idAnalista;
  String? operador;
  String? matriculaOperador;
  String? turnoOperador;
  String? tipoAcao;
  String? acao;
  DateTime? dataAcao;
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
    Timestamp dataAcao = doc.get('data_acao');
    return Acao(
      id: doc.id,
      idAnalista: data['id_analista'] ?? '<desconhecido>',
      operador: data['operador'] ?? '<desconhecido>',
      matriculaOperador: data['matricula_operador'] ?? '<desconhecido>',
      turnoOperador: data['turno_operador'] ?? '<desconhecido>',
      tipoAcao: data['tipo_acao'] ?? '<desconhecido>',
      acao: data['acao'] ?? '<desconhecido>',
      dataAcao: dataAcao.toDate(),
      quartil: data['quartil'] ?? '<desconhecido>',
      operacao: data['operacao'] ?? '<desconhecido>',
      celula: data['celula'] ?? '<desconhecido>' 
    );
  }
}