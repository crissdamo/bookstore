class Autor {
  int? id;
  String? nome;
  String? sobrenome;

  Autor(
    this.id,
    this.nome,
    this.sobrenome,
  );

  Autor copyWith({int? id, String? nome, String? sobrenome}) {
    return Autor(
      id ?? this.id,
      nome ?? this.nome,
      sobrenome ?? this.sobrenome,
    );
  }

  @override
  String toString() {
    return 'Autor { nome: $nome, sobrenome: $sobrenome}';
  }
}
