import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:p_plus/dtos/acao.dart';

class AcaoService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<Acao?> obterAcao(String id) async {
    try {
      DocumentSnapshot snapshot = await _db.collection('acao').doc(id).get();
      if (snapshot.exists) {
        return Acao.fromFirestore(snapshot);
      }
      else {
        return null;
      }
    } catch (error) {
      throw "Erro ao obter Ação: ${error.toString()}";
    }
  }

  Future<List<Acao>?> obterAcoesTotaisPorAnalista(String idAnalista, String? dataAcao) async {
    try {
      QuerySnapshot snapshot = dataAcao == null ? await _db.collection('acao').where(
        'id_analista', isEqualTo: idAnalista
      ).get() : await _db.collection('acao').where(
        'id_analista', isEqualTo: idAnalista
      ).where(
        'data_acao', isEqualTo: dataAcao
      ).get();
      if (snapshot.size != 0) {
        return snapshot.docs.map((doc) => Acao.fromFirestore(doc)).toList();
      }
      else {
        return null;
      }
    } catch (error) {
      throw "Erro ao obter Ações do Analista: ${error.toString()}";
    }
  }

  Future<List<Acao>?> obterAcoesIndiretasPorAnalista(String idAnalista, String? dataAcao) async {
    try {
      QuerySnapshot snapshot = dataAcao == null ? await _db.collection('acao').where(
        'id_analista', isEqualTo: idAnalista
      ).where(
        'tipo_acao', isEqualTo: 'Indireta'
      ).get() : await _db.collection('acao').where(
        'id_analista', isEqualTo: idAnalista
      ).where(
        'data_acao', isEqualTo: dataAcao
      ).where(
        'tipo_acao', isEqualTo: 'Indireta'
      ).get();
      if (snapshot.size != 0) {
        return snapshot.docs.map((doc) => Acao.fromFirestore(doc)).toList();
      }
      else {
        return null;
      }
    } catch (error) {
      throw "Erro ao obter Ações Indiretas do Analista: ${error.toString()}";
    }
  }

  Future<List<Acao>?> obterAcoesDiretasPorAnalista(String idAnalista, String? dataAcao) async {
      try {
        QuerySnapshot snapshot = dataAcao == null ? await _db.collection('acao').where(
          'id_analista', isEqualTo: idAnalista
        ).where(
          'tipo_acao', isEqualTo: 'Direta'
        ).get() : await _db.collection('acao').where(
          'id_analista', isEqualTo: idAnalista
        ).where(
          'data_acao', isEqualTo: dataAcao
        ).where(
          'tipo_acao', isEqualTo: 'Direta'
        ).get();
        if (snapshot.size != 0) {
          return snapshot.docs.map((doc) => Acao.fromFirestore(doc)).toList();
        }
        else {
          return null;
        }
    } catch (error) {
      throw "Erro ao obter Ações Diretas do Analista: ${error.toString()}";
    }
  }    

  Future<void> excluirAcao(String id) async {
    try {
      await _db.collection('acao').doc(id).delete();
    } catch (error) {
      throw "Erro ao excluir Ação: ${error.toString()}";
    }       
  }
}