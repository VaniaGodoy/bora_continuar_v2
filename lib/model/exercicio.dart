
class Exercicio {
  // ID do documento no Firestore
  String? _id;

  String _nome;
  String _grupoMuscular;
  int _series;
  int _repeticoes;
  int _duracao;
  String nivel;

  // Construtor para um exercício novo
  Exercicio(
      this._nome,
      this._grupoMuscular,
      this._series,
      this._repeticoes,
      this._duracao,
      this.nivel,
      );

  // Construtor para um exercício já salvo
  Exercicio.withId(
      this._id,
      this._nome,
      this._grupoMuscular,
      this._series,
      this._repeticoes,
      this._duracao,
      this.nivel,
      );

  // Getters
  String? get id => _id;
  String get nome => _nome;
  String get grupoMuscular => _grupoMuscular;
  int get series => _series;
  int get repeticoes => _repeticoes;
  int get duracao => _duracao;

  // Setters com validação
  set nome(String novoNome) {
    if (novoNome.length <= 255) {
      _nome = novoNome;
    }
  }

  set grupoMuscular(String novoGrupoMuscular) {
    if (novoGrupoMuscular.length <= 255) {
      _grupoMuscular = novoGrupoMuscular;
    }
  }

  set series(int novasSeries) {
    if (novasSeries > 0) {
      _series = novasSeries;
    }
  }

  set repeticoes(int novasRepeticoes) {
    if (novasRepeticoes > 0) {
      _repeticoes = novasRepeticoes;
    }
  }

  set duracao(int novaDuracao) {
    if (novaDuracao >= 0) {
      _duracao = novaDuracao;
    }
  }

  // Setter para o nível

  // Converte os dados para salvar no Firestore
  Map<String, dynamic> toMap() {
    return {
      'nome': _nome,
      'grupoMuscular': _grupoMuscular,
      'series': _series,
      'repeticoes': _repeticoes,
      'duracao': _duracao,
      'nivel': nivel,
    };
  }

  // Cria um exercício com os dados vindos do Firestore
  factory Exercicio.fromMap(
      Map<String, dynamic> dados,
      String id,
      ) {
    return Exercicio.withId(
      id,
      dados['nome'] as String,
      dados['grupoMuscular'] as String,
      (dados['series'] as num).toInt(),
      (dados['repeticoes'] as num).toInt(),
      (dados['duracao'] as num).toInt(),
      dados['nivel'] as String,
    );
  }
}
