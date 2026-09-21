# Guide mobile — Écran "Adresses et tarifs"

> Ce document décrit en détail l'écran web `/tarifs` (menu "Adresses et tarifs", icône `MapPin`) : sa route API, le contrat de données, la logique d'affichage et les comportements à reproduire sur l'application mobile Flutter.
> Contrairement au [guide de parcours général](MOBILE_GUIDE_PARCOURS_CLIENT.md) qui ne mentionne volontairement aucune route API, ce document est le contrat détaillé promis pour cet écran précis.
> Référence croisée : section 2.18 du guide de parcours, et [FRONTEND_GUIDE_COLIS_LIGNE_TARIFAIRE.md](FRONTEND_GUIDE_COLIS_LIGNE_TARIFAIRE.md) pour l'usage de ces mêmes lignes tarifaires côté formulaire d'expédition.

---

## 1. Ce que fait l'écran

Un écran **d'information pure, sans action transactionnelle** : il liste les "lignes tarifaires" actives (une ligne = un trajet + un mode de transport + un prix), avec pour chacune l'adresse de l'entrepôt de dépôt, le contact sur place, les instructions à écrire sur le colis, et des raccourcis pratiques (copier, partager sur WhatsApp).

Il n'y a ni création, ni modification, ni suppression depuis cet écran — c'est un lecteur seul. La gestion (CRUD) des lignes tarifaires se fait exclusivement côté back-office admin web (`/admin/tarifs`, routes `/api/admin/tarifs`) et est **hors périmètre de l'application mobile**, réservée aux clients.

---

## 2. Route API

```http
GET /api/tarifs/public
```

**Point important pour le mobile : cette route ne requiert aucune authentification.** Aucun header `Authorization` n'est nécessaire côté serveur.

> Sur le web, l'écran est néanmoins placé derrière `RequireAuth` (route `/tarifs` accessible uniquement une fois connecté) — c'est une contrainte de navigation du web actuel, pas une contrainte de l'API. Rien n'empêche l'application mobile de proposer cet écran avant connexion (par exemple depuis un onglet "Tarifs" accessible sans compte) si c'est le choix produit retenu ; à confirmer avec l'équipe produit si vous voulez vous en écarter du comportement web actuel.

Le serveur ne retourne que les lignes **actives** (`actif: true`) — le filtrage des lignes désactivées est déjà fait côté backend, l'app n'a rien à filtrer à ce sujet.

### Forme de la réponse

Le frontend web lit la réponse de façon défensive (ce même pattern est répété à l'identique à trois endroits du code) :

```ts
const lignes = Array.isArray(data) ? data : (data.data ?? []);
```

C'est-à-dire que la réponse peut être soit un tableau brut, soit un objet `{ data: [...] }`. **Traitez les deux cas côté mobile** plutôt que de supposer une forme unique — ça évite un écran vide silencieux si le format venait à changer.

### Structure complète d'une ligne

```json
{
  "id": 1,
  "villeDepart": "Yiwu",
  "paysDepart": "Chine",
  "villeDestination": "Cotonou",
  "paysDestination": "Bénin",
  "modeTransport": "air_standard",
  "typeService": "Air standard",
  "categorie": "Produits électroniques et cosmétiques",
  "tarifParKg": "17000.00",
  "tarifParCbm": null,
  "delaiJours": 20,
  "adressePhysique": "浙江省义乌市稠州北路1505号汇商天地726室-AS长胜",
  "contactNom": "AZIM",
  "contactTelephone": "15616109951",
  "instructionsClient": "Marquez AHIYOYO, votre nom et numéro de téléphone sur les cartons ou les emballages",
  "actif": true,
  "createdAt": "2026-05-20T00:00:00.000Z"
}
```

Modèle TypeScript équivalent (tel qu'utilisé par l'écran web ; `actif` et `createdAt` existent dans la réponse mais ne sont pas affichés par cet écran) :

```ts
type LigneTarifaire = {
  id: number;
  villeDepart: string;
  paysDepart: string;
  villeDestination: string;
  paysDestination: string;
  modeTransport: string;          // voir table des modes ci-dessous
  typeService?: string | null;    // libellé affiché, prioritaire sur le libellé par défaut du mode
  categorie?: string | null;      // ex. "Produits électroniques et cosmétiques"
  tarifParKg: string | number | null;
  tarifParCbm: string | number | null;
  delaiJours?: number | null;
  adressePhysique?: string | null;   // peut être en chinois selon l'entrepôt
  contactNom?: string | null;
  contactTelephone?: string | null;
  instructionsClient?: string | null;
};
```

**Attention aux types numériques** : `tarifParKg` / `tarifParCbm` arrivent parfois en `string` (ex. `"17000.00"`), parfois en `number`, et peuvent être `null` si ce mode de tarification ne s'applique pas à la ligne (une ligne maritime a typiquement `tarifParKg: null` et `tarifParCbm` renseigné, et inversement pour l'aérien). Ne jamais supposer qu'un des deux est toujours présent.

---

## 3. Modes de transport (`modeTransport`)

| Code (`modeTransport`) | Libellé par défaut | Icône (cf. iconographie du guide de parcours) |
|---|---|---|
| `air_standard` | Aérien standard | `Plane` |
| `air_economie` | Aérien économie | `Plane` |
| `air_express` | Aérien express | `Plane` |
| `maritime` | Maritime groupage | `Ship` |
| `routier` | Transport routier | `Truck` |

Règles d'affichage du libellé : **`typeService` prime sur le libellé par défaut du mode** quand il est renseigné. Si `modeTransport` reçoit une valeur qui n'est dans aucune des 5 lignes ci-dessus (nouveau mode ajouté côté backend, par exemple), l'écran web retombe sur un badge générique neutre avec `typeService || modeTransport` comme libellé et une icône `Truck` par défaut — **ne pas faire planter l'app ou masquer la ligne si un mode inconnu apparaît**, afficher un badge de repli.

Une pastille de catégorie séparée est affichée si `categorie` est renseigné (ex. "Produits électroniques et cosmétiques"), indépendamment du mode de transport.

---

## 4. Filtres

Quatre filtres, appliqués **côté client** sur la liste déjà chargée (une seule requête au total, pas de re-fetch par filtre, pas de pagination serveur) :

| Filtre | Logique de correspondance |
|---|---|
| Tous | toutes les lignes |
| Aérien | `modeTransport` commence par `"air"` (regroupe `air_standard`, `air_economie`, `air_express`) |
| Maritime | `modeTransport === "maritime"` (égalité stricte) |
| Routier | `modeTransport === "routier"` (égalité stricte) |

Chaque bouton de filtre affiche un compteur (nombre de lignes qui correspondent). **Un filtre dont le compteur vaut 0 est masqué**, sauf "Tous" qui reste toujours visible. Le filtre actif est mis en évidence avec la couleur de marque `#fdc354` (fond plein, texte noir) ; les filtres inactifs ont juste une bordure neutre.

> Une ligne dont le mode n'est ni `air*`, ni `maritime`, ni `routier` exactement n'apparaîtra que sous "Tous" — aucun des 3 filtres spécifiques ne la sélectionnera. Reproduire ce comportement tel quel (ne pas essayer de la deviner dans un des 3 filtres).

---

## 5. Minimum d'expédition (calculé côté app, pas une donnée serveur)

Un badge "Minimum X" est affiché à côté du badge de mode, **entièrement déduit côté frontend** à partir de `modeTransport` (ce n'est pas un champ renvoyé par l'API) :

```ts
function minimumForMode(modeTransport: string): string | null {
  const mode = modeTransport.toLowerCase();
  if (mode.startsWith('air') || mode.includes('avion') || mode.includes('aérien')) {
    return '1 kg';
  }
  if (mode.includes('maritime') || mode.includes('bateau') || mode.includes('navire')) {
    return '0,5 CBM';
  }
  return null; // routier, ou mode non reconnu : pas de badge minimum
}
```

Ces valeurs (1 kg pour l'aérien/express, 0,5 CBM pour le maritime) correspondent aux mêmes minimums déjà documentés côté formulaire d'expédition (section 2.5 du guide de parcours) — c'est une règle produit cohérente à travers l'app, pas une coïncidence entre les deux écrans. Reproduire cette même logique de mots-clés côté mobile plutôt qu'un simple `switch` sur les 5 codes connus, pour rester robuste si un nouveau code de mode apparaît côté backend.

---

## 6. Formatage des montants

```ts
function fmtFCFA(n: string | number | null | undefined): string | null {
  if (n === null || n === undefined || n === '') return null;
  const num = Number(n);
  if (isNaN(num)) return null;
  return new Intl.NumberFormat('fr-FR').format(num) + ' FCFA';
}
```

Résultat type : `125 000 FCFA` (séparateur de milliers = espace, pas de virgule). Un tarif absent (`null`) ne doit **rien afficher** pour cette statistique plutôt qu'un `0 FCFA` ou un tiret — la carte adapte son nombre de colonnes visibles selon les valeurs réellement présentes (tarif/kg, tarif/CBM, délai peuvent chacun être absents indépendamment).

Le délai (`delaiJours`) est affiché en couleur d'accent (`#fdc354`) quand il est présent, contrairement aux deux tarifs qui restent en texte neutre — c'est la seule des trois statistiques mise en avant visuellement.

---

## 7. Contenu et actions de chaque carte

Pour chaque ligne, dans cet ordre :

1. **En-tête** : badge de mode + badge minimum (si applicable) + badge catégorie (si renseignée) + trajet (`paysDepart, villeDepart` → `paysDestination, villeDestination`) avec une flèche entre les deux.
2. **Statistiques** : tarif/kg, tarif/CBM, délai — seules les valeurs non nulles sont rendues (grille à 3 colonnes, colonnes vides simplement absentes).
3. **Adresse de l'entrepôt** (icône `MapPin`) — affichée uniquement si `adressePhysique` est renseigné. Peut contenir du texte en chinois, à afficher tel quel (ne pas tenter de traduire ni de reformater).
4. **Contact sur place** (icône `User`) — affiché si `contactNom` et/ou `contactTelephone` sont renseignés ; le téléphone est un lien cliquable (`tel:`).
5. **Instructions client** (icône `Info`) — mises en valeur dans un encart teinté couleur de marque (fond `#fdc354` à très faible opacité, bordure `#fdc354` à 30 %) si `instructionsClient` est renseigné.
6. **Barre d'actions à 3 boutons égaux** en bas de carte :
   - **Copier l'adresse** : copie `adressePhysique` + `contactNom` + `contactTelephone` concaténés (voir gabarit ci-dessous). Désactivé si `adressePhysique` est vide.
   - **Copier les instructions** : copie `instructionsClient` tel quel. Désactivé si vide.
   - **Partager sur WhatsApp** : ouvre WhatsApp avec un message pré-rempli (voir gabarit ci-dessous). Toujours actif (le message reste utile même sans adresse).
   - Chaque bouton "Copier" affiche une confirmation visuelle (icône qui passe à une coche verte, libellé "Copié !") pendant 2 secondes après l'action.

### Gabarit du texte copié (adresse + contact)

Concaténation avec un séparateur **`，`** (virgule chinoise pleine largeur — ce n'est pas une virgule ASCII standard, c'est intentionnellement le caractère utilisé dans le code actuel, cohérent avec le fait que l'adresse peut elle-même être en chinois) :

```
<adressePhysique>，<contactNom> <contactTelephone>
```

Si `contactNom` ou `contactTelephone` est absent, seul celui présent est inclus (pas d'espace ou de séparateur orphelin).

### Gabarit du message WhatsApp

```ts
function buildWhatsAppText(l: LigneTarifaire, modeLabel: string): string {
  const lines: string[] = ['AHIYOYO'];

  if (l.adressePhysique) {
    lines.push('');
    lines.push('Adresse de dépôt :');
    lines.push([l.adressePhysique, [l.contactNom, l.contactTelephone].filter(Boolean).join(' ')]
      .filter(Boolean).join('，'));
  }

  if (l.instructionsClient) {
    lines.push('');
    lines.push('À écrire sur le colis :');
    lines.push(l.instructionsClient);
  }

  lines.push('');
  lines.push(`Trajet : ${l.paysDepart} (${l.villeDepart}) → ${l.paysDestination} (${l.villeDestination})`);
  lines.push(`Mode : ${modeLabel}`);
  if (l.categorie) lines.push(`Service : ${l.categorie}`);

  return lines.join('\n');
}
```

Sur le web, ce texte est encodé puis ouvert via :

```
https://api.whatsapp.com/send/?text=<texte encodé>&type=custom_url&app_absent=0
```

**Recommandation mobile** : ce lien `https://api.whatsapp.com/send/?text=...` fonctionne aussi tel quel sur mobile (il ouvre l'app WhatsApp installée, ou WhatsApp Web/le store en son absence) — vous pouvez le reprendre à l'identique via un simple lien externe. Une alternative plus "native" est le schéma `whatsapp://send?text=...` combiné à un `share sheet` du système si vous préférez laisser le choix de l'app de partage à l'utilisateur ; dans ce cas, gardez au minimum le même gabarit de texte pour la cohérence du contenu partagé entre web et mobile.

---

## 8. États d'écran

- **Chargement** : spinner centré, aucune autre UI.
- **Erreur réseau/serveur** : bandeau d'erreur avec le message renvoyé par l'API (`error.response.data.message`) ou un message générique de repli.
- **Liste vide côté serveur** (aucune ligne active) : état vide avec icône et message "Les tarifs seront affichés ici dès leur mise en place."
- **Liste non vide mais filtre sans résultat** : état vide distinct, message "Aucune ligne pour ce mode de transport." (ce cas ne peut en théorie pas arriver puisque les filtres à 0 résultat sont masqués, mais le code le gère quand même en filet de sécurité — à garder côté mobile aussi).

Pas de pull-to-refresh ni de bouton de rafraîchissement explicite côté web actuellement ; à évaluer côté mobile selon les conventions habituelles de la plateforme (un pull-to-refresh est une amélioration raisonnable à ajouter, pas une régression par rapport au web).

---

## 9. Ce qui est explicitement hors périmètre mobile

- La gestion admin des lignes tarifaires (`/admin/tarifs`, `GET/POST/PATCH /api/admin/tarifs`) : réservée au back-office web, authentification admin requise, non applicable à l'app mobile client.
- Le calculateur de fret (écran distinct, voir section 2.19 du guide de parcours) n'utilise pas cette route et n'est pas couvert par ce document.

---

## 10. Checklist de recette mobile

- [ ] L'écran se charge sans token (tester en environnement déconnecté si l'app le permet).
- [ ] La réponse est lue en gérant à la fois un tableau brut et `{ data: [...] }`.
- [ ] `tarifParKg` / `tarifParCbm` sont convertis en nombre avant formatage (gérer `string`, `number` et `null`).
- [ ] Une statistique nulle (tarif ou délai) n'affiche rien, jamais `0` ni un tiret trompeur.
- [ ] Un `modeTransport` inconnu affiche un badge de repli au lieu de faire planter l'écran ou de masquer la ligne.
- [ ] Le badge "Minimum" suit la logique par mots-clés (section 5), pas un simple mapping des 5 codes connus.
- [ ] Le filtre "Aérien" utilise bien un `startsWith('air')`, pas une égalité stricte.
- [ ] Les filtres à 0 résultat sont masqués (sauf "Tous").
- [ ] Les 3 boutons d'action par carte sont désactivés individuellement selon la présence des données (adresse / instructions), le partage WhatsApp restant toujours actif.
- [ ] Le texte copié et le message WhatsApp reprennent les mêmes gabarits que le web (y compris le séparateur `，`).
- [ ] Les 4 états d'écran (chargement / erreur / vide global / vide par filtre) sont bien distincts.

---

## Résumé à transmettre au développeur mobile

L'écran "Adresses et tarifs" consomme une unique route publique, `GET /api/tarifs/public`, sans authentification, qui retourne toutes les lignes tarifaires actives avec leur trajet, leur tarif, leur adresse d'entrepôt et leurs instructions. Tout se fait en un seul chargement : pas de pagination, filtres appliqués côté client sur les 4 catégories (Tous/Aérien/Maritime/Routier), et un badge de minimum d'expédition calculé localement à partir du mode de transport plutôt que reçu du serveur. Trois actions par ligne : copier l'adresse, copier les instructions, partager sur WhatsApp avec un message pré-formaté — à reproduire à l'identique pour la cohérence entre web et mobile.
