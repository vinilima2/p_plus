import 'package:cloud_firestore/cloud_firestore.dart';

class Equipe {

  String? id; 
  int? metaAcoesIndiretas; 
  int? metaAcoesDiretas; 
  String? idGestor; 

  Equipe({
    this.id,
    required this.metaAcoesIndiretas,
    required this.metaAcoesDiretas,
    required this.idGestor
  });

  factory Equipe.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Equipe(
      id: doc.id,
      metaAcoesIndiretas: data['meta_acoes_indiretas'] ?? 0,
      metaAcoesDiretas: data['meta_acoes_diretas'] ?? 0,
      idGestor: data['id_gestor'] ?? '<desconhecido>'
    );
  }
}
