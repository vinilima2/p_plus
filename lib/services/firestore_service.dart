import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart'; // <-- Adicionado para o debugPrint funcionar

class FirestoreService {
  // Cria a "ponte" principal com a sua base de dados
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ==========================================================
  // CONSULTA 1: Buscar o total de ações de um analista no mês
  // ==========================================================
  Future<int> buscarTotalAcoesDoMes(String usuarioId) async {
    try {
      // Filtra as ações do mês atual
      DateTime dataInicioMes = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        1,
      );

      QuerySnapshot query = await _db
          .collection('acoes_realizadas')
          .where('usuario_id', isEqualTo: usuarioId)
          .where(
            'data_realizacao',
            isGreaterThanOrEqualTo: Timestamp.fromDate(dataInicioMes),
          )
          .get();

      return query.docs.length;
    } catch (e) {
      debugPrint("Erro ao buscar ações: $e"); // <-- Corrigido aqui
      return 0; // Retorna 0 em caso de erro para não quebrar a app
    }
  }

  // ==========================================================
  // CONSULTA 2: Inserir uma nova ação no banco
  // ==========================================================
  Future<void> registrarNovaAcao(
    String usuarioId,
    String tipoAcao,
    String analistaNome,
  ) async {
    try {
      await _db.collection('acoes_realizadas').add({
        'usuario_id': usuarioId,
        'analista_nome': analistaNome,
        'tipo_acao': tipoAcao,
        'data_realizacao': FieldValue.serverTimestamp(),
      });
      debugPrint("Ação registada com sucesso!"); // <-- Corrigido aqui
    } catch (e) {
      debugPrint("Erro ao registar ação: $e"); // <-- Corrigido aqui
    }
  }
}
