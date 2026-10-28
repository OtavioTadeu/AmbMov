// Nome: Otávio Tadeu Magalhães Ferreira
// Matrícula: 72500964

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dados/discoteca.dart';
import 'ui/tela_albuns.dart';

// Prova prática A2. Vale 20 pontos. Complete os TODO de 1 a 10.
//
//   flutter pub add provider http shared_preferences
//   flutter run -t Aula_23_Prova_Pratica/Prova_A_Albuns/lib/main.dart

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => Discoteca(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Prova A - Álbuns',
        home: TelaAlbuns(),
      ),
    ),
  );
}
