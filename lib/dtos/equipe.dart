class Equipe {
  
  String? id; // tipo de dados: UUID
  int? metaAcoesIndiretas; // tipo de dados: INT
  int? metaAcoesDiretas; // tipo de dados: INT
  String? idGestor; // tipo de dados: UUID

  Equipe({
    this.id,
    required this.metaAcoesIndiretas,
    required this.metaAcoesDiretas,
    required this.idGestor
  });

}
