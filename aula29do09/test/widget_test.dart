import 'package:flutter_test/flutter_test.dart';

import 'package:aula29do09/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(appDoExemplo(6));

    // Verify that our app loads.
    expect(find.textContaining('Carrinho'), findsWidgets);
  });
}

