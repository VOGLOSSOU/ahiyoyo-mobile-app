import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ahiyoyo/main.dart';

void main() {
  testWidgets('Ahiyoyo smoke test - L\'application démarre et affiche l\'accueil', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: AhiyoyoApp(),
      ),
    );

    // Attendre le premier rendu
    await tester.pumpAndSettle();

    // Vérifier la présence de la marque AHIYOYO
    expect(find.text('AHIYOYO'), findsOneWidget);
    // Vérifier la présence des onglets de navigation
    expect(find.text('Accueil'), findsOneWidget);
    expect(find.text('Mes colis'), findsOneWidget);
    expect(find.text('Commandes'), findsOneWidget);
  });
}
