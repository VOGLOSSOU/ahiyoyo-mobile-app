import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Typographie système officielle d'Ahiyoyo.
/// Utilise les polices système (San Francisco sur iOS, Roboto sur Android).
abstract class AppTypography {
  /// Titre principal grand format (24-30px, bold)
  static const TextStyle display = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  /// Titre de page / grand en-tête (24px, bold)
  static const TextStyle titleLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
  );

  /// Titre de section ou sous-page (18px, semibold)
  static const TextStyle titleMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  /// Titre de carte ou module (14px, semibold)
  static const TextStyle titleSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  /// Corps de texte standard (14px, regular)
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  /// Corps de texte accentué / secondaire (14px, medium)
  static const TextStyle bodySecondary = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  /// Libellés secondaires, dates, métadonnées (12px, regular)
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  /// Métadonnées tertiaires (11px, regular)
  static const TextStyle captionTertiary = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.normal,
    color: AppColors.textTertiary,
  );

  /// Chiffres et montants mis en avant (20-24px, bold)
  static const TextStyle priceHighlight = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
    letterSpacing: -0.2,
  );

  /// Texte sur bouton primaire (14px, bold, noir)
  static const TextStyle buttonPrimary = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.onPrimary,
  );

  /// Texte sur bouton secondaire (14px, semibold, blanc)
  static const TextStyle buttonSecondary = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
}
