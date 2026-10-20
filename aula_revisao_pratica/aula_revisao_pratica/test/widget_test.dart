import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aula_revisao_pratica/main.dart';

void main() {
  testWidgets('abre a lista de receitas', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const AppRevisao());
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.textContaining('Receitas'), findsOneWidget);
  });
}
