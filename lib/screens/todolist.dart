
import 'package:flutter/material.dart';

import '../model/exercicio.dart';
import '../util/dbhelper.dart';
import 'cadastro.dart';
import 'detalhes.dart';

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => TodoListState();
}

class TodoListState extends State<TodoList> {
  final DbHelper helper = DbHelper();

  List<Exercicio> exercicios = [];
  bool carregando = true;
  String? erro;

  @override
  void initState() {
    super.initState();
    carregarExercicios();
  }

  // Busca os exercícios no Cloud Firestore
  Future<void> carregarExercicios() async {
    setState(() {
      carregando = true;
      erro = null;
    });

    try {
      final resultado = await helper.getExercicios();

      if (!mounted) return;

      setState(() {
        exercicios = resultado;
        carregando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        erro = e.toString();
        carregando = false;
      });
    }
  }

  // Define uma cor de acordo com o nível
  Color _getCorPorNivel(String nivel) {
    switch (nivel.trim().toLowerCase()) {
      case 'iniciante':
        return const Color(0xFF2E7D32);
      case 'intermediário':
      case 'intermediario':
        return const Color(0xFF1976D2);
      case 'avançado':
      case 'avancado':
        return const Color(0xFF616161);
      default:
        return const Color(0xFF2E7D32);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Bora Continuar_v2',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: construirLista(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Cadastro(),
            ),
          );

          if (!mounted) return;
          await carregarExercicios();
        },
        tooltip: 'Adicionar exercício',
        backgroundColor: const Color(0xFF2E7D32),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget construirLista() {
    if (carregando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (erro != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Não foi possível carregar os exercícios.'),
              const SizedBox(height: 8),
              Text(erro!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: carregarExercicios,
                child: const Text('TENTAR NOVAMENTE'),
              ),
            ],
          ),
        ),
      );
    }

    if (exercicios.isEmpty) {
      return const Center(
        child: Text('Nenhum exercício cadastrado.'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: exercicios.length,
      itemBuilder: (context, position) {
        final exercicio = exercicios[position];

        return Card(
          color: Colors.white,
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            leading: CircleAvatar(
              radius: 12,
              backgroundColor: _getCorPorNivel(exercicio.nivel),
            ),
            title: Text(
              exercicio.nome,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                '${exercicio.grupoMuscular}\n'
                    '${exercicio.series} séries • '
                    '${exercicio.repeticoes} repetições\n'
                    '${exercicio.duracao} segundos • '
                    '${exercicio.nivel}',
              ),
            ),
            trailing: const Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Detalhes(
                    exercicio: exercicio,
                  ),
                ),
              );

              if (!mounted) return;
              await carregarExercicios();
            },
          ),
        );
      },
    );
  }
}
