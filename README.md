# Ahiyoyo Mobile App (Android & iOS)

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Architecture](https://img.shields.io/badge/Architecture-Clean%20%2B%20Feature--First-brightgreen)](#architecture-technique)
[![Theme](https://img.shields.io/badge/UI-Exclusive%20Dark%20Mode-171717)](#identit%C3%A9-visuelle--design-system)
[![Status](https://img.shields.io/badge/Status-In%20Active%20Development-FDC354)](#feuille-de-route-des-lots)

Application mobile officielle de la plateforme **Ahiyoyo** (éditée par **NEW MARKETS TECHNOLOGIES SAS**), dédiée au commerce international, au groupage de fret (maritime et aérien), au suivi logistique en temps réel et à la gestion des commandes pour les clients et partenaires.

---

## Sommaire

1. [Fonctionnalités Clés](#-fonctionnalit%C3%A9s-cl%C3%A9s)
2. [Identité Visuelle & Design System](#-identit%C3%A9-visuelle--design-system)
3. [Stack Technique](#-stack-technique)
4. [Architecture Technique](#-architecture-technique)
5. [Règles d'Or & Bonnes Pratiques](#-r%C3%A8gles-dor--bonnes-pratiques)
6. [Installation & Démarrage](#-installation--d%C3%A9marrage)
7. [Qualité & Tests](#-qualit%C3%A9--tests)
8. [Feuille de Route des Lots](#-feuille-de-route-des-lots)

---

## 🌟 Fonctionnalités Clés

- **Suivi en direct (Public & Privé)** : Recherche instantanée par numéro de suivi (`AHI-XXXXXX`) ou référence commande, avec frise chronologique détaillée d'acheminement accessible même sans être connecté.
- **Groupage Maritime Dynamique** : Visualisation en direct du remplissage des conteneurs 40 pieds (68 CBM) avec barème tarifaire dégressif par paliers.
- **Expédition de colis simplifiée** : Enregistrement préalable obligatoire (fret maritime avec minimum 0,5 CBM, fret aérien avec arrondi au kg supérieur).
- **Demandes de Devis (Achat & Sourcing)** : Wizard en 3 étapes avec calcul dynamique de la caution obligatoire.
- **Factures Proforma & Commandes** : Validation d'une proforma déclenchant la commande et suivi logistique en 8 étapes.
- **Paiements Sécurisés** : Paiement en ligne via KkiaPay (Mobile Money & Carte bancaire) et virement bancaire/dépôt manuel avec téléversement de justificatif.
- **Programme de Parrainage ("Gagner de l'argent")** : Code unique partageable, suivi en temps réel des filleuls et des gains débloqués après encaissement.
- **Notifications Ciblées & Push** : Alertes de changement de statut, nouveaux conteneurs ouverts et messages du service client.

---

## 🎨 Identité Visuelle & Design System

L'application reproduit fidèlement la charte graphique de la plateforme web :

- **Mode Sombre Exclusif** : Aucun mode clair ni bascule automatique selon l'OS.
  - **Fond principal** : `neutral-900` (`#171717`)
  - **Cartes & conteneurs** : `neutral-800` (`#262626`)
  - **Bordures** : `neutral-700` (`#404040`)
  - **Accent / Marque** : Doré / ambre (`#fdc354`) utilisé avec parcimonie (boutons principaux, jauges, badges d'état actif)
  - **Textes** : Blanc pur (`#ffffff`), secondaire (`#a3a3a3`), méta (`#737373`)
- **Iconographie** : Port officiel des icônes **Lucide** (`flutter_lucide`) en traits fins pour une parité visuelle totale avec le web.
- **Typographie** : Polices système natives (San Francisco sur iOS, Roboto sur Android).
- **Monnaie & Formats** : Tous les montants sont strictement formatés en **FCFA** avec séparateur de milliers français (ex: `125 000 FCFA`). Dates au format `jj/mm/aaaa à hh:mm`.

---

## 🛠️ Stack Technique

| Domaine | Technologie / Package | Justification |
|---|---|---|
| **Framework** | [Flutter](https://flutter.dev) (Dart 3) | Multiplateforme Android et iOS natif |
| **State Management** | [`flutter_riverpod`](https://pub.dev/packages/flutter_riverpod) | Réactivité, testabilité et découplage fort |
| **Navigation** | [`go_router`](https://pub.dev/packages/go_router) | Déclaratif, support du deep linking et pile de navigation contrôlée |
| **Client HTTP** | [`dio`](https://pub.dev/packages/dio) | Intercepteurs d'authentification, retry et gestion d'erreurs |
| **Stockage Sécurisé** | [`flutter_secure_storage`](https://pub.dev/packages/flutter_secure_storage) | Chiffrement KeyStore (Android) et Keychain (iOS) pour les JWT |
| **Cache Local** | [`shared_preferences`](https://pub.dev/packages/shared_preferences) | Cache avec TTL et support du pattern *stale-while-error* |
| **Iconographie** | [`flutter_lucide`](https://pub.dev/packages/flutter_lucide) | Bibliothèque exacte des icônes Lucide du web |
| **Images Réseau** | [`cached_network_image`](https://pub.dev/packages/cached_network_image) | Cache disque et mémoire automatique |
| **Liens Externes** | [`url_launcher`](https://pub.dev/packages/url_launcher) | Liens téléphoniques (`tel:`), WhatsApp, CGU |
| **Formatage** | [`intl`](https://pub.dev/packages/intl) | Localisation française pour devises et dates |

---

## 🏗️ Architecture Technique

Le projet adopte une **Clean Architecture légère orientée fonctionnalités (Feature-First)**, sans sur-ingénierie :

```
lib/
├── main.dart                          # Point d'entrée immédiat sans await bloquant
├── app/
│   ├── router/                        # Configuration GoRouter (ShellRoute + Top-Level)
│   │   ├── app_routes.dart            # Constantes de navigation
│   │   └── app_router.dart            # Définition des routes
│   ├── shell/                         # Bottom Navigation Bar (AppShell)
│   ├── theme/                         # Couleurs sombres, typographie, ThemeData
│   │   ├── app_colors.dart
│   │   ├── app_typography.dart
│   │   └── app_theme.dart
│   └── providers/                     # Providers Riverpod transverses
│       └── app_providers.dart
├── core/
│   ├── api/                           # Client Dio, endpoints, intercepteurs
│   │   ├── api_client.dart
│   │   ├── api_endpoints.dart
│   │   ├── auth_interceptor.dart      # Refresh token mutualisé sur 401
│   │   └── error_interceptor.dart     # DioException -> AppException
│   ├── errors/                        # Modèle d'erreur unifié
│   │   └── app_exception.dart
│   ├── storage/                       # Sécurité et persistance
│   │   ├── secure_storage.dart        # Gestionnaire sécurisé des JWT
│   │   └── local_cache.dart           # Cache TTL stale-while-error
│   ├── utils/                         # Formateurs et constantes
│   │   ├── currency_formatter.dart    # Format "125 000 FCFA"
│   │   ├── date_formatter.dart        # Format français
│   │   └── constants.dart             # Règles logistiques
│   └── widgets/                       # Design System minimal
│       ├── ahiyoyo_button.dart        # Bouton primaire ambre / secondaire
│       ├── ahiyoyo_badge.dart         # Pastilles de statut avec icônes Lucide
│       ├── ahiyoyo_card.dart          # Cartes sombres bordées
│       └── ahiyoyo_skeleton.dart      # Shimmer de chargement animé
└── features/                          # Modules métier autonomes
    ├── auth/                          # Connexion, inscription, parrainage, OTP
    ├── home/                          # Tableau de bord client
    ├── parcels/                       # Enregistrement et liste de colis
    ├── quotes/                        # Demandes de cotation et devis
    ├── orders/                        # Commandes et suivi logistique
    ├── tracking/                      # Recherche et suivi public
    └── settings/                      # Profil, sécurité, CGU
```

Chaque dossier `features/<feature>` est découpé selon les besoins en :
- `data/` : Repositories et parsing JSON manuel (pas de générateur de code lourd type `freezed` ou `json_serializable`).
- `domain/` : Entités pures Dart.
- `presentation/` : Écrans (`screens/`), contrôleurs Riverpod (`controllers/`) et widgets locaux (`widgets/`).

---

## ⚠️ Règles d'Or & Bonnes Pratiques

Ces règles proviennent de retours d'expérience réels et doivent être respectées à la lettre :

1. **Routing (`go_router`)** :
   - Seuls les **5 onglets de navigation basse** (`Accueil`, `Mes colis`, `Commandes`, `Alertes`, `Profil`) appartiennent au `ShellRoute`.
   - **Toutes les pages de détail ou formulaires (devis, facture, commande, suivi...) doivent obligatoirement être déclarées en routes top-level (`parentNavigatorKey: rootNavigatorKey`)** pour éviter les bugs d'écrans vides.
2. **Démarrage instantané (`main.dart`)** :
   - Aucun chargement asynchrone bloquant avant `runApp()`. L'application s'affiche immédiatement.
3. **Sécurité des Tokens** :
   - Aucun fallback non chiffré (`SharedPreferences`) sur mobile natif. Les jetons restent exclusivement dans le KeyStore/Keychain.
4. **Cache *Stale-while-error*** :
   - Lors d'une panne réseau ou d'une indisponibilité temporaire, l'application restitue la donnée locale mise en cache plutôt qu'un écran d'erreur bloquant.
5. **Mutualisation du Refresh Token** :
   - Sur expiration de session (401), l'`AuthInterceptor` utilise un `Future` partagé pour qu'une vague de requêtes concurrentes n'exécute qu'un seul appel de rafraîchissement.

---

## 🚀 Installation & Démarrage

### Prérequis
- [Flutter SDK](https://docs.flutter.dev/get-started/install) 3.11+
- Android Studio / Android SDK (API 23+)
- Xcode (pour iOS, sur macOS)

### Installation
Cloner le dépôt et récupérer les dépendances :
```bash
git clone https://github.com/nathan-voglossou/AHIYOYO-MOBILE-APP.git
cd AHIYOYO-MOBILE-APP
flutter pub get
```

### Lancement
Sur un appareil connecté ou émulateur :
```bash
flutter run
```

Pour lancer sur une cible spécifique :
```bash
flutter run -d android
flutter run -d ios
```

---

## 🧪 Qualité & Tests

Exécuter la vérification du code et l'ensemble des tests automatisés :

```bash
# Analyse statique (doit afficher 0 erreur et 0 warning)
flutter analyze

# Lancement de la suite de tests unitaires et widgets
flutter test

# Formatage du code
dart format .
```

---

## 🗺️ Feuille de Route des Lots

- [x] **Lot 0 : Architecture & Fondations**
  - [x] Initialisation du projet Flutter & configuration Android/iOS.
  - [x] Implémentation du Core (Thème sombre `#171717`, client HTTP Dio, stockage sécurisé, cache, routing et design system).
  - [x] Tests unitaires du socle validés.
- [ ] **Lot 1 : Authentification & Parrainage (En cours)**
  - [ ] Connexion Email & mot de passe.
  - [ ] Connexion via Google.
  - [ ] Inscription avec vérification en temps réel du code de parrainage.
  - [ ] Vérification OTP par SMS/Email.
  - [ ] Gestion de la session avec Riverpod.
- [ ] **Lot 2 : Logistique & Commandes**
  - [ ] Formulaire d'expédition (Maritime CBM & Aérien KG).
  - [ ] Suivi en direct interactif.
  - [ ] Module de groupage maritime dynamique avec jauges de remplissage.
  - [ ] Demandes de devis & paiement des cautions via KkiaPay.
  - [ ] Frise de suivi logistique de commande en 8 étapes.
- [ ] **Lot 3 : Notifications & Engagement**
  - [ ] Centre de notifications synchronisé & push notifications.
  - [ ] Espace "Gagner de l'argent" (tableau de bord des parrainages et gains).

---

## 📄 Licence & Propriété

Projet développé pour le compte de **NEW MARKETS TECHNOLOGIES SAS** (enseigne **Ahiyoyo**).  
Tous droits réservés.
