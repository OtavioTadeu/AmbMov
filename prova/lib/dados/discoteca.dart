// Busca na internet e favoritos salvos no aparelho.
// ignore_for_file: unused_import

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/album.dart';

const String urlAlbuns =
    'https://itunes.apple.com/search?term=beatles&entity=album&limit=12';
const String chaveFavoritos = 'prova_a_albuns';

class Discoteca extends ChangeNotifier {
  List<Album> itens = [
    const Album(
      id: 0,
      nome: 'Álbum de exemplo',
      artista: 'Artista',
      genero: 'Rock',
      imagemUrl: '',
    ),
  ];
  final Set<int> favoritos = {};
  final Map<int, String> observacoes = {};
  bool carregando = false;
  String? erro;

  bool ehFavorito(int id) => favoritos.contains(id);

  String? observacaoDe(int id) => observacoes[id];

  Future<void> iniciar() async {
    await carregar();
    await lerFavoritos();
  }

  void salvarObservacao(int id, String texto) {
    observacoes[id] = texto;
    notifyListeners();
  }

  Future<void> carregar() async {
    // TODO 5: Enquanto carrega, a tela mostra o indicador.
    // Se a busca falhar, a tela mostra a mensagem de erro.
    //
    // TODO 6: A lista passa a mostrar os álbuns da URL,
    // lidos de dentro de results.
    carregando = true;
    erro = null;
    notifyListeners();

    try {
      final resposta = await http.get(Uri.parse(urlAlbuns));
      if (resposta.statusCode != 200) {
        throw Exception('HTTP ${resposta.statusCode}');
      }
      final mapa = jsonDecode(resposta.body) as Map<String, dynamic>;
      final lista = mapa['results'] as List<dynamic>;
      itens = [
        for (final bruto in lista)
          Album.fromJson(bruto as Map<String, dynamic>),
      ];
    } catch (_) {
      erro = 'Não foi possível carregar os álbuns.';
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  Future<void> alternarFavorito(int id) async {
    // TODO 4: Favoritar e desfavoritar, e a estrela muda na hora.
    //
    // TODO 8: O favorito continua marcado depois de fechar o app.
    if (favoritos.contains(id)) {
      favoritos.remove(id);
    } else {
      favoritos.add(id);
    }
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      chaveFavoritos,
      [for (final albumId in favoritos) '$albumId'],
    );
  }

  Future<void> lerFavoritos() async {
    // TODO 8: Ao abrir de novo, os álbuns favoritos voltam marcados.
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList(chaveFavoritos) ?? [];
    favoritos
      ..clear()
      ..addAll(ids.map(int.parse));
    notifyListeners();
  }
}
