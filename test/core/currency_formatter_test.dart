import 'package:flutter_test/flutter_test.dart';
import 'package:ahiyoyo/core/utils/currency_formatter.dart';

void main() {
  group('CurrencyFormatter', () {
    test('formate correctement les montants en FCFA', () {
      expect(CurrencyFormatter.format(125000), '125 000 FCFA');
      expect(CurrencyFormatter.format(0), '0 FCFA');
      expect(CurrencyFormatter.format(null), '0 FCFA');
      expect(CurrencyFormatter.format(265000), '265 000 FCFA');
    });

    test('formate le montant brut sans suffixe', () {
      expect(CurrencyFormatter.formatRaw(125000), '125 000');
      expect(CurrencyFormatter.formatRaw(null), '0');
    });
  });
}
