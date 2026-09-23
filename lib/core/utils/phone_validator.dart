import 'package:phone_numbers_parser/phone_numbers_parser.dart';

/// Validation locale d'un numéro de téléphone en fonction de son indicatif
/// pays, avant tout appel réseau (l'API nettoie de toute façon les
/// caractères non numériques côté serveur, mais l'app doit bloquer un
/// numéro manifestement invalide pour le pays sélectionné).
abstract class PhoneValidator {
  /// Indicatifs des marchés couverts par Ahiyoyo (Afrique de l'Ouest/Centrale
  /// en priorité, plus quelques marchés internationaux courants). Un
  /// indicatif absent de cette table retombe sur une validation générique.
  static const Map<String, IsoCode> _dialCodeToIsoCode = {
    '229': IsoCode.BJ, // Bénin
    '228': IsoCode.TG, // Togo
    '225': IsoCode.CI, // Côte d'Ivoire
    '221': IsoCode.SN, // Sénégal
    '223': IsoCode.ML, // Mali
    '226': IsoCode.BF, // Burkina Faso
    '227': IsoCode.NE, // Niger
    '224': IsoCode.GN, // Guinée
    '233': IsoCode.GH, // Ghana
    '234': IsoCode.NG, // Nigeria
    '237': IsoCode.CM, // Cameroun
    '241': IsoCode.GA, // Gabon
    '242': IsoCode.CG, // Congo
    '243': IsoCode.CD, // RD Congo
    '33': IsoCode.FR, // France
    '32': IsoCode.BE, // Belgique
    '1': IsoCode.US, // États-Unis / Canada
    '86': IsoCode.CN, // Chine
  };

  /// Retourne un message d'erreur si le numéro est invalide, `null` sinon.
  static String? validate({required String codePays, required String numero}) {
    final code = codePays.trim();
    final number = numero.trim();

    if (code.isEmpty) return 'Indicatif pays requis';
    if (number.isEmpty) return 'Numéro requis';

    final isoCode = _dialCodeToIsoCode[code];
    if (isoCode == null) {
      // Indicatif non répertorié : validation générique (nombre de chiffres).
      final digitsOnly = number.replaceAll(RegExp(r'[^0-9]'), '');
      if (digitsOnly.length < 6 || digitsOnly.length > 15) {
        return 'Numéro invalide';
      }
      return null;
    }

    try {
      final phone = PhoneNumber.parse(number, callerCountry: isoCode);
      if (!phone.isValid()) {
        return 'Numéro invalide pour ce pays';
      }
      return null;
    } catch (_) {
      return 'Numéro invalide pour ce pays';
    }
  }

  static bool isValid({required String codePays, required String numero}) {
    return validate(codePays: codePays, numero: numero) == null;
  }
}
