import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:p_plus/dtos/acao.dart';
import 'package:p_plus/dtos/analista.dart';
import 'package:p_plus/services/acao_service.dart';

class AnalistaService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<Analista?> obterAnalista(String id) async {
    try {
      DocumentSnapshot snapshot = await _db.collection('analista').doc(id).get();
      if (snapshot.exists) {
        return Analista.fromFirestore(snapshot);
      }
      else {
        return null;
      }
    } catch (error) {
      throw "Erro ao obter Analista: ${error.toString()}";
    }
  }

  Future<List<Analista>?> obterAnalistasPorEquipe(String idEquipe) async {
    try {
      QuerySnapshot snapshot = await _db.collection('analista').where(
        'id_equipe', isEqualTo: idEquipe
      ).get();
      if (snapshot.size != 0) {
        return snapshot.docs.map((doc) => Analista.fromFirestore(doc)).toList();
      }
      else {
        return null;
      }
    } catch (error) {
      throw "Erro ao obter Analistas da Equipe: ${error.toString()}";
    }
  }

  Future<void> editarDadosAnalista(String idAnalista, String nome, String email) async {
    try {
      await _db.collection('analista').doc(idAnalista).update({
        'nome': nome,
        'email': email
      });
    } catch (error) {
      throw "Erro ao editar cadastro de Analista: ${error.toString()}";
    }
  }

  Future<void> desbloquearAnalista(String idAnalista) async {
    try {
      await _db.collection('analista').doc(idAnalista).update({
        'status': 1, // status se torna 'ativo'
        'descricao_status': 'Ativo'
      });
    } catch (error) {
      throw "Erro ao editar cadastro de Analista: ${error.toString()}";
    }    
  }

  Future<void> bloquearAnalista(String idAnalista, String descricaoStatus) async {
    try {
      await _db.collection('analista').doc(idAnalista).update({
        'status': 0, // status se torna 'inativo'
        'descricao_status': descricaoStatus // provém de uma lista de descrições pré-definidas no front-end
      });
    } catch (error) {
      throw "Erro ao editar cadastro de Analista: ${error.toString()}";
    }       
  }

  Future<void> excluirAnalista(String id) async {
    try {
      AcaoService acaoService = AcaoService();
      List<Acao>? acoes = await acaoService.obterAcoesTotaisPorAnalista(id, null);
      if (acoes != null) {
        for (Acao acao in acoes) {
        acaoService.excluirAcao(acao.id ?? '');
        }
      }
      await _db.collection('analista').doc(id).delete();
    } catch (error) {
      throw "Erro ao excluir Analista: ${error.toString()}";
    }    
  }

  Future<String?> criarAnalista(Analista analista) async {
    try {
      QuerySnapshot snapshotAnalista = await _db.collection('analista').where(
        'email', isEqualTo: analista.email
      ).get();
      QuerySnapshot snapshotGestor = await _db.collection('gestor').where(
        'email', isEqualTo: analista.email
      ).get();
      if (snapshotAnalista.size != 0 || snapshotGestor.size != 0) {
        return null; // identificou que o e-mail a ser cadastrado já existe na base
      }
      DocumentReference novoAnalista = await _db.collection('analista').add({
        'nome': analista.nome,
        'email': analista.email,
        'senha': analista.senha,
        'id_equipe': analista.idEquipe,
        'status': 1,
        'descricao_status': 'Ativo'
      });
      return novoAnalista.id;
    } catch (error) {
      throw "Erro ao criar Analista: ${error.toString()}";
    }       
  }
}