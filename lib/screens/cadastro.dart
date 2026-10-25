
import 'package:flutter/material.dart';

import '../model/exercicio.dart';
import '../util/dbhelper.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => CadastroState();
}

class CadastroState extends State<Cadastro> {
  final DbHelper helper = DbHelper();

  final TextEditingController nomeController = TextEditingController();
  final TextEditingController grupoMuscularController =
  TextEditingController();
  final TextEditingController seriesController = TextEditingController();
  final TextEditingController repeticoesController = TextEditingController();
  final TextEditingController duracaoController = TextEditingController();

  String nivel = "Iniciante";
  bool salvando = false;

  Future<void> salvarExercicio() async {
    // Verifica se os campos de texto estão preenchidos.
    if (nomeController.text.trim().isEmpty ||
        grupoMuscularController.text.trim().isEmpty ||
        seriesController.text.trim().isEmpty ||
        repeticoesController.text.trim().isEmpty ||
        duracaoController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha todos os campos.'),
        ),
      );
      return;
    }

    // Converte os números digitados.
    final int? series = int.tryParse(seriesController.text.trim());
    final int? repeticoes = int.tryParse(repeticoesController.text.trim());
    final int? duracao = int.tryParse(duracaoController.text.trim());

    if (series == null ||
        repeticoes == null ||
        duracao == null ||
        series <= 0 ||
        repeticoes <= 0 ||
        duracao < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Informe números válidos. Séries e repetições devem ser maiores que zero.',
          ),
        ),
      );
      return;
    }

    setState(() {
      salvando = true;
    });

    try {
      // Cria o exercício com os dados do formulário.
      final Exercicio exercicio = Exercicio(
        nomeController.text.trim(),
        grupoMuscularController.text.trim(),
        series,
        repeticoes,
        duracao,
        nivel,
      );

      // Aguarda a gravação no Cloud Firestore.
      await helper.insertExercicio(exercicio);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Exercício salvo com sucesso!'),
        ),
      );

      // Retorna à lista após salvar.
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar exercício: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          salvando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Novo exercício",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nomeController,
                decoration: const InputDecoration(
                  labelText: "Nome do exercício",
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: grupoMuscularController,
                decoration: const InputDecoration(
                  labelText: "Grupo muscular",
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: seriesController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Número de séries",
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: repeticoesController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Número de repetições",
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: duracaoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Duração em segundos",
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: nivel,
                decoration: const InputDecoration(
                  labelText: "Nível",
                ),
                items: const [
                  DropdownMenuItem(
                    value: "Iniciante",
                    child: Row(
                      children: [
                        Icon(
                          Icons.circle,
                          color: Color(0xFF2E7D32),
                          size: 14,
                        ),
                        SizedBox(width: 10),
                        Text("Iniciante"),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: "Intermediário",
                    child: Row(
                      children: [
                        Icon(
                          Icons.circle,
                          color: Color(0xFF1976D2),
                          size: 14,
                        ),
                        SizedBox(width: 10),
                        Text("Intermediário"),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: "Avançado",
                    child: Row(
                      children: [
                        Icon(
                          Icons.circle,
                          color: Color(0xFF616161),
                          size: 14,
                        ),
                        SizedBox(width: 10),
                        Text("Avançado"),
                      ],
                    ),
                  ),
                ],
                onChanged: (String? novoNivel) {
                  if (novoNivel != null) {
                    setState(() {
                      nivel = novoNivel;
                    });
                  }
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: salvando ? null : salvarExercicio,
                child: Text(
                  salvando ? "SALVANDO..." : "SALVAR",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nomeController.dispose();
    grupoMuscularController.dispose();
    seriesController.dispose();
    repeticoesController.dispose();
    duracaoController.dispose();
    super.dispose();
  }
}
