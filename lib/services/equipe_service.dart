import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:p_plus/dtos/equipe.dart';

class EquipeService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<Equipe?> obterEquipe(String id) async {
    try {
      DocumentSnapshot snapshot = await _db.collection('equipe').doc(id).get();
      if (snapshot.exists) {
        return Equipe.fromFirestore(snapshot);
      }
      else {
        return null;
      }
    } catch (error) {
      throw "Erro ao obter Equipe: ${error.toString()}";
    }
  }

  Future<void> editarMetas(String idEquipe, int metaAcoesIndiretas, int metaAcoesDiretas) async {
    try {
      await _db.collection('equipe').doc(idEquipe).update({
        'meta_acoes_diretas': metaAcoesDiretas,
        'meta_acoes_indiretas': metaAcoesIndiretas
      });
    } catch (error) {
      throw "Erro ao editar metas da Equipe: ${error.toString()}";
    }
  }
}