# Ahiyoyo Mobile App - Reste à faire

Etat au 23 septembre 2026. Ce document liste ce qui n'est pas encore fait, par lot, d'après la roadmap du README et les échanges de développement. Il ne liste pas ce qui est déjà terminé.

Fait depuis la dernière mise à jour : le suivi public colis/commande est maintenant branché sur la vraie API (`docs-from-api/04_SUIVI_PUBLIC_COLIS_COMMANDES_MOBILE.md`), avec la barre de recherche de la page d'accueil qui transmet réellement la référence saisie.

---

## Lot 1 - Authentification

Le lot est fonctionnel et conforme au contrat `docs-from-api/01_AUTHENTIFICATION_FLUTTER.md` (connexion, inscription, activation, mot de passe oublié/reset, changement de mot de passe, session, modification du profil). Il reste :

- Connexion Google réelle. Le bouton existe sur les écrans de connexion et d'inscription mais affiche seulement "bientôt disponible". Pour l'implémenter il faut :
  - ajouter une dépendance de type `google_sign_in` ;
  - configurer chaque plateforme (SHA-1 et `google-services.json` pour Android, `GoogleService-Info.plist` et schéma d'URL pour iOS, client ID JS et balise meta pour le web) ;
  - obtenir le Client ID OAuth exact utilisé côté serveur (fourni par l'équipe backend, ne pas en générer un autre).

---

## Lot 2 - Logistique & Commandes

Rien n'est branché sur une vraie API pour ce lot. Les écrans existants (Mes colis, Commandes, page d'accueil) affichent uniquement des données fictives codées en dur.

- Formulaire d'enregistrement d'un colis (maritime en CBM avec minimum 0,5 CBM, aérien en KG avec arrondi au kg supérieur). Le bouton "Enregistrer un colis" du menu "+" et la carte "Nouvelle expédition" de l'accueil ne font rien pour l'instant.
- Liste et détail réels des colis (écran "Mes colis" actuellement un seul élément statique).
- Demande de devis (Achat & Sourcing), wizard en 3 étapes avec calcul de la caution obligatoire. Le bouton "Demander un devis" du menu "+" et la carte correspondante de l'accueil ne font rien pour l'instant.
- Factures proforma, avec validation déclenchant la création de la commande.
- Liste et détail réels des commandes, avec suivi logistique en 8 étapes (écran "Commandes" actuellement un seul élément statique).
- Module de groupage maritime/aérien dynamique avec jauge de remplissage réelle. Les écrans de détail actuels affichent des chiffres fixes ; les routes réelles existent déjà (`GET /api/maritime/containers`, `GET /api/air-groupage/offers`, documentées dans `docs-from-api/03_ENREGISTREMENT_COLIS_MOBILE.md`), il reste à les brancher.
- Calculateur de fret (lien présent dans Profil, actuellement sans action).
- Paiement en ligne via KkiaPay (mobile money et carte bancaire).
- Virement bancaire et dépôt manuel avec téléversement de justificatif.

---

## Lot 3 - Notifications & Engagement

- Centre de notifications connecté à une vraie API (l'écran actuel affiche un seul élément statique, et le badge de compteur non lu sur la page d'accueil est une valeur fixe).
- Notifications push (configuration côté mobile, ex. Firebase Cloud Messaging / APNs).
- Programme de parrainage "Gagner de l'argent" connecté à une vraie API (le code de parrainage et les informations affichées dans Profil sont actuellement fictifs).

---

## Points transverses, hors lots

- URL de base de l'API codée en dur dans `core/api/api_endpoints.dart` au lieu de venir d'une configuration d'environnement, comme demandé par la doc d'authentification. A revoir avant mise en production (gestion des environnements dev/staging/prod).
- Les endpoints suivants n'ont jamais été confirmés par une doc API réelle (contrairement à l'authentification, aux tarifs, à l'enregistrement de colis et au suivi public) : devis, factures, commandes (détail authentifié), liste des colis d'un client, groupage (listes déjà couvertes par `docs-from-api/03_ENREGISTREMENT_COLIS_MOBILE.md` pour la création, mais pas pour une éventuelle gestion), notifications, parrainage. Leurs chemins actuels dans `api_endpoints.dart` sont des suppositions posées au tout début du projet, à vérifier avec l'équipe backend avant de les brancher.
- Choix définitif de l'icône de l'onglet "Commandes" dans la barre de navigation (discussion ouverte, actuellement une icône de sac).
- Images de l'onboarding non optimisées (environ 2,3 Mo chacune). A compresser ou convertir en format plus léger.
- Le CORS empêche de tester l'API réelle depuis `flutter run -d chrome`. Ce n'est pas un problème côté app mobile, mais une configuration à demander à l'équipe qui gère le serveur si l'on veut tester via navigateur.
