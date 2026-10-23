import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:revisao_prova/dados/mural.dart';
import 'package:revisao_prova/ui/tela_avisos.dart';

void main() {
  testWidgets('abre a tela de avisos', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => Mural(),
        child: const MaterialApp(
          home: TelaAvisos(),
        ),
      ),
    );
    expect(find.text('Avisos do campus'), findsOneWidget);
  });
}
