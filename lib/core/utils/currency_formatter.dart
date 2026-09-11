import 'package:intl/intl.dart';

/// Formateur officiel de montants en Francs CFA (FCFA).
/// Format attendu : "125 000 FCFA" (espace comme séparateur de milliers).
abstract class CurrencyFormatter {
  static final NumberFormat _formatter = NumberFormat('#,##0', 'fr_FR');

  /// Formate un montant numérique en chaîne lisible terminée par FCFA.
  /// Exemple : 125000 -> "125 000 FCFA"
  static String format(num? amount) {
    if (amount == null) return '0 FCFA';
    final formattedNumber = _formatter.format(amount).replaceAll('\u202F', ' ');
    return '$formattedNumber FCFA';
  }

  /// Formate un montant sans le suffixe "FCFA".
  /// Exemple : 125000 -> "125 000"
  static String formatRaw(num? amount) {
    if (amount == null) return '0';
    return _formatter.format(amount).replaceAll('\u202F', ' ');
  }
}
