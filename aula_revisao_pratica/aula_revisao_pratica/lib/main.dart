import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:aula_revisao_pratica/dados/loja.dart';
import 'package:aula_revisao_pratica/ui/tela_lista.dart';

void main() {
  runApp(const AppRevisao());
}

class AppRevisao extends StatelessWidget {
  const AppRevisao({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => Loja(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Aula 21 - Revisão',
        home: TelaLista(),
      ),
    );
  }
}
