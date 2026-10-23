class Aviso {
  const Aviso({required this.id, required this.titulo, required this.corpo});

  final int id;
  final String titulo;
  final String corpo;

  factory Aviso.fromJson(Map<String, dynamic> json) {
    return Aviso(
      id: json['id'] as int,
      titulo: json['title'] as String,
      corpo: json['body'] as String,
    );
  }
}
