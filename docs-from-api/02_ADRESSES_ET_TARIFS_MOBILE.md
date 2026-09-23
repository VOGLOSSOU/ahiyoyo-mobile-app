# Adresses et tarifs — Contrat d’intégration mobile

## 1. Objectif

Ce document décrit la page publique « Adresses et tarifs » de l’application mobile Ahiyoyo.

Cette page permet à toute personne, connectée ou non, de consulter :

- les corridors de transport actuellement actifs ;
- les villes et pays de départ et de destination ;
- le mode et le type de service ;
- le tarif par kilogramme ou par CBM ;
- le délai indicatif ;
- l’adresse physique de dépôt ou de réception ;
- le contact local ;
- les instructions à respecter avant l’expédition.

La page est strictement en lecture seule. Elle ne contient aucune action administrative de création, modification ou suppression d’un tarif.

## 2. Accès public

La page doit être accessible depuis la navigation publique, avant toute authentification.

La route utilisée ne demande aucun JWT :

```http
GET /api/tarifs/public
```

Headers recommandés :

```http
Accept: application/json
```

Le header `Authorization` n’est pas nécessaire. L’absence de session ne doit jamais rediriger l’utilisateur vers la connexion lorsqu’il ouvre cette page.

## 3. Source de vérité

`GET /api/tarifs/public` est la source à utiliser pour cette page, car elle retourne dans chaque ligne active les tarifs, le corridor et les informations d’adresse.

Ne pas construire cette page avec des listes locales de pays, villes, adresses ou prix. Toutes ces informations sont configurables par l’administration et peuvent changer sans nouvelle version de l’application.

Ne pas utiliser `GET /api/colis/routes-disponibles` pour afficher les prix : cette route expose les corridors nécessaires au formulaire de colis, mais ne retourne volontairement pas les champs tarifaires.

Les anciennes routes `/api/rates/...` correspondent à des tableaux tarifaires historiques spécialisés. Elles ne doivent pas être mélangées automatiquement avec les lignes de `/api/tarifs/public`, au risque d’afficher des doublons ou des contrats tarifaires différents.

## 4. Réponse de l’API

La réponse est directement un tableau JSON, sans propriété `data` et sans pagination.

Exemple représentatif :

```json
[
  {
    "id": 9,
    "villeDepart": "Cotonou",
    "paysDepart": "Bénin",
    "villeDestination": "Paris",
    "paysDestination": "France",
    "modeTransport": "air_standard",
    "typeService": "Air Standard",
    "tarifParKg": "12000.00",
    "tarifParCbm": null,
    "delaiJours": 10,
    "categorie": null,
    "adressePhysique": "Gbegamey, Cotonou",
    "contactNom": "Ahiyoyo",
    "contactTelephone": "+2290191084141",
    "instructionsClient": "Marquez AHIYOYO et les informations du destinataire sur les cartons ou les emballages",
    "codeTrackingObligatoire": 0,
    "actif": 1,
    "createdAt": "2026-07-05T23:29:36.000Z",
    "updatedAt": "2026-07-05T23:29:36.000Z"
  },
  {
    "id": 4,
    "villeDepart": "Yiwu",
    "paysDepart": "Chine",
    "villeDestination": "Cotonou",
    "paysDestination": "Bénin",
    "modeTransport": "maritime",
    "typeService": "Groupage Maritime",
    "tarifParKg": null,
    "tarifParCbm": "200000.00",
    "delaiJours": 90,
    "categorie": null,
    "adressePhysique": "义乌市西站大道铁路口岸二区 2层4号楼6-8号门AS长胜公司",
    "contactNom": "张小姐收",
    "contactTelephone": "+8618705790136",
    "instructionsClient": "Marquage d’expédition obligatoire / 外箱唛头要求\n\nChaque carton extérieur ou colis doit porter clairement le marquage suivant :\nAHIYOYO + Nom du client + Téléphone",
    "codeTrackingObligatoire": 1,
    "actif": 1,
    "createdAt": "2026-07-04T11:21:32.000Z",
    "updatedAt": "2026-08-31T21:23:51.000Z"
  }
]
```

La liste ne contient que les lignes dont `actif` vaut vrai côté backend.

## 5. Définition des propriétés

| Propriété | Type reçu | Signification | Affichage |
|---|---|---|---|
| `id` | entier | Identifiant de la ligne tarifaire | Ne pas utiliser comme libellé public |
| `villeDepart` | texte | Ville où débute le trajet | Obligatoire |
| `paysDepart` | texte | Pays de départ | Obligatoire |
| `villeDestination` | texte | Ville d’arrivée | Obligatoire |
| `paysDestination` | texte | Pays d’arrivée | Obligatoire |
| `modeTransport` | texte | Code technique du mode | Le convertir seulement en libellé visuel connu |
| `typeService` | texte ou `null` | Nom commercial ou précision du service | Masquer si absent |
| `tarifParKg` | chaîne décimale ou `null` | Prix en FCFA par kilogramme | Afficher avec `/KG` lorsqu’il existe |
| `tarifParCbm` | chaîne décimale ou `null` | Prix en FCFA par CBM | Afficher avec `/CBM` lorsqu’il existe |
| `delaiJours` | entier ou `null` | Délai indicatif en jours | Masquer si absent |
| `categorie` | texte ou `null` | Catégorie de marchandises concernée | Masquer si absente |
| `adressePhysique` | texte ou `null` | Adresse physique associée à la ligne | Masquer si absente |
| `contactNom` | texte ou `null` | Nom du contact sur place | Masquer si absent |
| `contactTelephone` | texte ou `null` | Téléphone du contact | Afficher sans modifier la valeur reçue |
| `instructionsClient` | texte ou `null` | Instructions d’emballage, marquage ou dépôt | Respecter les retours à la ligne |
| `codeTrackingObligatoire` | `0`, `1`, `false` ou `true` | Indique si un numéro de suivi prestataire est requis pour ce service | Information utile surtout au futur formulaire de colis |
| `actif` | `0`, `1`, `false` ou `true` | État de la ligne | La route publique retourne déjà uniquement les lignes actives |
| `createdAt` | date ISO | Date de création technique | Non nécessaire sur la carte publique |
| `updatedAt` | date ISO | Dernière modification | Peut alimenter une mention de mise à jour si souhaité |

Les nombres décimaux Sequelize sont actuellement sérialisés comme des chaînes, par exemple `"12000.00"`. Le mobile doit donc accepter une chaîne décimale et ne pas exiger un nombre JSON natif.

## 6. Modes de transport

Les valeurs actuellement utilisées comprennent notamment :

| Valeur API | Libellé public recommandé | Unité tarifaire attendue |
|---|---|---|
| `air_standard` | Aérien standard | FCFA/KG |
| `air_economie` | Aérien économique | FCFA/KG |
| `air_express` | Express | FCFA/KG |
| `maritime` | Maritime | FCFA/CBM |
| `routier` | Terrestre | Selon les données retournées |

Cette liste sert uniquement à produire des libellés lisibles. Le mobile ne doit pas supprimer une ligne parce que `modeTransport` contient une nouvelle valeur inconnue. Dans ce cas, afficher une version lisible de la valeur ou le `typeService`, tout en conservant la ligne.

L’unité tarifaire doit être déterminée depuis les propriétés réellement présentes :

- `tarifParKg != null` : afficher le prix par KG ;
- `tarifParCbm != null` : afficher le prix par CBM ;
- si les deux existent exceptionnellement, afficher les deux séparément ;
- si aucun tarif n’existe, afficher « Tarif sur demande » plutôt que `0 FCFA`.

Ne jamais convertir des KG en CBM ou des CBM en KG.

## 7. Présentation attendue de la page

La page peut présenter une liste de cartes ou de sections. Chaque ligne tarifaire doit rester identifiable séparément, même si plusieurs lignes possèdent le même corridor.

Pour chaque ligne, afficher au minimum :

1. le corridor : `villeDepart, paysDepart → villeDestination, paysDestination` ;
2. le mode de transport ;
3. le type de service, lorsqu’il existe ;
4. la catégorie, lorsqu’elle existe ;
5. le tarif et son unité ;
6. le délai indicatif ;
7. l’adresse physique ;
8. le nom et le téléphone du contact ;
9. les instructions client.

Exemple de rendu métier :

```text
Yiwu, Chine → Cotonou, Bénin
Maritime — Groupage Maritime
200 000 FCFA/CBM
Délai indicatif : 90 jours

Adresse de dépôt
[adresse retournée par l’API]

Contact
[nom retourné] — [téléphone retourné]

Instructions
[texte retourné par l’API en conservant ses paragraphes]
```

L’adresse et les instructions peuvent contenir des caractères chinois, des accents et plusieurs lignes. L’application doit les afficher en Unicode sans translittération ni suppression.

## 8. Regroupement, filtres et recherche

La réponse n’est pas paginée. Le filtrage peut donc être réalisé localement après chargement.

Filtres utiles :

- pays ou ville de départ ;
- pays ou ville de destination ;
- mode de transport ;
- type de service ;
- catégorie.

La recherche peut porter, sans tenir compte de la casse, sur :

- les pays et villes ;
- le type de service ;
- la catégorie ;
- l’adresse physique.

Le regroupement visuel ne doit jamais fusionner les données de deux lignes différentes. Deux services partageant le même corridor peuvent avoir des prix, catégories, délais, contacts ou instructions différents.

## 9. Actions utiles sur les informations

Les actions suivantes peuvent être proposées sans authentification :

- copier l’adresse ;
- copier le téléphone ;
- lancer l’application téléphonique avec la valeur reçue ;
- partager l’adresse ou les instructions ;
- développer/réduire les instructions longues ;
- actualiser manuellement la liste.

Ne pas reconstruire ou normaliser silencieusement le téléphone affiché. Les données actuelles peuvent être stockées avec ou sans préfixe `+`. L’action d’appel peut appliquer la préparation strictement nécessaire au système, mais la valeur visible doit rester fidèle à l’API.

## 10. Tarifs classiques et offres de groupage

Cette page expose les lignes tarifaires classiques actives. Elle ne doit pas présenter ces prix comme les tarifs dynamiques des offres de groupage maritime ou aérien.

Les offres de groupage possèdent leurs propres corridors, jauges et paliers tarifaires. Elles seront documentées et affichées dans leurs fonctionnalités dédiées.

Si une ligne classique porte un libellé comme `Groupage Maritime`, le mobile doit malgré tout afficher les données telles qu’elles sont renvoyées par `/api/tarifs/public`. Il ne doit pas en déduire qu’il s’agit du conteneur promotionnel actuellement ouvert.

## 11. Formatage des montants

Les tarifs sont exprimés en FCFA.

Règles d’affichage :

- convertir prudemment la chaîne décimale pour le formatage visuel ;
- utiliser des séparateurs de milliers lisibles ;
- supprimer les décimales uniquement lorsqu’elles valent zéro ;
- conserver les décimales significatives si le backend en retourne ;
- ajouter explicitement `FCFA/KG` ou `FCFA/CBM` ;
- ne jamais remplacer une valeur absente par zéro ;
- ne jamais appliquer un taux de change ou une conversion locale sans fonctionnalité métier dédiée.

Le montant brut reçu doit rester disponible dans le modèle de données afin d’éviter une perte de précision due au formatage d’affichage.

## 12. Chargement, cache et actualisation

Au premier affichage, appeler `GET /api/tarifs/public`.

Comportements attendus :

- afficher un état de chargement ;
- afficher la liste dès réception ;
- permettre une actualisation manuelle ;
- remplacer complètement les anciennes données par la nouvelle réponse réussie ;
- ne pas conserver indéfiniment un tarif supprimé ou désactivé ;
- en cas d’utilisation d’un cache local, indiquer clairement lorsque les données affichées sont anciennes et tenter une actualisation réseau.

Les tarifs pouvant être modifiés par l’administration, l’application ne doit pas considérer une ancienne réponse comme permanente.

## 13. États particuliers

### Liste vide

Une réponse réussie peut être :

```json
[]
```

Afficher alors un état vide clair, par exemple :

```text
Aucune adresse ou ligne tarifaire n’est disponible pour le moment.
```

Ce cas ne doit pas être traité comme une erreur technique.

### Erreur serveur

Exemple :

```json
{
  "message": "Erreur serveur"
}
```

Afficher un message générique et une action « Réessayer ». Ne pas afficher le champ technique `error` à l’utilisateur final.

### Absence de réseau

Afficher un message spécifique à la connexion internet et proposer une nouvelle tentative. Ne pas rediriger vers l’authentification : cette page est publique.

### Données facultatives absentes

Ne pas afficher des lignes comme « Contact : null » ou « Adresse : null ». Masquer uniquement le bloc absent tout en conservant la ligne tarifaire.

## 14. Ce que le mobile ne doit pas faire

- Ne pas demander une connexion pour ouvrir la page.
- Ne pas appeler une route administrative.
- Ne pas embarquer une liste fixe d’adresses ou de tarifs.
- Ne pas modifier les valeurs reçues.
- Ne pas fusionner plusieurs services uniquement parce qu’ils partagent un corridor.
- Ne pas calculer un prix total d’expédition sur cette page.
- Ne pas confondre ligne tarifaire classique et offre dynamique de groupage.
- Ne pas afficher `0 FCFA` pour un tarif absent.
- Ne pas traduire automatiquement une adresse étrangère.
- Ne pas supprimer les sauts de ligne des instructions.

## 15. Checklist de validation mobile

- [ ] La page est accessible sans compte et sans token.
- [ ] La route appelée est `GET /api/tarifs/public`.
- [ ] La réponse est traitée comme un tableau direct, sans pagination.
- [ ] Les chaînes décimales des tarifs sont correctement acceptées.
- [ ] Les prix KG et CBM sont affichés dans les bonnes unités.
- [ ] Aucun tarif absent n’est transformé en zéro.
- [ ] Les corridors sont affichés dans le bon sens.
- [ ] Plusieurs services du même corridor restent distincts.
- [ ] Les adresses Unicode, notamment chinoises, sont conservées.
- [ ] Les paragraphes des instructions sont conservés.
- [ ] Les champs `null` sont masqués proprement.
- [ ] Le téléphone peut être copié et appelé sans altérer sa valeur visible.
- [ ] Les filtres n’éliminent pas les modes inconnus.
- [ ] Une actualisation récupère les changements effectués par l’administration.
- [ ] Une liste vide produit un état vide et non une erreur.
- [ ] Une erreur réseau ne redirige pas vers la connexion.
- [ ] Aucun bouton ou endpoint administratif n’est exposé.
- [ ] Les offres dynamiques de groupage ne sont pas mélangées aux tarifs classiques.

## 16. Résumé de la route

| Fonction | Méthode | Route | Authentification | Réponse |
|---|---:|---|---:|---|
| Consulter les adresses et tarifs actifs | `GET` | `/api/tarifs/public` | Aucune | Tableau direct de lignes tarifaires |

