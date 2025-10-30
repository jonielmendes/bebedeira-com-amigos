class Categoria {
  final String id;
  final String nome;
  final String descricao;

  Categoria({
    required this.id,
    required this.nome,
    required this.descricao,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: json['id'] as String,
      nome: json['nome'] as String,
      descricao: json['descricao'] as String,
    );
  }
}
