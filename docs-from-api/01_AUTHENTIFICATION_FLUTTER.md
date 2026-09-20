# Authentification client — Contrat d’intégration mobile

## 1. Objectif et périmètre

Ce document décrit l’intégration complète de l’authentification dans l’application mobile Ahiyoyo.

L’application mobile couvre exclusivement le parcours client. Elle ne doit proposer aucun écran, menu ou comportement administratif, même si la réponse d’authentification contient un champ `role`.

Fonctionnalités couvertes :

- inscription par email et mot de passe ;
- activation du compte par code reçu par email ;
- renvoi du code d’activation ;
- connexion par email et mot de passe ;
- connexion Google ;
- mot de passe oublié et réinitialisation ;
- restauration et fermeture de session ;
- récupération et modification du profil ;
- changement de mot de passe ;
- gestion centralisée des erreurs et des tokens.

## 2. Configuration générale

L’URL de base de l’API doit venir de la configuration d’environnement de l’application. Elle ne doit pas être répétée dans chaque service ni codée en dur dans les écrans.

Toutes les routes ci-dessous sont relatives à cette URL de base.

Les requêtes JSON doivent envoyer :

```http
Content-Type: application/json
Accept: application/json
```

Les routes protégées doivent également envoyer :

```http
Authorization: Bearer <token>
```

L’API n’utilise actuellement ni cookie de session ni refresh token.

## 3. Modèle utilisateur retourné

Les connexions classique et Google retournent cette structure :

```json
{
  "token": "jwt",
  "expiresAt": "2026-09-27T15:00:00.000Z",
  "user": {
    "id": 42,
    "nom": "Koffi",
    "prenom": "Jean",
    "email": "jean@example.com",
    "numero": "97000000",
    "code_pays": "229",
    "avatarUrl": "https://...",
    "phone_verified": false,
    "email_verified": true,
    "role": "USER",
    "createdAt": "2026-09-20T10:00:00.000Z",
    "updatedAt": "2026-09-20T10:00:00.000Z"
  }
}
```

Notes :

- `numero`, `code_pays` et `avatarUrl` peuvent être `null` ;
- le rôle provient du backend et ne doit jamais être envoyé ou choisi par le mobile ;
- l’application mobile doit accepter uniquement le parcours `USER` ;
- `expiresAt` est l’échéance officielle du token et doit être converti en UTC avec `DateTime.parse(...)` ;
- la durée d’un token client est configurée côté serveur (`JWT_EXPIRES`, actuellement `7d` par défaut).

## 4. Inscription classique

### Route

```http
POST /api/register
```

### Payload

```json
{
  "nom": "Koffi",
  "prenom": "Jean",
  "email": "jean@example.com",
  "mot_de_passe": "mot-de-passe-securise",
  "numero": "97000000",
  "code_pays": "229",
  "code_parrainage": "AHIABC234"
}
```

Règles :

- `nom`, `prenom`, `email` et `mot_de_passe` sont obligatoires pour l’API ;
- le mot de passe doit contenir au moins 8 caractères ;
- le backend tolère techniquement l’absence de `numero` et `code_pays`, mais le parcours client Ahiyoyo impose actuellement un téléphone valide : l’application mobile doit donc rendre le pays, le code pays et le numéro obligatoires, comme l’application web ;
- le bouton d’inscription doit rester désactivé tant que le pays ou le numéro manque, ou que le numéro n’est pas valide pour le pays sélectionné ;
- `code_parrainage` reste facultatif ;
- envoyer `numero` sans espaces ni ponctuation et `code_pays` sans `+` ;
- le backend nettoie tout de même les caractères non numériques du téléphone ;
- le code de parrainage est converti en majuscules par le backend ;
- ne jamais envoyer `role`, `email_verified`, `phone_verified` ou un identifiant utilisateur.

Si le code de parrainage n’est pas renseigné, il est préférable de l’omettre plutôt que d’envoyer une chaîne vide.

### Acceptation obligatoire des documents légaux

Avant l’inscription, afficher une case à cocher non sélectionnée par défaut :

```text
J’ai lu et j’accepte les CGU et la Politique de confidentialité.
```

Les deux libellés doivent ouvrir les pages publiques correspondantes :

- CGU : `https://ahiyoyo.com/cgu` ;
- Politique de confidentialité : `https://ahiyoyo.com/confidentialite`.

L’inscription doit être bloquée tant que cette case n’est pas cochée. Cette acceptation est actuellement une règle du parcours client : elle n’est pas envoyée dans le payload de `POST /api/register`, car l’API ne prévoit pas de propriété de consentement dans ce contrat.

### Vérification préalable du code de parrainage

Lorsqu’un code est saisi, le mobile doit le vérifier avant de permettre l’inscription :

```http
GET /api/parrainage/verifier?code=AHIABC234
```

Cette route est publique et ne demande aucun token.

Comportement attendu :

1. supprimer les espaces extérieurs et convertir le code en majuscules ;
2. attendre environ `450 ms` après la dernière frappe avant d’appeler l’API ;
3. ne lancer aucune vérification lorsque le champ est vide ;
4. afficher un indicateur pendant la vérification ;
5. ignorer la réponse d’une ancienne requête si le code a changé entre-temps ;
6. autoriser l’inscription sans code lorsque le champ reste vide ;
7. bloquer l’inscription lorsqu’un code est renseigné mais non vérifié ou invalide ;
8. envoyer le code validé dans `code_parrainage` lors de l’inscription.

Code valide — `200` :

```json
{
  "valid": true,
  "parrainNomPublic": "Jean K."
}
```

Afficher une confirmation telle que :

```text
✓ Parrain : Jean K.
```

Code absent — `400` :

```json
{
  "valid": false,
  "message": "Code requis"
}
```

Code inconnu — `404` :

```json
{
  "valid": false,
  "message": "Code de parrainage introuvable"
}
```

Même après une vérification positive, `POST /api/register` reste la validation définitive : le backend revérifie le code au moment de créer le compte. Le mobile doit donc également gérer un rejet du code lors de la soumission.

### Succès — `201`

```json
{
  "message": "Compte créé. Un code d’activation a été envoyé par e-mail.",
  "userId": 42
}
```

Après ce succès, naviguer vers l’écran d’activation en lui transmettant l’email. L’inscription ne connecte pas automatiquement l’utilisateur et ne retourne aucun JWT.

### Erreurs importantes

- `400` : validation des champs ou code de parrainage introuvable ;
- `409` : email ou numéro déjà utilisé ;
- `500` : erreur serveur.

Les erreurs du validateur peuvent être structurées ainsi :

```json
{
  "errors": [
    {
      "type": "field",
      "value": "",
      "msg": "Le nom est requis",
      "path": "nom",
      "location": "body"
    }
  ]
}
```

Le mobile doit associer chaque erreur à son champ grâce à `path`. S’il n’existe pas de `path`, afficher `message` dans une alerte ou un bandeau global.

## 5. Activation du compte par email

### Route

```http
POST /api/email/activate
```

### Payload

```json
{
  "email": "jean@example.com",
  "code": "123456"
}
```

Le code contient 6 chiffres. L’interface doit conserver les zéros éventuels et l’envoyer comme chaîne de caractères.

### Succès — `200`

```json
{
  "message": "Compte activé, vous pouvez maintenant vous connecter."
}
```

Si le compte était déjà activé, l’API peut aussi répondre `200` :

```json
{
  "message": "Compte déjà activé."
}
```

Dans les deux cas, rediriger vers la connexion.

### Erreurs importantes

- `400` : email/code manquant, code invalide ou expiré ;
- `404` : utilisateur introuvable ;
- `429` : trop de tentatives ;
- `500` : erreur serveur.

## 6. Renvoyer le code d’activation

### Route

```http
POST /api/email/resend-activation
```

### Payload

```json
{
  "email": "jean@example.com"
}
```

### Succès — `200`

```json
{
  "message": "Un nouveau code d’activation a été envoyé par e-mail.",
  "ttl_hours": 24
}
```

`ttl_hours` doit être considéré comme fourni par le serveur. Ne pas coder `24` en dur dans l’application.

Erreurs possibles : email requis, compte inexistant, compte déjà activé, limite de requêtes atteinte ou erreur serveur.

## 7. Connexion classique

### Route

```http
POST /api/login
```

### Payload

```json
{
  "email": "jean@example.com",
  "mot_de_passe": "mot-de-passe-securise"
}
```

Le validateur de connexion exige un mot de passe d’au moins 6 caractères. Un compte nouvellement créé impose toutefois au moins 8 caractères.

### Succès — `200`

La réponse contient `token`, `expiresAt` et `user` selon le modèle décrit plus haut.

Après le succès :

1. vérifier que `user.role == "USER"` pour ce parcours mobile ;
2. enregistrer le token et `expiresAt` dans un stockage sécurisé ;
3. conserver les données utilisateur en mémoire dans l’état d’authentification ;
4. ouvrir l’espace client.

### Erreurs importantes

```json
{
  "message": "Identifiants invalides"
}
```

```json
{
  "message": "Veuillez d’abord activer votre compte via le code reçu par e-mail."
}
```

Pour le `403` d’activation, proposer directement :

- « Saisir le code d’activation » ;
- « Renvoyer le code ».

Un compte créé uniquement via Google produit :

```json
{
  "code": "GOOGLE_ONLY_ACCOUNT",
  "message": "Ce compte a été créé avec Google, connectez-vous via \"Continuer avec Google\"."
}
```

Dans ce cas, afficher le message et mettre en évidence le bouton Google.

## 8. Connexion Google

### Principe mobile

Le SDK Google officiel utilisé par l’application obtient un Google ID token. Le mobile envoie uniquement ce token au backend. Il ne doit pas décoder le token pour décider quel utilisateur connecter et ne doit jamais fabriquer lui-même un rôle.

La configuration Android/iOS et les Client IDs Google doivent correspondre à la configuration validée pour Ahiyoyo. Le Client ID utilisé comme audience côté serveur doit être celui fourni par l’équipe backend. Ne pas utiliser un Client ID arbitraire.

### Route

```http
POST /api/auth/google
```

### Payload

```json
{
  "id_token": "google-id-token",
  "code_parrainage": "AHIABC234"
}
```

`code_parrainage` est facultatif et n’est utilisé que si Google crée un nouveau compte. Si un compte existe déjà, le backend retrouve ou lie ce compte grâce à l’adresse email vérifiée par Google.

### Succès — `200`

La réponse est strictement du même type que la connexion classique :

```json
{
  "token": "jwt-ahiyoyo",
  "expiresAt": "2026-09-27T15:00:00.000Z",
  "user": {}
}
```

Attention : le token à stocker pour appeler l’API Ahiyoyo est `token`, retourné par le backend, et non le Google ID token.

### Erreurs importantes

- `400` : `id_token` absent ou code de parrainage introuvable ;
- `401` : token Google invalide, expiré ou email Google non vérifié ;
- `429` : trop de tentatives ;
- `500` : configuration Google serveur absente ou erreur serveur.

Si l’utilisateur ferme la fenêtre Google, considérer cela comme une annulation locale et ne pas afficher une erreur serveur.

## 9. Mot de passe oublié

### Étape 1 — demander le code

```http
POST /api/password/forgot
```

```json
{
  "email": "jean@example.com"
}
```

Succès :

```json
{
  "message": "Un code de réinitialisation a été envoyé par e-mail.",
  "ttl_seconds": 600
}
```

Utiliser `ttl_seconds` pour le compte à rebours d’interface. La valeur par défaut côté serveur est actuellement 10 minutes, mais elle ne doit pas être codée en dur.

La route est limitée à 5 requêtes par minute et par IP.

### Étape 2 — définir le nouveau mot de passe

```http
POST /api/password/reset
```

```json
{
  "email": "jean@example.com",
  "code": "123456",
  "nouveau_mot_de_passe": "nouveau-mot-de-passe"
}
```

Règles :

- tous les champs sont obligatoires ;
- le nouveau mot de passe doit contenir au moins 8 caractères ;
- le code doit correspondre au dernier code généré et ne pas être expiré.

Succès :

```json
{
  "message": "Mot de passe mis à jour"
}
```

Après le succès, supprimer les données temporaires de réinitialisation et rediriger vers la connexion. Cette route ne crée pas automatiquement une session.

## 10. Profil du client connecté

### Charger le profil

```http
GET /api/me
Authorization: Bearer <token>
```

Réponse :

```json
{
  "id": 42,
  "nom": "Koffi",
  "prenom": "Jean",
  "numero": "97000000",
  "code_pays": "229",
  "email": "jean@example.com",
  "phone_verified": false,
  "email_verified": true,
  "is_fully_verified": false,
  "role": "USER",
  "createdAt": "2026-09-20T10:00:00.000Z",
  "updatedAt": "2026-09-20T10:00:00.000Z"
}
```

Cette route est la source de vérité pour restaurer ou rafraîchir l’utilisateur courant. Elle ne retourne actuellement pas `avatarUrl`.

### Modifier le profil

```http
PATCH /api/me/profile
Authorization: Bearer <token>
```

Envoyer au moins l’une des propriétés :

```json
{
  "prenom": "Jean-Paul",
  "nom": "Koffi"
}
```

Seuls `prenom` et `nom` sont modifiables avec cette route. Ne pas envoyer l’email, le téléphone, le rôle ou les indicateurs de vérification.

La réponse contient le profil actualisé au même format que `GET /api/me`.

## 11. Changer le mot de passe connecté

Cette fonction concerne un compte disposant déjà d’un mot de passe classique.

```http
POST /api/auth/change-password
Authorization: Bearer <token>
```

```json
{
  "currentPassword": "ancien-mot-de-passe",
  "newPassword": "nouveau-mot-de-passe"
}
```

Règles :

- les deux propriétés sont obligatoires ;
- `newPassword` doit contenir au moins 8 caractères ;
- le mot de passe actuel doit être correct.

Succès :

```json
{
  "message": "Mot de passe mis à jour"
}
```

L’API ne retourne pas un nouveau JWT après ce changement. Le token courant reste donc utilisable jusqu’à son expiration ou jusqu’à la déconnexion locale.

Pour un compte créé uniquement avec Google, ne pas présenter ce formulaire comme un changement classique de mot de passe.

## 12. Stockage et cycle de vie de la session

Utiliser le stockage sécurisé et chiffré fourni pour les secrets de l’application mobile. Ne jamais stocker le JWT dans une préférence locale non sécurisée.

Valeurs recommandées :

```text
auth_token
auth_expires_at
```

Les données utilisateur peuvent être gardées en mémoire et rechargées avec `GET /api/me`. Si elles sont mises en cache localement, elles ne doivent pas remplacer la réponse du serveur comme source de vérité.

Au démarrage de l’application :

1. lire `auth_token` et `auth_expires_at` ;
2. si l’une des valeurs est absente, afficher le parcours non connecté ;
3. si `expiresAt` est déjà dépassé, supprimer la session locale ;
4. sinon appeler `GET /api/me` avec le token ;
5. si la réponse réussit, restaurer la session ;
6. si elle retourne `401`, supprimer la session et afficher la connexion ;
7. en cas de simple absence de réseau, ne pas confondre automatiquement l’erreur avec une expiration de session.

Il n’existe pas de route backend de déconnexion. La déconnexion mobile consiste à :

- supprimer le token et son échéance du stockage sécurisé ;
- supprimer les données utilisateur en mémoire/cache ;
- annuler ou nettoyer les données sensibles propres à la session ;
- rediriger vers l’écran de connexion.

## 13. Gestion HTTP centralisée recommandée

La couche réseau de l’application doit ajouter automatiquement le header `Authorization: Bearer <token>` aux routes Ahiyoyo protégées.

Elle ne doit pas ajouter ce header aux appels Google externes ni aux routes publiques qui n’en ont pas besoin.

Lorsqu’une route protégée retourne `401`, la couche d’authentification doit supprimer la session locale et ramener l’utilisateur vers la connexion. Une erreur de connexion internet, un timeout ou une réponse `500` ne doivent pas être traités comme une expiration de session.

Éviter plusieurs redirections simultanées si plusieurs requêtes retournent `401` en même temps : centraliser la déconnexion avec un verrou ou un événement unique.

## 14. Normalisation des erreurs

L’API utilise principalement deux formats.

Erreur globale :

```json
{
  "message": "Identifiants invalides",
  "code": "CODE_EVENTUEL"
}
```

Erreurs de champs :

```json
{
  "errors": [
    {
      "msg": "Email invalide",
      "path": "email"
    }
  ]
}
```

Le parseur mobile doit :

1. lire `errors[]` et associer chaque `msg` à `path` ;
2. sinon utiliser `message` ;
3. sinon afficher un message générique localisé ;
4. distinguer une erreur HTTP d’une erreur réseau/timeout ;
5. ne jamais afficher directement une stack trace ou un objet technique.

Traitement recommandé par statut :

- `400` : saisie invalide ;
- `401` pendant la connexion : identifiants ou Google token invalides ;
- `401` sur une route protégée : session à supprimer ;
- `403` pendant la connexion : compte à activer ;
- `404` : compte introuvable selon le parcours ;
- `409` : donnée déjà utilisée ;
- `429` : demander à l’utilisateur de patienter ;
- `500` : message générique et possibilité de réessayer.

## 15. États d’interface attendus

Chaque action asynchrone doit au minimum gérer :

- état initial ;
- chargement avec bouton désactivé ;
- succès ;
- erreur de champ ;
- erreur globale ;
- erreur réseau ;
- nouvelle tentative.

Éviter les doubles soumissions sur l’inscription, l’activation, Google Sign-In et la réinitialisation.

Écrans recommandés :

1. accueil d’authentification ;
2. connexion ;
3. inscription avec téléphone obligatoire, vérification du parrainage et acceptation des documents légaux ;
4. activation email ;
5. mot de passe oublié ;
6. saisie du code et du nouveau mot de passe ;
7. chargement/restauration de session ;
8. profil client ;
9. modification du nom/prénom ;
10. changement de mot de passe pour les comptes concernés.

## 16. Checklist de validation mobile

- [ ] Blocage de l’inscription sans pays, code pays ou numéro.
- [ ] Rejet local d’un numéro invalide pour le pays sélectionné.
- [ ] Inscription avec téléphone et code pays valides.
- [ ] Blocage tant que les CGU et la Politique de confidentialité ne sont pas acceptées.
- [ ] Ouverture correcte des liens CGU et Politique de confidentialité.
- [ ] Inscription sans code de parrainage.
- [ ] Inscription avec un code de parrainage valide.
- [ ] Vérification différée du code et affichage du nom public du parrain.
- [ ] Rejet d’un code de parrainage invalide.
- [ ] Blocage de l’inscription pendant la vérification ou lorsque le code saisi est invalide.
- [ ] Rejet d’un email déjà utilisé.
- [ ] Activation avec le bon code.
- [ ] Rejet d’un code invalide ou expiré.
- [ ] Renvoi du code d’activation.
- [ ] Connexion classique après activation.
- [ ] Refus de connexion avant activation.
- [ ] Message adapté pour un compte Google-only.
- [ ] Connexion Google d’un nouveau compte.
- [ ] Connexion Google d’un compte existant portant le même email.
- [ ] Mot de passe oublié et réinitialisation complète.
- [ ] Stockage sécurisé du JWT.
- [ ] Ajout automatique du Bearer token aux routes Ahiyoyo protégées.
- [ ] Restauration de session après fermeture complète de l’application.
- [ ] Déconnexion après un `401` réel.
- [ ] Conservation de la session lors d’une simple perte de réseau.
- [ ] Déconnexion manuelle avec nettoyage des données sensibles.
- [ ] Chargement et modification du profil.
- [ ] Changement de mot de passe classique.
- [ ] Aucun écran ou menu administratif dans l’application mobile.

## 17. Résumé des routes

| Fonction | Méthode | Route | Auth requise |
|---|---:|---|---:|
| Inscription | `POST` | `/api/register` | Non |
| Vérifier un code de parrainage | `GET` | `/api/parrainage/verifier?code=...` | Non |
| Activation email | `POST` | `/api/email/activate` | Non |
| Renvoyer le code | `POST` | `/api/email/resend-activation` | Non |
| Connexion classique | `POST` | `/api/login` | Non |
| Connexion Google | `POST` | `/api/auth/google` | Non |
| Demander un reset | `POST` | `/api/password/forgot` | Non |
| Réinitialiser le mot de passe | `POST` | `/api/password/reset` | Non |
| Profil courant | `GET` | `/api/me` | Bearer |
| Modifier le profil | `PATCH` | `/api/me/profile` | Bearer |
| Changer le mot de passe | `POST` | `/api/auth/change-password` | Bearer |
