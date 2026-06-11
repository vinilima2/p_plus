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

  bool _isDireta(String tipoAcao) {
    final lower = tipoAcao.toLowerCase();
    if (lower == 'direta') return true;
    if (lower == 'indireta') return false;
    final directKeywords = ['feedback', 'correção', 'coaching', 'reescuta', 'orientação', 'calibração', 'calibragem'];
    for (var kw in directKeywords) {
      if (lower.contains(kw)) return true;
    }
    return false;
  }

  Future<List<Acao>?> obterAcoesTotaisPorAnalista(String idAnalista, String? dataAcao) async {
    try {
      QuerySnapshot snapshot = await _db.collection('acao').where(
        'id_analista', isEqualTo: idAnalista
      ).get();
      
      if (snapshot.size == 0) {
        snapshot = await _db.collection('acao').where(
          'analista_id', isEqualTo: idAnalista
        ).get();
      }

      if (snapshot.size != 0) {
        List<Acao> acoes = snapshot.docs.map((doc) => Acao.fromFirestore(doc)).toList();
        if (dataAcao != null) {
          acoes = acoes.where((a) => a.dataAcao == dataAcao).toList();
        }
        return acoes;
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
      List<Acao>? todas = await obterAcoesTotaisPorAnalista(idAnalista, dataAcao);
      if (todas != null) {
        return todas.where((a) => !_isDireta(a.tipoAcao ?? '')).toList();
      }
      return null;
    } catch (error) {
      throw "Erro ao obter Ações Indiretas do Analista: ${error.toString()}";
    }
  }

  Future<List<Acao>?> obterAcoesDiretasPorAnalista(String idAnalista, String? dataAcao) async {
      try {
        List<Acao>? todas = await obterAcoesTotaisPorAnalista(idAnalista, dataAcao);
        if (todas != null) {
          return todas.where((a) => _isDireta(a.tipoAcao ?? '')).toList();
        }
        return null;
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