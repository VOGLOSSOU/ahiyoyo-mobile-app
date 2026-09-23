# Enregistrement d’un colis — Contrat d’intégration mobile

## 1. Objectif et périmètre

Ce document décrit le parcours client complet permettant d’enregistrer un colis depuis l’application mobile Ahiyoyo.

Il couvre :

- le chargement dynamique des corridors et services ;
- le choix d’une ligne tarifaire classique ;
- l’enregistrement depuis une offre de groupage maritime ou aérien ;
- le choix du mode et de l’unité ;
- la quantité déclarée ;
- le propriétaire du colis ;
- les informations du prestataire ;
- la saisie manuelle des articles ou l’envoi d’un fichier ;
- les images d’articles ;
- le format multipart ;
- les validations et erreurs ;
- le résultat de la création.

La consultation du formulaire peut commencer avec des données publiques, mais la création définitive exige une session client.

## 2. Routes utilisées

| Fonction | Méthode | Route | Authentification |
|---|---:|---|---:|
| Charger les corridors classiques | `GET` | `/api/colis/routes-disponibles` | Aucune |
| Lister les offres maritimes ouvertes | `GET` | `/api/maritime/containers` | Aucune |
| Consulter une offre maritime | `GET` | `/api/maritime/containers/:id` | Aucune |
| Lister les offres aériennes ouvertes | `GET` | `/api/air-groupage/offers` | Aucune |
| Consulter une offre aérienne | `GET` | `/api/air-groupage/offers/:id` | Aucune |
| Créer le colis | `POST` | `/api/colis` | Bearer client |

La route de création attend :

```http
Authorization: Bearer <token_client>
Content-Type: multipart/form-data
Accept: application/json
```

Le mobile doit utiliser `multipart/form-data` pour tous les parcours afin de gérer uniformément les images et documents. Le contenu métier JSON est placé dans un champ texte nommé exactement `payload`.

Ne pas définir manuellement la frontière `boundary` du multipart : elle doit être produite par la couche HTTP mobile.

## 3. Charger les lignes classiques

### Requête

```http
GET /api/colis/routes-disponibles
```

### Réponse

```json
{
  "departs": [
    {
      "pays": "Bénin",
      "ville": "Cotonou",
      "categories": ["Marchandises non-électroniques"]
    }
  ],
  "destinations": [
    { "pays": "France", "ville": "Paris" }
  ],
  "lignes": [
    {
      "id": 9,
      "paysDepart": "Bénin",
      "villeDepart": "Cotonou",
      "paysDestination": "France",
      "villeDestination": "Paris",
      "modeColis": "avion",
      "modeTransport": "air_standard",
      "typeService": "Air Standard",
      "categorie": null,
      "instructionsClient": "Marquez AHIYOYO et les informations du destinataire sur les cartons",
      "codeTrackingObligatoire": false,
      "adressePhysique": "Gbegamey, Cotonou",
      "contactNom": "Ahiyoyo",
      "contactTelephone": "+2290191084141"
    }
  ]
}
```

Cette route ne retourne que les lignes actives. Elle ne retourne pas les prix : son objectif est de piloter la création du colis et de fournir l’identifiant exact de la ligne.

## 4. Sélection guidée du corridor classique

Le formulaire ne doit contenir aucune liste codée en dur.

Ordre recommandé :

1. choisir un départ dans `departs` ;
2. filtrer `lignes` avec ce pays et cette ville pour construire les destinations possibles ;
3. choisir une destination ;
4. filtrer de nouveau `lignes` sur le corridor complet ;
5. afficher les services réellement disponibles ;
6. conserver l’objet ligne sélectionné et surtout son `id`.

Si plusieurs lignes partagent le même corridor et le même `modeColis`, elles doivent rester distinguables grâce à `typeService`, `categorie`, l’adresse ou les instructions. Ne jamais choisir arbitrairement la première ligne.

Lorsqu’un choix parent change :

- changement du départ : effacer destination, service, ligne et tracking transporteur ;
- changement de destination : effacer service, ligne et tracking transporteur ;
- changement de service : recalculer les instructions et l’obligation du tracking.

Afficher les informations de la ligne sélectionnée :

- `instructionsClient`, en conservant les paragraphes ;
- `adressePhysique` ;
- `contactNom` ;
- `contactTelephone` ;
- `categorie` ;
- `typeService`.

## 5. Exactement une source commerciale

Chaque création doit sélectionner exactement une des trois sources suivantes :

1. ligne classique : `ligneTarifaireId` ;
2. offre maritime : `conteneurMaritimeId` ;
3. offre aérienne : `groupageAerienId`.

Le payload ne doit jamais contenir simultanément deux ou trois de ces propriétés.

Si le client utilise le parcours classique :

```json
{
  "ligneTarifaireId": 9
}
```

Si le client profite d’une offre maritime :

```json
{
  "conteneurMaritimeId": "uuid-conteneur"
}
```

Si le client profite d’une offre aérienne :

```json
{
  "groupageAerienId": "uuid-offre-aerienne"
}
```

En l’absence d’exactement une source, le backend retourne `400` avec une erreur structurée.

## 6. Parcours « Profiter de l’offre » maritime

Les offres ouvertes et visibles sont disponibles ici :

```http
GET /api/maritime/containers
```

Réponse :

```json
{
  "data": [
    {
      "id": "uuid-conteneur",
      "reference": "SEA-001",
      "titre": "Groupage Yiwu - Cotonou",
      "conditions": "...",
      "statut": "OUVERT",
      "dateDepartEstimee": "2026-10-20T00:00:00.000Z",
      "capaciteCbm": 68,
      "volumeRempliCbm": 30,
      "volumeDisponibleCbm": 38,
      "pourcentageRemplissage": 44.12,
      "signalRemplissage": "REMPLISSAGE_EN_COURS",
      "tarifActuelParCbm": 220000,
      "palierTarifaireActuel": {},
      "paliersTarifaires": [],
      "corridor": {
        "paysDepart": "Chine",
        "villeDepart": "Yiwu",
        "paysDestination": "Bénin",
        "villeDestination": "Cotonou",
        "modeTransport": "maritime",
        "modeColis": "bateau"
      }
    }
  ]
}
```

Lorsqu’un utilisateur choisit « Profiter de l’offre » :

- conserver l’`id` comme `conteneurMaritimeId` ;
- préremplir et verrouiller le corridor depuis `corridor` ;
- imposer `shippingMode: "bateau"` ;
- imposer `volume.unit: "CBM"` ;
- ne pas envoyer `ligneTarifaireId` ;
- ne pas envoyer `groupageAerienId` ;
- afficher `tarifActuelParCbm` uniquement comme estimation au moment de la saisie ;
- ne jamais envoyer un prix calculé ou imposé par le mobile.

Le backend revérifie à la soumission que l’offre est toujours ouverte, publique, compatible avec le corridor et couverte par un palier tarifaire.

## 7. Parcours « Profiter de l’offre » aérienne

Les offres ouvertes et visibles sont disponibles ici :

```http
GET /api/air-groupage/offers
```

Réponse :

```json
{
  "data": [
    {
      "id": "uuid-offre",
      "reference": "AIR-001",
      "titre": "Groupage aérien Guangzhou - Cotonou",
      "conditions": "...",
      "statut": "OUVERT",
      "capaciteKg": 45,
      "poidsRempliKg": 15,
      "poidsDisponibleKg": 30,
      "pourcentageRemplissage": 33.33,
      "signalRemplissage": "REMPLISSAGE_EN_COURS",
      "tarifActuelParKg": 9000,
      "palierTarifaireActuel": {},
      "paliersTarifaires": [],
      "corridor": {
        "paysDepart": "Chine",
        "villeDepart": "Guangzhou",
        "paysDestination": "Bénin",
        "villeDestination": "Cotonou",
        "modeTransport": "aerien",
        "modesColis": ["avion", "express"]
      }
    }
  ]
}
```

Dans ce parcours :

- conserver l’`id` comme `groupageAerienId` ;
- préremplir et verrouiller le corridor ;
- permettre uniquement `avion` ou `express` ;
- imposer `volume.unit: "Kg"` avec exactement cette casse dans le payload ;
- ne pas envoyer `ligneTarifaireId` ;
- ne pas envoyer `conteneurMaritimeId` ;
- afficher `tarifActuelParKg` comme estimation seulement ;
- ne jamais envoyer un tarif dans le payload.

## 8. Mode, quantité et unité

Valeurs autorisées pour `shippingMode` :

```text
bateau
avion
express
terrestre
```

Le payload utilise la propriété historique `volume`, même lorsque la valeur représente un poids :

```json
{
  "volume": {
    "value": 10,
    "unit": "Kg"
  }
}
```

Parcours client recommandé :

| Mode | Libellé | Unité envoyée | Règle |
|---|---|---|---|
| `bateau` | Volume déclaré | `CBM` | Minimum `0,5` |
| `avion` | Poids déclaré | `Kg` | Valeur strictement positive |
| `express` | Poids déclaré | `Kg` | Valeur strictement positive |
| `terrestre` | Quantité déclarée | `Kg` ou `CBM` | Selon le service présenté |

Le backend conserve une compatibilité historique permettant `CBM` pour un colis classique `avion`, mais le parcours client Ahiyoyo actuel doit utiliser le kilogramme pour l’aérien.

Le séparateur décimal saisi localement peut être une virgule, mais la valeur envoyée dans le JSON doit pouvoir être convertie en nombre.

## 9. Propriétaire du colis

Deux valeurs sont autorisées :

```text
self
other
```

### Propriétaire connecté

```json
{
  "ownerType": "self"
}
```

Ne pas envoyer `userId`. Le backend associe obligatoirement le colis à l’utilisateur extrait du JWT.

### Autre propriétaire

```json
{
  "ownerType": "other",
  "owner": {
    "firstName": "Awa",
    "lastName": "Koffi",
    "address": "Cotonou, Bénin",
    "phoneNumber": "+2290197000000"
  }
}
```

Les quatre propriétés de `owner` sont obligatoires lorsque `ownerType` vaut `other`. Le téléphone doit contenir au moins 6 caractères.

## 10. Prestataire et tracking transporteur

Propriétés disponibles :

```json
{
  "carrierName": "DHL",
  "carrierTrackingNumber": "SF1234567890CN",
  "otherCarrierName": null
}
```

Règles :

- `carrierName` est globalement facultatif ;
- `carrierTrackingNumber` est facultatif sauf si la ligne classique sélectionnée retourne `codeTrackingObligatoire: true` ;
- si `carrierName` vaut exactement `AUTRES`, `otherCarrierName` devient obligatoire ;
- si le client quitte l’option `AUTRES`, ne pas conserver une ancienne valeur dans `otherCarrierName` ;
- les champs vides peuvent être omis ou envoyés à `null` ;
- ne pas déduire l’obligation du tracking depuis le seul mode de transport ;
- les offres de groupage ne s’appuient pas sur le flag d’une ligne classique.

Le champ historique `transporter` est accepté par l’API, mais le nouveau parcours mobile doit utiliser `carrierName`, `otherCarrierName` et `carrierTrackingNumber`.

## 11. Deux façons de fournir les articles

Le client doit choisir exactement un parcours visuel :

1. saisie manuelle d’au moins un article ;
2. fichier unique contenant la liste des articles.

Si `articlesFile` est envoyé, le backend l’utilise et ignore le tableau `articles`. Si aucun fichier n’est envoyé, au moins un article est obligatoire.

Le mobile doit clairement permettre de basculer d’un mode à l’autre et éviter d’envoyer les deux.

## 12. Saisie manuelle des articles

Structure d’un article :

```json
{
  "id": "article-local-1",
  "description": "Chaussures",
  "quantity": 2,
  "unitPrice": 15000,
  "totalPrice": 30000,
  "purchaseLink": "https://example.com/article"
}
```

Règles :

- `id` est facultatif pour l’API, mais fortement recommandé pour associer correctement l’image ;
- `description` est obligatoire ;
- `quantity` est un entier supérieur ou égal à 1 ;
- `unitPrice` doit être strictement positif ;
- `totalPrice` doit être strictement positif ;
- le mobile doit normalement présenter `totalPrice = quantity × unitPrice` ;
- `purchaseLink` est facultatif, vide ou URL valide ;
- ne pas envoyer une propriété `imageUrl` locale : le fichier image doit être une partie multipart séparée.

`totalAmount` du colis n’est pas la somme automatique des articles et ne doit pas être inventé par le mobile. Il peut être omis lors de la création client.

## 13. Images des articles

Formats acceptés :

```text
image/jpeg
image/jpg
image/png
image/webp
```

Taille maximale : `10 MB` par fichier. Nombre total maximal de fichiers dans la requête : `20`.

Pour chaque article possédant une image, utiliser de préférence le nom multipart :

```text
images[<id-article>]
```

Exemple :

```text
images[article-local-1]
images[article-local-2]
```

Le même `id` doit être présent dans l’objet correspondant du tableau `articles`.

La variante `image_<id-article>` est également reconnue, mais il est préférable de conserver une seule convention. Ne pas dépendre de l’ordre des fichiers lorsque des identifiants sont disponibles.

Les fichiers sont stockés sur Cloudinary. L’URL finale est retournée dans `articles[].imageUrl`.

## 14. Fichier global d’articles

Nom multipart obligatoire :

```text
articlesFile
```

Un seul fichier doit être envoyé. Formats acceptés :

| Format | MIME type |
|---|---|
| PDF | `application/pdf` |
| Excel `.xls` | `application/vnd.ms-excel` |
| Excel `.xlsx` | `application/vnd.openxmlformats-officedocument.spreadsheetml.sheet` |
| Word `.doc` | `application/msword` |
| Word `.docx` | `application/vnd.openxmlformats-officedocument.wordprocessingml.document` |

Taille maximale : `10 MB`.

Le backend ne lit pas le contenu du document. Il l’enregistre comme pièce jointe Cloudinary dans `documentsUrl`. Le tableau `articles` de la réponse sera vide.

## 15. Payload classique complet

Partie multipart `payload` :

```json
{
  "ligneTarifaireId": 9,
  "originCountry": "Bénin",
  "originCity": "Cotonou",
  "destinationCountry": "France",
  "destinationCity": "Paris",
  "shippingMode": "avion",
  "volume": {
    "value": 10,
    "unit": "Kg"
  },
  "ownerType": "self",
  "carrierName": "DHL",
  "carrierTrackingNumber": "DHL123456",
  "articles": [
    {
      "id": "article-local-1",
      "description": "Chaussures",
      "quantity": 2,
      "unitPrice": 15000,
      "totalPrice": 30000,
      "purchaseLink": ""
    }
  ]
}
```

Parties multipart supplémentaires éventuelles :

```text
images[article-local-1] = fichier image
```

## 16. Payload avec fichier d’articles

Partie `payload` :

```json
{
  "ligneTarifaireId": 9,
  "originCountry": "Bénin",
  "originCity": "Cotonou",
  "destinationCountry": "France",
  "destinationCity": "Paris",
  "shippingMode": "avion",
  "volume": {
    "value": 10,
    "unit": "Kg"
  },
  "ownerType": "self"
}
```

Partie fichier :

```text
articlesFile = fichier PDF, Excel ou Word
```

## 17. Validations métier principales

- Origine et destination doivent être différentes.
- Les quatre propriétés de lieu sont obligatoires.
- Le mode doit appartenir à la liste autorisée.
- La quantité déclarée doit être strictement positive.
- Le maritime impose au minimum `0,5 CBM`.
- Le bateau exige `CBM`.
- L’express exige `Kg`.
- Le groupage aérien exige `Kg`.
- Un propriétaire `other` exige toutes ses informations.
- Sans `articlesFile`, au moins un article valide est requis.
- Une ligne classique doit être active et correspondre exactement au corridor et au mode.
- Une offre doit toujours être ouverte, publique, compatible et posséder un palier tarifaire courant.
- Le tracking transporteur est obligatoire uniquement lorsque la ligne classique le demande.
- `otherCarrierName` est obligatoire lorsque `carrierName === "AUTRES"`.

Le mobile doit valider pour améliorer l’expérience, mais le backend reste toujours la source de vérité.

## 18. Erreurs structurées

Format principal :

```json
{
  "message": "Données invalides",
  "errors": [
    {
      "path": "volume.value",
      "message": "Le volume maritime minimum est de 0,5 CBM."
    }
  ]
}
```

Le mobile doit associer `path` au champ concerné. Chemins possibles notamment :

```text
ligneTarifaireId
conteneurMaritimeId
groupageAerienId
originCountry
originCity
destinationCountry
destinationCity
shippingMode
volume.value
volume.unit
owner.firstName
owner.lastName
owner.address
owner.phoneNumber
articles
articles.0.description
articles.0.quantity
articles.0.unitPrice
articles.0.totalPrice
carrierName
carrierTrackingNumber
otherCarrierName
```

Autres formats possibles :

```json
{
  "message": "Vous devez fournir soit une liste d'articles, soit un fichier articlesFile."
}
```

```json
{
  "message": "Type de fichier non supporte. Types acceptes : ..."
}
```

```json
{
  "message": "Erreur lors du téléchargement des fichiers",
  "details": "..."
}
```

Traitement recommandé :

- `400` : afficher les erreurs de champs ou le message global ;
- `401` : session absente ou expirée, revenir à la connexion sans perdre inutilement le brouillon local ;
- `404` : offre devenue indisponible ;
- `409` : ressource ou état devenu incompatible ;
- erreur réseau : conserver le formulaire et permettre une nouvelle tentative.

## 19. Réponse de création

Succès : `201 Created`.

Extrait représentatif :

```json
{
  "id": "uuid-colis",
  "userId": 42,
  "trackingNumber": "TRACK-2609-AB23",
  "originCountry": "Bénin",
  "originCity": "Cotonou",
  "destinationCountry": "France",
  "destinationCity": "Paris",
  "shippingMode": "avion",
  "volumeValue": 10,
  "volumeUnit": "KG",
  "ownerType": "self",
  "ligneTarifaireId": 9,
  "conteneurMaritimeSouhaiteId": null,
  "groupageAerienSouhaiteId": null,
  "status": "EN_ATTENTE_CONFIRMATION",
  "documentsUrl": null,
  "articles": [
    {
      "id": "uuid-article",
      "description": "Chaussures",
      "quantity": 2,
      "unitPrice": 15000,
      "totalPrice": 30000,
      "purchaseLink": null,
      "imageUrl": "https://res.cloudinary.com/..."
    }
  ],
  "createdAt": "2026-09-23T10:00:00.000Z"
}
```

Le `trackingNumber` est toujours généré par le backend. Le mobile ne doit pas en produire ni en envoyer un.

Après succès :

1. supprimer le brouillon local et les fichiers temporaires ;
2. afficher une confirmation ;
3. afficher et permettre de copier `trackingNumber` ;
4. préciser que le statut initial est « En attente de confirmation » ;
5. proposer d’ouvrir le détail du colis ou la liste « Mes colis ».

La création déclenche également les notifications et emails prévus côté backend. Le mobile ne doit pas tenter de les envoyer lui-même.

## 20. Checklist de validation mobile

- [ ] Les corridors proviennent de `/api/colis/routes-disponibles`.
- [ ] La ligne exacte et son `id` sont conservés.
- [ ] Plusieurs services identiques en apparence restent distinguables.
- [ ] Exactement une source commerciale est envoyée.
- [ ] Le corridor et le mode d’une offre sont préremplis et verrouillés.
- [ ] Les tarifs d’offres restent indicatifs et ne sont pas envoyés.
- [ ] `bateau` utilise `CBM` avec un minimum de `0,5`.
- [ ] `avion` et `express` utilisent `Kg` dans le parcours mobile.
- [ ] `ownerType: self` n’envoie aucun `userId`.
- [ ] `ownerType: other` exige les quatre informations.
- [ ] L’obligation du tracking vient de `codeTrackingObligatoire`.
- [ ] `AUTRES` exige `otherCarrierName`.
- [ ] Le client choisit soit les articles manuels, soit un fichier.
- [ ] Les images sont associées avec l’identifiant local de l’article.
- [ ] Les types et tailles de fichiers sont vérifiés.
- [ ] Le JSON se trouve dans la partie multipart `payload`.
- [ ] Les erreurs structurées utilisent leur `path`.
- [ ] Le formulaire est conservé après une erreur réseau ou serveur.
- [ ] Le numéro de tracking affiché vient uniquement de la réponse backend.
- [ ] Aucun montant d’expédition définitif n’est calculé ou envoyé par le mobile.

