class Item {
  final int id;
  final String nome;
  final String imagemUrl;
  final int tempoMinutos;

  const Item({
    required this.id,
    required this.nome,
    required this.imagemUrl,
    required this.tempoMinutos,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] as int,
      nome: json['name'] as String,
      imagemUrl: json['image'] as String,
      tempoMinutos: json['prepTimeMinutes'] as int? ?? 0,
    );
  }
}
