import 'package:flutter/material.dart';

/// Palette de couleurs officielle de l'application Ahiyoyo.
/// Exclusivement orientée mode sombre conformément aux spécifications produit.
abstract class AppColors {
  // --- Fond & Surfaces ---
  /// Fond principal de l'application (`neutral-900`)
  static const Color background = Color(0xFF171717);

  /// Fond des cartes et conteneurs (`neutral-800`)
  static const Color surface = Color(0xFF262626);

  /// Fond légèrement surélevé pour inputs ou cartes secondaires
  static const Color surfaceElevated = Color(0xFF1F1F1F);

  /// Fond des survols ou éléments actifs doux
  static const Color surfaceHover = Color(0xFF2E2E2E);

  // --- Bordures ---
  /// Bordure standard des cartes et conteneurs (`neutral-700`)
  static const Color border = Color(0xFF404040);

  /// Bordure discrète (`neutral-800`)
  static const Color borderDark = Color(0xFF262626);

  /// Bordure au focus ou mise en avant
  static const Color borderFocus = Color(0xFFFDC354);

  // --- Couleur Accent / Marque ---
  /// Doré / ambre emblématique Ahiyoyo
  static const Color primary = Color(0xFFFDC354);

  /// Doré assombri pour les états pressés
  static const Color primaryDark = Color(0xFFE0A83B);

  /// Doré très clair / opacité pour halos et badges
  static const Color primaryMuted = Color(0x26FDC354);

  /// Couleur du texte sur le bouton doré (noir pur)
  static const Color onPrimary = Color(0xFF000000);

  // --- Textes ---
  /// Texte principal (blanc pur)
  static const Color textPrimary = Color(0xFFFFFFFF);

  /// Texte secondaire / labels (`neutral-400`)
  static const Color textSecondary = Color(0xFFA3A3A3);

  /// Texte tertiaire / méta dates (`neutral-500`)
  static const Color textTertiary = Color(0xFF737373);

  // --- Statuts métier (Pills & Badges) ---
  /// En attente (Jaune / Orange)
  static const Color statusPending = Color(0xFFF59E0B);
  static const Color statusPendingBg = Color(0x26F59E0B);

  /// Soumis / Traitement initial (Bleu)
  static const Color statusSubmitted = Color(0xFF3B82F6);
  static const Color statusSubmittedBg = Color(0x263B82F6);

  /// Étape intermédiaire / Analyse (Indigo / Violet)
  static const Color statusProcessing = Color(0xFF6366F1);
  static const Color statusProcessingBg = Color(0x266366F1);

  /// Succès / Payé / Livré (Vert)
  static const Color statusSuccess = Color(0xFF22C55E);
  static const Color statusSuccessBg = Color(0x2622C55E);

  /// Erreur / Annulé (Rouge)
  static const Color statusError = Color(0xFFEF4444);
  static const Color statusErrorBg = Color(0x26EF4444);

  /// Neutre / Brouillon (Gris)
  static const Color statusNeutral = Color(0xFF737373);
  static const Color statusNeutralBg = Color(0x26737373);
}
