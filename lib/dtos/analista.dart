import 'package:p_plus/dtos/gestor.dart';

class Analista extends Gestor {
  bool? status; // 1 = ATIVO <---> 2 = INATIVO
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
}