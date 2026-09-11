import 'package:intl/intl.dart';

/// Formateur de dates conforme aux conventions françaises.
abstract class DateFormatter {
  static final DateFormat _dateFormat = DateFormat('dd/MM/yyyy', 'fr_FR');
  static final DateFormat _dateTimeFormat = DateFormat('dd/MM/yyyy à HH:mm', 'fr_FR');
  static final DateFormat _timeFormat = DateFormat('HH:mm', 'fr_FR');

  /// Exemple : 11/09/2026
  static String formatDate(DateTime? date) {
    if (date == null) return '-';
    return _dateFormat.format(date);
  }

  /// Exemple : 11/09/2026 à 14:30
  static String formatDateTime(DateTime? date) {
    if (date == null) return '-';
    return _dateTimeFormat.format(date);
  }

  /// Exemple : 14:30
  static String formatTime(DateTime? date) {
    if (date == null) return '-';
    return _timeFormat.format(date);
  }

  /// Parse une chaîne ISO ou standard en DateTime de façon sécurisée
  static DateTime? tryParse(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    return DateTime.tryParse(raw);
  }
}
