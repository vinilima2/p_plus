import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:p_plus/dtos/gestor.dart';

class GestorService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<Gestor?> obterGestor(String id) async {
    try {
      DocumentSnapshot snapshot = await _db.collection('gestor').doc(id).get();
      if (snapshot.exists) {
        return Gestor.fromFirestore(snapshot);
      }
      else {
        return null;
      }
    } catch (error) {
      throw "Erro ao obter Gestor: ${error.toString()}";
    }
  }
}