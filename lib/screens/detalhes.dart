
import 'package:flutter/material.dart';

import '../model/exercicio.dart';
import '../util/dbhelper.dart';

class Detalhes extends StatelessWidget {
  final Exercicio exercicio;

  const Detalhes({
    super.key,
    required this.exercicio,
  });

  Future<void> excluirExercicio(BuildContext context) async {
    // Mostra uma confirmação antes de excluir.
    final bool? confirmar = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Excluir exercício"),
          content: const Text(
            "Deseja realmente excluir este exercício?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("CANCELAR"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text("EXCLUIR"),
            ),
          ],
        );
      },
    );

    // Verifica se a tela continua ativa após fechar o diálogo.
    if (!context.mounted) return;

    // Só exclui se o usuário confirmar.
    if (confirmar != true) return;

    // Verifica se o exercício possui um ID do Firestore.
    if (exercicio.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível identificar o exercício.'),
        ),
      );
      return;
    }

    try {
      final DbHelper helper = DbHelper();

      // Exclui o documento pelo ID do Firestore.
      await helper.deleteExercicio(exercicio.id!);

      if (!context.mounted) return;

      // Volta para a lista após a exclusão.
      Navigator.pop(context);
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao excluir exercício: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Detalhes do exercício",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              exercicio.nome,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Grupo muscular: ${exercicio.grupoMuscular}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 12),
            Text(
              "Séries: ${exercicio.series}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 12),
            Text(
              "Repetições: ${exercicio.repeticoes}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 12),
            Text(
              "Duração: ${exercicio.duracao} segundos",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 12),
            Text(
              "Nível: ${exercicio.nivel}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => excluirExercicio(context),
                child: const Text("EXCLUIR EXERCÍCIO"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
