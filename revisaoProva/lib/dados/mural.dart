import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/aviso.dart';

const String urlAvisos = 'https://jsonplaceholder.typicode.com/posts?_limit=10';

class Mural extends ChangeNotifier {
  List<Aviso> avisos = [
    const Aviso(
      id: 1001,
      titulo: 'Biblioteca fecha às 21h',
      corpo: 'No sábado o horário é até 12h.',
    ),
    const Aviso(
      id: 1002,
      titulo: 'Prova prática na terça',
      corpo: 'O projeto já abre. A prova vale 20 pontos.',
    ),
  ];
  final Set<int> favoritos = {};
  bool carregando = false;
  String? erro;

  bool ehFavorito(int id) => favoritos.contains(id);

  Future<void> iniciar() async {
    await carregar();
    await lerFavoritos();
  }

  void adicionar(String titulo, String corpo) {
    int maiorId = 0;
    for (final a in avisos) {
      if (a.id > maiorId) {
        maiorId = a.id;
      }
    }
    final novoAviso = Aviso(
      id: maiorId + 1,
      titulo: titulo,
      corpo: corpo,
    );
    avisos.add(novoAviso);
    notifyListeners();
  }

  Future<void> carregar() async {
    carregando = true;
    erro = null;
    notifyListeners();

    try {
      final resposta = await http.get(Uri.parse(urlAvisos));
      if (resposta.statusCode != 200) {
        throw Exception('HTTP ${resposta.statusCode}');
      }
      final lista = jsonDecode(resposta.body) as List<dynamic>;
      avisos = [
        for (final item in lista)
          Aviso.fromJson(item as Map<String, dynamic>),
      ];
    } catch (_) {
      erro = 'Não foi possível carregar os avisos.';
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  Future<void> alternarFavorito(int id) async {
    final bool favoritado;
    if (favoritos.contains(id)) {
      favoritos.remove(id);
      favoritado = false;
    } else {
      favoritos.add(id);
      favoritado = true;
    }
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('favorito_$id', favoritado);
  }

  Future<void> lerFavoritos() async {
    final prefs = await SharedPreferences.getInstance();
    favoritos.clear();
    for (final aviso in avisos) {
      final fav = prefs.getBool('favorito_${aviso.id}') ?? false;
      if (fav) {
        favoritos.add(aviso.id);
      }
    }
    notifyListeners();
  }
}
