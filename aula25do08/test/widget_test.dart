import 'package:flutter_test/flutter_test.dart';
import 'package:aula25do08/main.dart';

void main() {
  testWidgets('PerfilPage renders user information and list items', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Verify AppBar and user info
    expect(find.text('Meu Perfil'), findsOneWidget);
    expect(find.text('Otávio Tadeu Magalhães'), findsOneWidget);
    expect(find.text('otavio@gmail.com'), findsOneWidget);

    // Verify list items and button
    expect(find.text('Minha Conta'), findsOneWidget);
    expect(find.text('LogOut'), findsOneWidget);
  });
}
