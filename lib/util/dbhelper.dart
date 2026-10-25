
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/exercicio.dart';

class DbHelper {
  // Instância única da classe
  DbHelper._internal();

  static final DbHelper _dbHelper = DbHelper._internal();

  factory DbHelper() {
    return _dbHelper;
  }

  // Referência à coleção de exercícios no Firestore
  final CollectionReference<Map<String, dynamic>> _colecao =
  FirebaseFirestore.instance.collection('exercicios');

  // Insere um exercício na nuvem
  Future<String> insertExercicio(Exercicio exercicio) async {
    DocumentReference<Map<String, dynamic>> documento =
    await _colecao.add(exercicio.toMap());

    return documento.id;
  }

  // Recupera todos os exercícios
  Future<List<Exercicio>> getExercicios() async {
    QuerySnapshot<Map<String, dynamic>> resultado =
    await _colecao.orderBy('nome').get();

    return resultado.docs.map((documento) {
      return Exercicio.fromMap(
        documento.data(),
        documento.id,
      );
    }).toList();
  }

  // Recupera a quantidade de exercícios
  Future<int> getCount() async {
    QuerySnapshot<Map<String, dynamic>> resultado =
    await _colecao.get();

    return resultado.size;
  }

  // Atualiza um exercício existente
  Future<void> updateExercicio(Exercicio exercicio) async {
    if (exercicio.id == null) {
      throw Exception('O exercício não possui ID no Firestore.');
    }

    await _colecao.doc(exercicio.id).update(exercicio.toMap());
  }

  // Exclui um exercício pelo ID do documento
  Future<void> deleteExercicio(String id) async {
    await _colecao.doc(id).delete();
  }
}
