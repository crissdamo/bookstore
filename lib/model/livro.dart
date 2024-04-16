class Livro {
  int? id;
  String? titulo;
  String? ano;
  int? autor;
  int? categoria;

  Livro(
    this.id,
    this.titulo,
    this.ano,
    this.autor,
    this.categoria,
  );

  Livro copyWith(
      {int? id, String? titulo, String? ano, int? autor, int? categoria}) {
    return Livro(
      id ?? this.id,
      titulo ?? this.titulo,
      ano ?? this.ano,
      autor ?? this.autor,
      categoria ?? this.categoria,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'ano': ano,
      'autor': autor,
      "categoria": categoria
    };
  }

  @override
  String toString() {
    return 'Livro { titulo: $titulo, ano: $ano, titulo: $autor, autor: $autor, categoria: $categoria,}';
  }
}
