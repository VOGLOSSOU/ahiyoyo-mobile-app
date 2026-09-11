# Guide mobile Ahiyoyo — Parcours client de bout en bout

> Ce document décrit, écran par écran, le parcours de l'utilisateur **simple (client)** tel qu'il existe aujourd'hui sur l'application web Ahiyoyo, ainsi que l'identité visuelle à reproduire sur l'application mobile Flutter.
> Volontairement, **aucune route API n'est mentionnée ici** — les contrats backend seront fournis séparément, écran par écran, au moment de leur implémentation.
> Ce document ne couvre pas l'espace administrateur : l'application mobile est réservée aux clients (utilisateurs simples).

---

## 1. Identité visuelle

### 1.1 Mode d'affichage

L'application web fonctionne **exclusivement en mode sombre** — c'est un choix produit assumé, il n'y a ni bascule clair/sombre ni suivi du thème système. **L'application mobile doit reproduire ce même choix : mode sombre uniquement, pas de thème clair.**

### 1.2 Couleurs

**Couleur de marque (accent)**

| Rôle | Valeur | Usage |
|---|---|---|
| Primaire / accent Ahiyoyo | `#fdc354` (doré/ambre) | Boutons d'action principale, éléments actifs, icônes de mise en avant, montants importants, barre de progression |

C'est la seule couleur de marque forte de l'app. Elle est utilisée avec parcimonie : un bouton principal, un badge actif, une icône clé — jamais en fond de grandes surfaces.

**Fond & surfaces (mode sombre)**

| Rôle | Valeur (Tailwind → hex) |
|---|---|
| Fond de l'application | `neutral-900` → `#171717` |
| Fond des cartes / conteneurs | `neutral-900` (`#171717`) ou `neutral-800` (`#262626`) selon le contexte |
| Bordures de cartes | `neutral-800` (`#262626`) ou `neutral-700` (`#404040`) |
| Texte principal | blanc pur ou proche (`#ffffff`) |
| Texte secondaire / labels | `neutral-400` (`#a3a3a3`) |
| Texte tertiaire / méta (dates, petites légendes) | `neutral-500` (`#737373`) |

**Palette de statuts** (réutilisée sur devis, factures, commandes, colis — les libellés changent mais la logique de couleur est constante) :

| Couleur | Signification typique | Exemple d'usage |
|---|---|---|
| Jaune/orange (`amber`/`orange`/`yellow`) | En attente (d'action, de paiement, de validation) | "En attente de soumission", "En attente de paiement" |
| Bleu | Soumis / en cours de traitement initial | "Demande soumise", "Commande en cours" |
| Violet/Indigo | Étape intermédiaire de traitement | "En cours d'analyse", "Formalités en cours" |
| Vert | Succès / terminé / payé / livré | "Payée", "Disponible en entrepôt", "Caution payée" |
| Rouge | Erreur, annulé, montant déduit | "Annulé", ligne de déduction dans un récapitulatif |
| Gris neutre | Statut neutre / brouillon | "Brouillon" |

Chaque badge de statut est un pastille arrondie (pill), fond teinté clair (dans sa version dark : fond de la couleur à faible opacité, texte de la couleur en version claire). Toujours accompagné d'une icône cohérente avec le sens (horloge = attente, check = succès, etc.).

### 1.3 Typographie

**Il n'y a pas de police de caractères personnalisée.** Le projet n'importe aucune webfont (pas de Google Fonts, pas de `@font-face`) : il repose entièrement sur la pile de polices système par défaut de Tailwind CSS (`ui-sans-serif, system-ui, -apple-system, "Segoe UI", Roboto, Helvetica, Arial, sans-serif`). Concrètement, ça donne San Francisco sur iOS/macOS et Roboto sur Android.

→ Recommandation pour le mobile : **utiliser la police système par défaut de chaque plateforme** (comportement natif de Flutter si on ne force pas de `fontFamily`), pour rester fidèle à l'identité actuelle. Si une police unique cross-plateforme est préférée pour l'app mobile, c'est un choix à valider avec l'équipe avant de commencer — ce n'est pas ce qui est fait aujourd'hui sur le web.

**Échelle typographique observée :**

| Usage | Taille / graisse |
|---|---|
| Titre de page | 24px (`text-2xl`) à 30px (`text-3xl`) selon les écrans, gras (`bold`) |
| Titre de section / carte | 14px (`text-sm`), semi-gras (`semibold`), souvent précédé d'une icône |
| Corps de texte | 14px (`text-sm`) |
| Libellés secondaires, dates, méta | 12px (`text-xs`) |
| Montants / chiffres mis en avant | 20–24px, gras |

### 1.4 Formes & composants

- **Coins très arrondis** : cartes en `rounded-xl` (12px) à `rounded-2xl` (16px), boutons en `rounded-lg` à `rounded-xl`. C'est une esthétique douce, jamais d'angles vifs.
- **Cartes délimitées par une bordure plus que par une ombre** : la plupart des cartes utilisent une bordure fine ou double (`border` / `border-2`) en `neutral-700`/`neutral-800`, avec très peu d'ombre portée (`shadow-sm` au maximum). L'élévation visuelle vient de la bordure et du contraste de fond, pas d'ombres marquées.
- **Cartes cliquables** : une carte entière (ex. une ligne de la liste "Mes devis") est cliquable et réagit au survol/tap par un changement de bordure — à adapter en mobile par un effet de pression (ripple/opacité) plutôt qu'un `hover`.
- **Boutons** :
  - Primaire (action principale) : fond `#fdc354`, texte noir, gras, coins arrondis.
  - Secondaire : bordure neutre, texte clair, fond transparent ou `neutral-800`.
  - Destructif (rare côté client) : texte/icône rouge.
- **Champs de formulaire** : fond `neutral-800`/`neutral-900`, bordure `neutral-700`, coins arrondis, halo doré (`#fdc354` à faible opacité) au focus. Les erreurs de champ passent la bordure en rouge et affichent un message rouge sous le champ.
- **Barre de progression par étapes** (wizards) : cercles numérotés reliés par un trait, rempli en doré pour les étapes complétées, contour foncé pour l'étape active.

### 1.5 Iconographie

L'app web utilise exclusivement les icônes **Lucide** (`lucide-react`). Pour une parité visuelle exacte, utiliser un portage Lucide pour Flutter (ex. package `lucide_icons` / `flutter_lucide`) plutôt que Material Icons par défaut, dont le style diffère (Lucide = traits fins, minimalistes ; Material = plus plein/géométrique).

Les noms ci-dessous sont ceux des icônes Lucide utilisées sur le web. Le nom exposé par le package Flutter peut légèrement varier en casse, mais il faut conserver le même pictogramme.

**Navigation client principale**

| Destination | Icône Lucide | Usage mobile attendu |
|---|---|---|
| Tableau de bord | `Home` | Accueil et premier onglet de navigation |
| Groupage maritime | `Ship` | Liste et accès aux offres maritimes |
| Groupage aérien | `Plane` | Liste et accès aux offres aériennes |
| Mes devis | `FileText` | Demandes de devis |
| Mes factures | `Receipt` | Factures proforma |
| Mes commandes | `Truck` | Commandes et acheminement |
| Mes colis | `Package` | Expéditions enregistrées |
| Notifications | `Bell` | Centre de notifications et bouton du header |
| Gagner de l'argent | `Gift` | Parrainage et gains |
| Adresses et tarifs | `MapPin` | Entrepôts, routes et tarifs |
| Paramètres | `Settings` | Profil et sécurité |

Si une barre de navigation basse est retenue, reprendre exactement ces icônes pour les destinations qui y figurent. Une même destination ne doit pas changer d'icône entre la barre basse, un menu secondaire et les raccourcis du dashboard.

**Actions et informations récurrentes**

| Sens ou action | Icône Lucide |
|---|---|
| Rechercher ou suivre | `Search` |
| Ajouter/créer | `Plus` |
| Retour | `ArrowLeft` |
| Continuer/ouvrir | `ArrowRight` ou `ChevronRight` |
| Élément précédent/suivant | `ChevronLeft` / `ChevronRight` |
| Trier | `ArrowDownUp` |
| Copier | `Copy`, remplacée temporairement par `Check` après succès |
| Partager | `Share2` |
| Ouvrir un lien externe | `ExternalLink` |
| Télécharger une pièce ou un PDF | `Download` |
| Ajouter une pièce | `Upload` |
| Supprimer | `Trash2` |
| Fermer une modale ou un bandeau | `X` |
| Afficher/masquer un mot de passe | `Eye` / `EyeOff` |
| Date ou échéance | `Calendar` ou `CalendarClock` selon le contexte |
| Adresse | `MapPin` |
| Téléphone | `Phone` |
| Client/propriétaire | `User` ; plusieurs personnes : `Users` |
| Information | `Info` |
| Avertissement/erreur | `AlertCircle` ou `AlertTriangle` |
| Succès/terminé | `CheckCircle` ou `CheckCircle2` |
| Attente | `Clock` |
| Poids/minimum d'expédition | `Weight` |
| Volume déclaré | `Cuboid` (nommé `Cube` dans certains composants web) |
| Colis/article | `Package`, `Package2` ou `Image` pour la photo de l'article |
| Mode maritime | `Ship` ; jauge de conteneur : `Container` |
| Mode aérien/express | `Plane` ; `Zap` peut signaler spécifiquement l'express |
| Mode terrestre | `Truck` |
| Paiement | `CreditCard` |
| Facture/reçu | `Receipt` |
| Historique/document | `FileText` ou `History` selon le composant |

**Règles d'utilisation mobile**

- Taille courante : **20 à 24 px** dans la navigation et les boutons importants, **16 à 20 px** dans les cartes et champs, **12 à 16 px** dans les badges de statut.
- Conserver un trait fin proche du rendu Lucide par défaut ; ne pas mélanger ces icônes avec des pictogrammes pleins sans raison fonctionnelle.
- Une icône décorative hérite généralement de la couleur du texte secondaire. L'ambre `#fdc354` sert à l'état actif ou à une action importante ; rouge pour une suppression/erreur ; vert pour un succès.
- Toute icône seule et cliquable doit avoir une zone tactile d'au moins **44 × 44 px**, même si le dessin visible reste plus petit, ainsi qu'un libellé d'accessibilité.
- Ne jamais utiliser la couleur seule pour exprimer un statut : garder l'icône et le libellé textuel.
- Le bouton **Continuer avec Google** constitue une exception : utiliser le composant/bouton officiel Google avec son logo officiel, et non une approximation Lucide.

### 1.6 Logo

Logo Ahiyoyo disponible publiquement à `https://ahiyoyo.com/ahiyoyo.png`. Utilisé en haut des écrans d'authentification, dans la barre de navigation, et comme app icon.

### 1.7 Ton et langue

- Contenu entièrement en **français**.
- **Vouvoiement** systématique ("Remplissez les informations...", "Vos commandes apparaîtront ici...").
- Ton direct et fonctionnel, phrases courtes. Peu ou pas d'emoji dans l'UI (à l'exception de quelques pictos ponctuels).
- Devises toujours affichées en **FCFA**, formatées avec séparateur de milliers français (`125 000 FCFA`).
- Dates au format français `jj/mm/aaaa`, avec heure `hh:mm` quand elle est pertinente (historiques, notifications).

---

## 2. Parcours client — écran par écran

L'ordre ci-dessous suit le cheminement naturel d'un client, de son premier contact avec l'app jusqu'au retrait de son colis.

### 2.1 Authentification

**Connexion**
Adresse e-mail + mot de passe, ou **connexion avec Google** (bouton dédié). Lien vers l'inscription et vers la récupération de compte.

Le bouton Google de la page de connexion ne sert pas uniquement aux comptes déjà existants : si l'adresse Google n'est encore associée à aucun compte Ahiyoyo, ce parcours peut également créer automatiquement un nouveau compte client. Cette création depuis la page de connexion ne propose pas de code de parrainage. Un client qui souhaite utiliser un code doit donc passer par le formulaire d'inscription classique.

**Inscription**
Deux parcours sont proposés :

- **Inscription avec Google** : le bouton Google est affiché avant le formulaire classique. Ce parcours ne demande pas de cocher une case de consentement dans l'interface et ne prend pas en charge le code de parrainage.
- **Inscription classique** : formulaire avec prénom, nom, email, téléphone, mot de passe, confirmation du mot de passe, code de parrainage optionnel et case d'acceptation des CGU et de la politique de confidentialité. Cette case est cochée par défaut, mais si l'utilisateur la décoche, l'inscription classique est bloquée jusqu'à une nouvelle acceptation.

Le code de parrainage est saisi manuellement dans le formulaire classique, puis vérifié en temps réel. L'application web actuelle ne préremplit pas encore automatiquement ce code depuis un paramètre d'URL ou un lien d'invitation.

**Vérification par code (OTP)**
Écran de saisie d'un code reçu par SMS/email après inscription, avec possibilité de renvoyer le code.

**Récupération de compte**
Formulaire de demande de réinitialisation par **adresse e-mail**, suivi de la saisie du code reçu par e-mail puis d'un nouveau mot de passe. La récupération par numéro de téléphone n'est pas proposée actuellement.

> Après connexion ou inscription, si l'utilisateur avait été interrompu en cours de route (ex. il cliquait sur "M'inscrire" depuis une offre de groupage), il doit être ramené automatiquement à l'offre concernée ou à l'écran d'enregistrement préconfiguré correspondant. L'application mobile doit donc conserver la destination initiale pendant tout le parcours d'authentification.

### 2.1.1 Validation publique d'une facture

Le web possède également un parcours public permettant d'ouvrir une validation de facture depuis un lien contenant un jeton unique, sans passer préalablement par la navigation de l'espace client. Si ce parcours est retenu sur mobile, l'application devra prendre en charge ce lien entrant et ouvrir directement l'écran de validation correspondant. La décision d'intégrer ce parcours à la première version mobile doit être confirmée avec l'équipe produit.

### 2.2 Accueil (Dashboard)

Écran d'atterrissage après connexion. Contient :
- Un bandeau d'information sur les CGU, refermable par le client, avec un lien vers les conditions d'utilisation.
- Des cartes de mise en avant ponctuelles pour des offres de groupage maritime/aérien en cours, avec jauge de remplissage et appel à l'action vers l'offre.
- Un formulaire de recherche permettant de suivre un colis ou une commande à partir de sa référence.
- Des accès rapides vers les actions principales : nouvelle expédition, nouvelle demande de devis, tarifs et adresses.
- Les dernières notifications, avec un lien vers la liste complète.

Les indicateurs statistiques (utilisateurs, expéditions, colis livrés) sont actuellement réservés au dashboard administrateur. Le dashboard client n'affiche pas de KPIs personnels ni d'icônes de copie sur des références.

### 2.3 Navigation générale

Sur le web, la navigation se fait via une barre latérale rétractable, pilotée par le bouton hamburger du header. Elle est organisée dans cet ordre : **Accueil**, **Offres** (groupage maritime, groupage aérien), **Mon activité** (mes devis, mes factures, mes commandes, mes colis, notifications, parrainage), puis **Informations** (tarifs, paramètres).

Pour le mobile, l'équivalent naturel est une **barre de navigation basse** (bottom navigation) pour les 4-5 destinations les plus fréquentes (Accueil, Mes colis, Devis/Commandes, Notifications, Plus/Paramètres), avec le reste accessible depuis un menu "Plus" — c'est une adaptation à discuter, pas une contrainte du web à copier telle quelle.

### 2.4 Suivi de colis et de commandes (public)

Écran accessible même sans connexion. La recherche accepte le numéro de suivi d'un colis ou la référence d'une commande, puis affiche le résultat et son historique correspondant (statuts, dates, commentaires et pièces jointes éventuelles), sans révéler l'identité des administrateurs ayant effectué les mises à jour. C'est aussi la destination utilisée quand une notification concerne un colis : il n'existe pas de fiche détail colis dédiée côté client, le suivi passe par cet écran avec son numéro de tracking.

### 2.5 Expédition d'un colis

Formulaire de création d'un colis à envoyer. Trois façons d'expédier, mutuellement exclusives :

1. **Classique** : le client choisit lui-même son trajet et sa ligne tarifaire (pays/ville de départ et destination, mode de transport — bateau/avion/express/terrestre).
2. **Groupage maritime** : le client arrive sur cet écran depuis une offre de conteneur groupé (voir 2.13) — le trajet, le mode et l'unité (CBM) sont alors **verrouillés** et affichés en lecture seule, avec le tarif provisoire au CBM actuellement applicable.
3. **Groupage aérien** : même principe que le maritime, mais pour une offre de groupage aérien, unité en KG, et le client choisit uniquement entre "avion" et "express".

Dans tous les cas, le formulaire demande ensuite :
- Un ou plusieurs **articles** (description, quantité, photo et/ou lien produit).
- Le **volume/poids déclaré** et son unité.
- Le **propriétaire du colis** : soi-même ou une autre personne (dans ce cas : nom, adresse, téléphone).
- L'acceptation des CGU et de la politique de confidentialité.

Les minimums actuellement appliqués à la quantité déclarée sont :

- transport maritime : **0,5 CBM minimum** ;
- transport aérien ou express : **1 KG minimum**.

Ces contrôles concernent aussi bien le parcours classique que l'enregistrement depuis une offre de groupage correspondant à ces modes. Le mode terrestre reste soumis aux règles qui seront confirmées séparément.

Écran de confirmation à la soumission avec récapitulatif (y compris, pour un groupage, le tarif et le pourcentage de palier tarifaire proposés — jamais calculés côté app, toujours ceux renvoyés par le serveur).

### 2.6 Mes colis

Liste paginée de tous les colis du client, avec recherche, filtre par statut et tri chronologique (plus récent ou plus ancien). Il n'existe pas actuellement de filtre par mode de transport.

Chaque carte affiche le numéro de suivi, le trajet, le statut, le mode de transport, la date, le nombre d'articles, la valeur totale des articles et l'estimation de livraison lorsqu'elle est disponible. Le transporteur et le montant administratif total du colis ne sont pas affichés sur cette liste.

Un clic sur la carte ouvre le suivi public à partir du numéro de tracking. Pour un colis encore en attente de confirmation, le client dispose d'une action de suppression. Une route d'édition limitée existe dans l'application web, mais aucun bouton d'édition n'est actuellement proposé dans la liste « Mes colis ».

### 2.7 Devis — nouvelle demande

Formulaire en **3 étapes** avec barre de progression :

1. **Articles** (jusqu'à 4 par demande) : description, quantité, spécifications, et pour chacun soit un lien produit soit une photo (l'un ou l'autre est obligatoire).
2. **Options** : catégorie de produit (chacune a un montant de caution associé), option de traitement (standard/express, avec frais additionnels éventuels), et si Ahiyoyo doit organiser la livraison finale (avec choix du mode si oui). Un récapitulatif du montant de caution total s'affiche dynamiquement.
3. **Destinataire** : pour soi-même ou pour une autre personne (nom, téléphone, pays, ville, adresse, instructions). Champ optionnel pour un **code promo**, vérifiable avant soumission (affiche la remise obtenue). Notes libres.

À la soumission : écran de succès avec la référence de la demande et **paiement de la caution obligatoire** pour que la demande soit effectivement transmise à l'équipe (voir 2.14 sur le paiement).

### 2.8 Mes devis

Liste paginée avec recherche et filtre par statut (en attente de soumission, soumis, en cours d'analyse, devis préparé, facture envoyée). Chaque carte affiche la référence, la catégorie, le nombre d'articles, le mode de livraison, le montant de caution, et selon l'état : soit un bouton pour payer la caution, soit un badge "caution payée" avec accès direct à la facture.

### 2.9 Détail d'un devis

Reprend toutes les informations saisies à la création (articles avec photo, options choisies, destinataire), affiche le statut de paiement de la caution (bouton de paiement si non payée, sinon date de paiement + lien PDF de la facture liée), et une **frise d'historique** des mises à jour (changements de statut, commentaires de l'équipe, pièces jointes).

### 2.10 Mes factures proforma

Liste des factures émises suite à une demande de devis analysée (les brouillons ne sont jamais montrés au client). Chaque carte affiche le numéro, le statut, l'article, le montant total, un lien PDF et, si la facture a déjà été validée, un raccourci vers la liste « Mes commandes ».

Contrairement aux listes de devis, commandes et colis, cet écran ne propose actuellement ni recherche, ni filtre, ni tri, ni pagination côté interface.

### 2.11 Détail d'une facture proforma

Affiche le montant total à payer, le détail de l'article et du trajet de transport choisi, le **détail complet du calcul du montant** (montant d'achat, coût de transport, frais de service, éventuels autres frais, déduction de la caution déjà payée, remise appliquée si un code promo a été utilisé), et l'historique des statuts.

Le point central de cet écran : si la facture est **en attente de validation**, un bandeau propose au client de l'**accepter** — action qui déclenche la création de la commande associée (avec confirmation avant validation, car cette action est irréversible côté client). Une fois acceptée, un raccourci mène vers la commande.

### 2.12 Mes commandes

Liste paginée des commandes (créées après acceptation d'une facture), avec recherche et filtre par statut logistique. Chaque carte affiche la référence, l'article, le montant, le statut, et si un paiement est requis, un bouton de paiement directement sur la carte.

### 2.13 Détail d'une commande

L'écran le plus riche du parcours post-achat :
- Montant total et lien PDF de la facture.
- **Bloc de paiement**, qui varie selon le montant (voir 2.14) : soit le paiement en ligne classique, soit — au-delà d'un certain montant — un formulaire de **paiement manuel** (choix du canal : virement bancaire ou paiement mobile marchand ; choix du mode d'approvisionnement : dépôt cash, virement, chèque ; upload obligatoire d'une preuve de paiement en photo ou PDF), avec ensuite un état "preuve envoyée, en attente de validation par l'équipe".
- **Frise de suivi logistique en 8 étapes** (de la validation initiale jusqu'à "disponible en entrepôt, prête pour retrait").
- Détails complémentaires : catégorie, délai estimatif, date de confirmation du paiement, trajet.

### 2.14 Paiement

Deux moments distincts déclenchent un paiement dans le parcours (caution de devis, montant de commande). Techniquement, le paiement est géré aujourd'hui par **KkiaPay** (Mobile Money MTN/Moov + carte bancaire, en FCFA) : le montant exact à payer est toujours donné par le serveur au moment d'ouvrir le paiement (jamais recalculé côté app), et **la confirmation du paiement se fait uniquement côté serveur** (webhook) — l'app ne fait qu'ouvrir l'interface de paiement puis, après un court délai (le temps que le serveur traite la confirmation), rafraîchit l'écran pour refléter le nouveau statut. Il n'y a jamais d'écriture directe du statut "payé" depuis l'app elle-même.

Au-delà d'un certain montant (commande uniquement), le paiement en ligne n'est pas proposé : le client doit régler par virement/dépôt et téléverser une preuve, validée manuellement ensuite par l'équipe.

> Note pour le mobile : KkiaPay est aujourd'hui intégré via un widget web React. Le choix technique de l'équivalent mobile (SDK natif s'il existe, ou vue web embarquée vers leur interface de paiement hébergée) reste à trancher avant de construire cet écran — ce sera abordé au moment de builder ce module.

### 2.15 Notifications

Liste paginée des notifications reçues (titre, message, date relative), avec distinction visuelle lu/non lu, action pour tout marquer comme lu, et redirection automatique vers l'écran pertinent au tap (devis, facture, commande, ou suivi de colis selon le type de notification).

### 2.16 Paramètres

Deux onglets :
- **Profil** : informations personnelles modifiables (nom, prénom...).
- **Sécurité** : changement de mot de passe.

Une carte présentant le **code de parrainage personnel** du client (copiable/partageable) est affichée en haut de cet écran.

### 2.17 Parrainage ("Gagner de l'argent")

Deux onglets :
- **Mes filleuls** : liste des personnes inscrites via le code de parrainage du client, avec leur statut (actif/en attente).
- **Mes gains** : historique des gains générés par les filleuls (montant, source — expédition ou commande —, statut du gain), avec un résumé des totaux par statut en haut de l'écran.

Une carte de code de parrainage partageable est également mise en avant ici, avec un argumentaire marketing plus développé que dans les paramètres.

### 2.18 Tarifs & adresses

Écran d'information sans action transactionnelle, accessible actuellement depuis l'espace connecté, listant les lignes tarifaires classiques disponibles et filtrables par mode de transport (aérien/maritime/routier). Malgré la nature publique des informations affichées, la route web `/tarifs` est aujourd'hui protégée par l'authentification.

Chaque carte affiche le trajet, le tarif au kg et/ou au CBM, le minimum d'expédition confirmé pour les modes concernés, le délai estimé, l'adresse et le contact de l'entrepôt de dépôt le cas échéant, des instructions à inscrire sur le colis, et des raccourcis pratiques : copier l'adresse, copier les instructions, partager le tout sur WhatsApp.

### 2.19 Calculateur de fret

Outil autonome : le client saisit une route, un poids, un type de contenu et éventuellement des dimensions, et obtient une estimation de coût d'expédition — un outil d'aide à la décision, indépendant du parcours de commande.

### 2.20 Groupage maritime

**Liste** : offres de conteneurs maritimes actuellement ouvertes, avec titre, trajet, jauge de remplissage (couleur qui évolue du neutre au vert selon le taux de remplissage), dates clés.

**Détail** : mêmes informations en plus complet (conditions, tarif actuel au CBM), avec bouton "Enregistrer mon colis" qui envoie vers l'écran d'expédition de colis (2.5) en mode groupage — ou vers l'inscription si le client n'est pas encore connecté, avec retour automatique sur cette offre une fois inscrit.

Si le tarif actuel au CBM vaut `null`, aucun tarif ne couvre le niveau de remplissage courant. L'application doit afficher **« Aucun tarif disponible pour ce niveau de remplissage »**, désactiver le bouton permettant de profiter de l'offre et ne jamais inventer un tarif ni reprendre silencieusement celui du dernier palier.

### 2.21 Groupage aérien

Strictement analogue au groupage maritime (2.20), mais pour des offres en KG plutôt qu'en CBM, et pour les modes de transport avion/express.

La même règle s'applique si le tarif actuel au KG vaut `null` : afficher **« Aucun tarif disponible pour ce niveau de remplissage »**, désactiver l'action permettant de profiter de l'offre et ne calculer aucun tarif localement.

### 2.22 Groupe WhatsApp

Le web possède une page publique donnant accès au groupe WhatsApp Ahiyoyo. Si cette fonctionnalité est retenue dans l'application mobile, elle doit ouvrir la destination WhatsApp correspondante depuis un écran ou un raccourci clairement identifié. Son inclusion dans la première version mobile reste à confirmer avec l'équipe produit.

---

## 3. Comportements transverses (à respecter sur tous les écrans concernés)

- **Listes principales** : les écrans « Mes devis », « Mes commandes » et « Mes colis » utilisent une recherche avec un léger délai (debounce), un filtre par statut, un tri chronologique et une pagination « précédent/suivant ». La liste « Mes factures » est plus simple et ne possède pas encore ces contrôles. Ne pas considérer cette règle comme uniformément implémentée sur tous les écrans.
- **États d'écran systématiques** : un état de chargement (spinner), un état vide avec message contextuel et illustration/icône, un état d'erreur avec message clair — jamais d'écran blanc silencieux.
- **Formulaires** : privilégier une validation avec des messages précis sous chaque champ lorsque le serveur retourne un chemin d'erreur. Ce comportement est appliqué sur les principaux formulaires récents, mais certaines pages plus anciennes peuvent encore afficher un message global.
- **Historique/frise chronologique** : composant réutilisé sur devis, factures et commandes pour montrer les changements de statut dans le temps, avec éventuellement un commentaire ou une pièce jointe par étape.
- **Confirmation avant action irréversible** : par exemple accepter une facture proforma déclenche une commande — une confirmation explicite est demandée avant d'agir.
- **Upload de fichiers** : la limite généralement utilisée est de 10 Mo et les types acceptés dépendent du contexte (images, PDF ou documents bureautiques pour certaines pièces). Un aperçu est proposé sur certains parcours d'image, mais pas uniformément pour tous les uploads.
