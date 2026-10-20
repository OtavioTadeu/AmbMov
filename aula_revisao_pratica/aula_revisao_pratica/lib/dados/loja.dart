import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aula_revisao_pratica/model/item.dart';

const String urlReceitas = 'https://dummyjson.com/recipes?limit=12';
const String chaveFavoritos = 'aula21_favoritos';

class Loja extends ChangeNotifier {
  List<Item> itens = [];
  final Set<int> favoritos = {};
  final Map<int, String> observacoes = {};
  bool carregando = true;
  String? erro;

  bool ehFavorito(int id) => favoritos.contains(id);

  String? observacaoDe(int id) => observacoes[id];

  Future<void> carregar() async {
    carregando = true;
    erro = null;
    notifyListeners();
    try {
      final resposta = await http.get(Uri.parse(urlReceitas));
      if (resposta.statusCode != 200) {
        throw Exception('HTTP ${resposta.statusCode}');
      }
      final mapa = jsonDecode(resposta.body) as Map<String, dynamic>;
      final lista = mapa['recipes'] as List<dynamic>;
      itens = [
        for (final bruto in lista) Item.fromJson(bruto as Map<String, dynamic>),
      ];
    } catch (_) {
      erro = 'Não foi possível carregar a lista.';
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  Future<void> lerFavoritos() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList(chaveFavoritos) ?? [];
    favoritos
      ..clear()
      ..addAll(ids.map(int.parse));
    notifyListeners();
  }

  Future<void> alternarFavorito(int id) async {
    if (favoritos.contains(id)) {
      favoritos.remove(id);
    } else {
      favoritos.add(id);
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      chaveFavoritos,
      [for (final itemId in favoritos) '$itemId'],
    );
  }

  void salvarObservacao(int id, String texto) {
    observacoes[id] = texto;
    notifyListeners();
  }
}
