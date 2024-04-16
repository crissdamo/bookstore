class Categoria {
  int? id;
  String? descricao;

  Categoria(
    this.id,
    this.descricao,
  );

  Categoria copyWith({int? id, String? descricao}) {
    return Categoria(
      id ?? this.id,
      descricao ?? this.descricao,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'descricao': descricao,
    };
  }

  @override
  String toString() {
    return 'Categoria { descricao: $descricao,}';
  }
}
