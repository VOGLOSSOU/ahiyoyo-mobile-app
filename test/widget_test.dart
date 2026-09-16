import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ahiyoyo/main.dart';

void main() {
  testWidgets('Ahiyoyo smoke test - L\'application démarre et affiche l\'accueil', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({
      'ahiyoyo_cache_has_completed_onboarding': '{"timestamp":1234567890,"data":true}',
    });

    await tester.pumpWidget(
      const ProviderScope(
        child: AhiyoyoApp(),
      ),
    );

    // Passer le splash screen (1.5s)
    await tester.pump(const Duration(milliseconds: 1600));
    await tester.pumpAndSettle();

    // Vérifier la présence de la marque AHIYOYO sur l'accueil
    expect(find.text('AHIYOYO'), findsOneWidget);
    // Vérifier la présence des onglets de navigation
    expect(find.text('Accueil'), findsOneWidget);
    expect(find.text('Mes colis'), findsOneWidget);
    expect(find.text('Commandes'), findsOneWidget);
  });

  testWidgets('Ahiyoyo onboarding test - Affiche l\'onboarding si non complété', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({}); // Non complété

    await tester.pumpWidget(
      const ProviderScope(
        child: AhiyoyoApp(),
      ),
    );

    // Passer le splash screen (1.5s)
    await tester.pump(const Duration(milliseconds: 1600));
    await tester.pumpAndSettle();

    // Vérifier le titre et les boutons de l'onboarding
    expect(find.textContaining('Achetez, vendez et expédiez'), findsOneWidget);
    expect(find.text('Passer'), findsOneWidget);
    expect(find.text('Suivant'), findsOneWidget);
  });
}

