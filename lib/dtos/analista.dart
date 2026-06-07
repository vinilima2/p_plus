import 'package:p_plus/dtos/gestor.dart';

class Analista extends Gestor {
  bool? status; // 1 = ATIVO <---> 2 = INATIVO
  String? descricaoStatus; // descreve a justificativa do status do analista para detalhamento
  String? idEquipe;

  Analista({ 
    String? id,
    required String nome,
    required String email,
    required String senha,
    required this.status,
    required this.descricaoStatus,
    required this.idEquipe
  }): super(id: id, nome: nome, email: email, senha: senha );
}