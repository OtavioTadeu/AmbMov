class Album {
  const Album({
    required this.id,
    required this.nome,
    required this.artista,
    required this.genero,
    required this.imagemUrl,
  });

  final int id;
  final String nome;
  final String artista;
  final String genero;
  final String imagemUrl;

  // TODO 7: Cada item da API vira um álbum, com nome, artista, gênero e foto.
  // A foto aparece na lista e no detalhe.
  // Campos no JSON: collectionId, collectionName, artistName,
  // primaryGenreName, artworkUrl100.
  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['collectionId'] as int,
      nome: json['collectionName'] as String? ?? '',
      artista: json['artistName'] as String? ?? '',
      genero: json['primaryGenreName'] as String? ?? '',
      imagemUrl: json['artworkUrl100'] as String? ?? '',
    );
  }
}
