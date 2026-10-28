import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:prova/dados/discoteca.dart';
import 'package:prova/ui/tela_albuns.dart';

void main() {
  testWidgets('abre a tela de álbuns', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => Discoteca(),
        child: const MaterialApp(
          home: TelaAlbuns(),
        ),
      ),
    );
    expect(find.textContaining('Álbuns'), findsOneWidget);
  });
}
