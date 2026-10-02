import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:aula01do10exercicioprovider/main.dart';

void main() {
  testWidgets('Checklist 1: Incremento no Cardápio / Detalhe e reflexo no Pedido', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => PedidoLab(),
        child: const MaterialApp(
          home: CardapioLab(),
        ),
      ),
    );

    expect(find.textContaining('Cardápio (0)'), findsOneWidget);

    // Toca no primeiro item ('Pão de queijo') para abrir o Detalhe
    await tester.tap(find.text('Pão de queijo'));
    await tester.pumpAndSettle();

    // Verifica elementos do Detalhe
    expect(find.text('Quentinho, porção de 4.'), findsOneWidget);
    expect(find.text('0'), findsOneWidget);

    // Toca no botão + no Detalhe
    await tester.tap(find.byIcon(Icons.add_circle_outline));
    await tester.pumpAndSettle();

    // Verifica que agora a quantidade é 1
    expect(find.text('1'), findsOneWidget);

    // Volta para o Cardápio
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    // Verifica que o AppBar do Cardápio subiu para 1
    expect(find.textContaining('Cardápio (1)'), findsOneWidget);

    // Abre a tela Pedido pelo ícone do carrinho
    await tester.tap(find.byIcon(Icons.shopping_cart_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Pedido'), findsOneWidget);
    expect(find.text('Total'), findsOneWidget);
    expect(find.text('R\$ 6.00'), findsWidgets);
  });

  testWidgets('Checklist 2: Decremento no Pedido e sincronização no Detalhe', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => PedidoLab(),
        child: const MaterialApp(
          home: CardapioLab(),
        ),
      ),
    );

    // Incrementa 2 vezes pelo botão + da lista do cardápio
    await tester.tap(find.byIcon(Icons.add).first);
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.add).first);
    await tester.pumpAndSettle();

    expect(find.textContaining('Cardápio (2)'), findsOneWidget);

    // Abre a tela Pedido
    await tester.tap(find.byIcon(Icons.shopping_cart_outlined));
    await tester.pumpAndSettle();

    expect(find.text('2'), findsOneWidget);

    // Decrementa na tela Pedido
    await tester.tap(find.byIcon(Icons.remove));
    await tester.pumpAndSettle();

    expect(find.text('1'), findsOneWidget);

    // Volta para o Cardápio
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    expect(find.textContaining('Cardápio (1)'), findsOneWidget);

    // Abre o Detalhe do item e confere que a quantidade reflete 1
    await tester.tap(find.text('Pão de queijo'));
    await tester.pumpAndSettle();

    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('Checklist 3: Cadastro de Novo Item e disponibilidade imediata', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => PedidoLab(),
        child: const MaterialApp(
          home: CardapioLab(),
        ),
      ),
    );

    // Abre tela de cadastro pelo ícone + do AppBar
    await tester.tap(find.descendant(of: find.byType(AppBar), matching: find.byIcon(Icons.add)));
    await tester.pumpAndSettle();

    expect(find.text('Novo item'), findsOneWidget);

    // Preenche os campos
    await tester.enterText(find.widgetWithText(TextField, 'Nome'), 'Leite com café');
    await tester.enterText(find.widgetWithText(TextField, 'Preço'), '7,50');
    await tester.pumpAndSettle();

    // Salva
    await tester.tap(find.text('Cadastrar'));
    await tester.pumpAndSettle();

    // Verifica que voltou ao cardápio e o novo item está na lista
    expect(find.text('Leite com café'), findsOneWidget);
    expect(find.text('R\$ 7.50'), findsOneWidget);

    // Clica no novo item para abrir o detalhe
    await tester.tap(find.text('Leite com café'));
    await tester.pumpAndSettle();

    expect(find.text('Cadastrado na aula.'), findsOneWidget);
    expect(find.text('R\$ 7.50'), findsOneWidget);
  });
}
