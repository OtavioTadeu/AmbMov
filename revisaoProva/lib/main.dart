import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dados/mural.dart';
import 'ui/tela_avisos.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => Mural(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Aula 22 - Avisos',
        home: TelaAvisos(),
      ),
    ),
  );
}
