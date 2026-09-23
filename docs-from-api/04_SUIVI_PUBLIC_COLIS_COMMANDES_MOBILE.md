# Suivi public des colis et commandes — Contrat d’intégration mobile

## 1. Objectif

Ce document décrit la fonctionnalité publique permettant de suivre un colis ou une commande grâce à sa référence.

Cette page est accessible sans compte et sans authentification. Elle accepte :

- le numéro Ahiyoyo d’un colis ;
- le numéro de tracking fourni par le transporteur et associé au colis ;
- la référence Ahiyoyo d’une commande.

## 2. Route publique

```http
GET /api/tracking?q=<reference>
```

Exemples :

```http
GET /api/tracking?q=TRACK-2609-AB23
GET /api/tracking?q=SF1234567890CN
GET /api/tracking?q=CMD-2609-AB23
```

Aucun header `Authorization` n’est requis. Une erreur sur cette page ne doit jamais forcer l’utilisateur à se connecter.

Le paramètre doit être encodé comme un paramètre de requête. Avant l’envoi, supprimer uniquement les espaces placés au début et à la fin. Ne pas modifier arbitrairement les caractères internes de la référence.

## 3. Validation de la recherche

Le paramètre `q` est obligatoire.

S’il est absent ou vide, l’API retourne `400` :

```json
{
  "errors": [
    {
      "type": "field",
      "value": "",
      "msg": "q requis (trackingNumber)",
      "path": "q",
      "location": "query"
    }
  ]
}
```

Le bouton de recherche doit rester désactivé tant que la saisie nettoyée est vide.

## 4. Ordre de recherche effectué par le backend

Pour une même valeur `q`, le backend recherche dans cet ordre :

1. `Colis.trackingNumber` ;
2. `Colis.carrierTrackingNumber` ;
3. `Commande.reference` si aucun colis n’a été trouvé.

Il n’est donc pas nécessaire de demander à l’utilisateur de choisir manuellement « colis » ou « commande ».

## 5. Reconnaître le type de résultat

Le contrat actuellement exécuté ne rajoute pas de propriété normalisée `type`.

Le mobile doit utiliser les propriétés présentes :

- résultat colis : présence de `trackingNumber` ;
- résultat commande : absence de `trackingNumber` et présence de `reference`.

Ne pas se baser uniquement sur le préfixe saisi, puisqu’un colis peut être retrouvé avec `carrierTrackingNumber`.

Si une future version du backend ajoute un champ `type`, le mobile pourra le privilégier, mais il doit rester compatible avec la réponse actuelle.

## 6. Réponse pour un colis

La route retourne l’objet colis, puis normalise `articles` et ajoute deux historiques.

Exemple représentatif :

```json
{
  "id": "uuid-colis",
  "userId": 42,
  "trackingNumber": "TRACK-2609-AB23",
  "carrierTrackingNumber": "SF1234567890CN",
  "originCountry": "Chine",
  "originCity": "Yiwu",
  "destinationCountry": "Bénin",
  "destinationCity": "Cotonou",
  "shippingMode": "bateau",
  "volumeValue": 0.5,
  "volumeUnit": "CBM",
  "status": "ENVOI_EN_COURS",
  "estimatedDeliveryAt": "2026-12-20T00:00:00.000Z",
  "documentsUrl": null,
  "createdAt": "2026-09-20T10:00:00.000Z",
  "updatedAt": "2026-09-23T12:00:00.000Z",
  "articles": [
    {
      "id": "uuid-article",
      "description": "Chaussures",
      "quantity": 2,
      "unitPrice": 15000,
      "totalPrice": 30000,
      "imageUrl": "https://res.cloudinary.com/...",
      "purchaseLink": null
    }
  ],
  "statusHistory": [
    {
      "id": 1,
      "colisId": "uuid-colis",
      "status": "EN_ATTENTE_CONFIRMATION",
      "createdAt": "2026-09-20T10:00:00.000Z",
      "updatedAt": "2026-09-20T10:00:00.000Z"
    }
  ],
  "historique": [
    {
      "statut": "ENVOI_EN_COURS",
      "commentaire": "Le colis a quitté le cargo",
      "fichierUrl": "https://res.cloudinary.com/...",
      "fichierNom": "preuve.pdf",
      "adminNom": "Support Ahiyoyo",
      "date": "2026-09-23T12:00:00.000Z"
    }
  ]
}
```

Le backend peut retourner d’autres propriétés internes du colis. Le mobile doit utiliser une liste blanche de champs à afficher et ne doit pas exposer automatiquement toute propriété reçue.

## 7. Informations colis à afficher

Afficher au minimum :

- `trackingNumber` comme référence principale Ahiyoyo ;
- `carrierTrackingNumber` comme référence transporteur lorsqu’elle existe ;
- le statut actuel `status` ;
- le corridor complet ;
- le mode de transport ;
- la quantité déclarée et l’unité ;
- la date d’enregistrement ;
- la date estimée de livraison lorsqu’elle existe ;
- les articles, images et liens utiles lorsqu’ils existent ;
- le document global `documentsUrl` lorsqu’il existe ;
- la chronologie des statuts ;
- les commentaires et fichiers publics fournis dans `historique`.

Ne pas afficher publiquement par défaut :

- `userId` ;
- les identifiants techniques de relations ;
- les champs internes ou administratifs non nécessaires ;
- les valeurs absentes sous la forme `null` ;
- une donnée nouvellement ajoutée par le backend sans validation fonctionnelle préalable.

## 8. Statuts possibles d’un colis

| Valeur API | Libellé public recommandé |
|---|---|
| `EN_ATTENTE_CONFIRMATION` | En attente de confirmation |
| `RECU_AU_CARGO` | Reçu au cargo |
| `ENVOI_EN_COURS` | Envoi en cours |
| `EN_ATTENTE_RETRAIT` | En attente de retrait |
| `RETRAIT_EFFECTUE` | Retrait effectué |
| `EN_TRANSIT` | En transit |
| `ARRIVE_A_DESTINATION` | Arrivé à destination |
| `LIVRE` | Livré |
| `ANNULE` | Annulé |

Si un nouveau statut inconnu apparaît, afficher une version lisible de sa valeur au lieu de masquer tout le résultat.

## 9. Les deux historiques du colis

### `statusHistory`

Historique automatique et minimal des changements de statut du colis. Chaque entrée contient principalement `status` et ses dates techniques.

### `historique`

Historique enrichi produit par les opérations administratives. Une entrée peut contenir :

- `statut` ;
- `commentaire` ;
- `fichierUrl` ;
- `fichierNom` ;
- `adminNom` ;
- `date`.

Les deux tableaux peuvent représenter le même changement. Le mobile ne doit pas les concaténer naïvement au risque d’afficher des doublons.

Pour la timeline principale :

- utiliser `statusHistory` pour garantir la chronologie des statuts, y compris le statut initial ;
- enrichir une étape avec les données de `historique` lorsqu’une entrée correspondante existe ;
- sinon présenter `historique` dans une section distincte « Mises à jour détaillées » ;
- trier visuellement par date croissante pour raconter le trajet du plus ancien au plus récent.

## 10. Réponse pour une commande

Exemple représentatif :

```json
{
  "id": "uuid-commande",
  "reference": "CMD-2609-AB23",
  "factureProformaId": "uuid-facture",
  "userId": 42,
  "statut": "ENVOI_EN_COURS",
  "paiementConfirmeAt": "2026-09-21T08:00:00.000Z",
  "createdAt": "2026-09-20T10:00:00.000Z",
  "updatedAt": "2026-09-23T12:00:00.000Z",
  "facture": {
    "numero": "FAC-2609-XY45",
    "nomArticle": "Chaussures",
    "montantTotal": "73000.00",
    "delaiEstimatif": "14 à 21 jours",
    "ligneTarifaire": {
      "paysDepart": "Chine",
      "villeDepart": "Guangzhou",
      "paysDestination": "Bénin",
      "villeDestination": "Cotonou",
      "modeTransport": "air_standard"
    }
  },
  "historique": [
    {
      "statut": "ENVOI_EN_COURS",
      "commentaire": "Commande expédiée",
      "fichierUrl": null,
      "fichierNom": null,
      "adminNom": "Support Ahiyoyo",
      "date": "2026-09-23T12:00:00.000Z"
    }
  ]
}
```

Le champ `facture` peut être `null`. Sa propriété `ligneTarifaire` peut également être `null`.

Comme pour les colis, la réponse actuelle contient certains identifiants techniques. Le mobile doit afficher uniquement les informations utiles au suivi public.

## 11. Informations commande à afficher

Afficher au minimum :

- `reference` ;
- le statut actuel `statut` ;
- la date de création ;
- la confirmation de paiement si elle existe ;
- le numéro de facture si utile ;
- le nom de l’article ;
- le montant total, correctement formaté en FCFA ;
- le délai estimatif ;
- le corridor et le mode venant de `facture.ligneTarifaire` ;
- la timeline `historique` avec commentaires et pièces jointes.

Masquer proprement les sections dont les données sont `null`.

## 12. Statuts possibles d’une commande

| Valeur API | Libellé public recommandé |
|---|---|
| `EN_ATTENTE_VALIDATION` | En attente de validation |
| `EN_ATTENTE_PAIEMENT` | En attente de paiement |
| `COMMANDE_EN_COURS` | Commande en cours de traitement |
| `ENVOYEE_AU_CARGO` | Envoyée au cargo |
| `RECUE_AU_CARGO` | Reçue au cargo |
| `ENVOI_EN_COURS` | Envoi en cours |
| `FORMALITES_EN_COURS` | Formalités en cours |
| `DISPONIBLE_ENTREPOT` | Disponible en entrepôt |

## 13. Fichiers et images

Les propriétés suivantes sont des URL retournées par le backend :

```text
articles[].imageUrl
documentsUrl
historique[].fichierUrl
```

Comportement attendu :

- images : aperçu et ouverture si possible ;
- document global : bouton « Consulter le document » ;
- fichier d’historique : afficher `fichierNom` et permettre l’ouverture ;
- ne rien afficher lorsque l’URL est absente ;
- gérer proprement une URL devenue indisponible ;
- ne jamais reconstruire une URL `/uploads/...` à partir du domaine mobile.

## 14. Référence introuvable

Si aucun colis ni aucune commande ne correspond :

```http
HTTP 404
```

```json
{
  "message": "Aucun colis ni commande trouvé pour cette référence"
}
```

Afficher un état clair sans révéler d’informations supplémentaires :

```text
Aucun colis ni aucune commande ne correspond à cette référence. Vérifiez le numéro puis réessayez.
```

Ne pas rediriger vers la connexion.

## 15. Erreurs et états d’interface

États nécessaires :

- saisie initiale ;
- recherche en cours ;
- résultat colis ;
- résultat commande ;
- référence introuvable ;
- champ vide ;
- absence de réseau ;
- erreur serveur ;
- nouvelle tentative.

Pendant une recherche :

- désactiver les doubles soumissions ;
- conserver la référence visible ;
- ignorer une ancienne réponse si une nouvelle recherche a été lancée ;
- remettre à zéro l’ancien résultat avant ou au début d’une nouvelle recherche.

Une réponse `404` est un résultat fonctionnel « introuvable », pas une panne. Une réponse `500` ou un timeout correspond à une erreur technique.

## 16. Actualisation et partage

Le résultat doit pouvoir être actualisé avec la même référence pour récupérer un nouveau statut.

Actions utiles :

- copier la référence ;
- partager la référence ;
- relancer la recherche ;
- ouvrir une image ou une pièce jointe ;
- revenir à une nouvelle recherche.

La page ne doit pas inventer une progression en fonction du temps. Elle affiche uniquement le statut et les dates renvoyés par l’API.

## 17. Protection des données côté interface

Le suivi est public. Le mobile ne doit donc pas afficher aveuglément toute la réponse JSON.

Utiliser uniquement les champs explicitement décrits comme affichables dans ce document. En particulier, masquer les identifiants utilisateur et techniques.

Ne jamais journaliser en production la réponse complète du tracking si elle contient des informations métier ou personnelles. Ne pas conserver durablement les résultats publics dans un stockage non sécurisé.

## 18. Checklist de validation mobile

- [ ] La page est accessible sans token.
- [ ] Le paramètre envoyé s’appelle exactement `q`.
- [ ] Les espaces extérieurs sont supprimés.
- [ ] La recherche fonctionne avec un `trackingNumber` Ahiyoyo.
- [ ] La recherche fonctionne avec un `carrierTrackingNumber`.
- [ ] La recherche fonctionne avec une référence de commande.
- [ ] Le type est détecté par `trackingNumber` ou `reference`, sans dépendre uniquement du préfixe saisi.
- [ ] Les statuts colis et commande utilisent les bons libellés.
- [ ] Le corridor est présenté dans le bon sens.
- [ ] Les champs facultatifs `null` sont masqués.
- [ ] Les deux historiques d’un colis ne créent pas de doublons visuels.
- [ ] La timeline est présentée chronologiquement.
- [ ] Les commentaires et fichiers disponibles sont affichés.
- [ ] Les identifiants techniques ne sont pas exposés.
- [ ] Une réponse `404` affiche « introuvable » sans demander une connexion.
- [ ] Une panne réseau est distinguée d’un résultat introuvable.
- [ ] Une actualisation recharge le statut depuis l’API.
- [ ] Aucune progression n’est calculée localement.

## 19. Résumé de la route

| Fonction | Méthode | Route | Authentification |
|---|---:|---|---:|
| Rechercher un colis ou une commande | `GET` | `/api/tracking?q=<reference>` | Aucune |

