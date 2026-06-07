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
  
}