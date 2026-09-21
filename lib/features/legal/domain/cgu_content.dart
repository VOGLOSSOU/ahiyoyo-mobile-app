import 'legal_document.dart';

/// Contenu intégral des CGU Ahiyoyo (version révisée du 31 juillet 2026),
/// transcrit depuis legal-docs/cgu-ahiyoyo-31-juillet-2026.pdf.
final LegalDocument cguDocument = LegalDocument(
  title: 'Conditions Générales d\'Utilisation et de Services',
  subtitle: 'Achats • Paiement de fournisseurs • Expéditions terrestres, maritimes et aériennes • '
      'Achats avec expédition • Voyages d\'affaires',
  versionLabel: 'Version révisée du 31 juillet 2026',
  pdfAssetPath: 'legal-docs/cgu-ahiyoyo-31-juillet-2026.pdf',
  pdfFileName: 'CGU-Ahiyoyo.pdf',
  sections: [
    LegalSection(
      id: 'preambule',
      title: 'Préambule',
      blocks: [
        const LegalBlock.paragraph(
          'Les présentes Conditions Générales d\'Utilisation et de Services, ci-après désignées les « CGU », '
          'définissent les règles applicables à l\'utilisation de la plateforme Ahiyoyo ainsi qu\'aux services '
          'proposés par NEW MARKETS TECHNOLOGIES SAS.',
        ),
        const LegalBlock.paragraph(
          'Elles s\'appliquent au site internet Ahiyoyo, à l\'application mobile, à l\'espace personnel du Client, '
          'aux outils de demande de devis, aux outils d\'enregistrement et de suivi des colis ainsi qu\'aux '
          'services d\'achat, de paiement, d\'expédition, de livraison et d\'organisation de voyages d\'affaires.',
        ),
        const LegalBlock.paragraph(
          'Ahiyoyo permet notamment au Client de rechercher des produits, demander un devis, acheter une '
          'marchandise, payer un fournisseur, faire réceptionner un colis dans un entrepôt, organiser son '
          'transport, suivre son expédition, recevoir des documents et préparer un voyage d\'affaires.',
        ),
        const LegalBlock.paragraph(
          'Le rôle exact d\'Ahiyoyo dépend du service choisi. Selon la commande, Ahiyoyo peut agir comme '
          'vendeur, intermédiaire, mandataire d\'achat, organisateur logistique ou prestataire d\'accompagnement.',
        ),
        const LegalBlock.paragraph(
          'Le Client doit lire les présentes CGU avant de créer un compte, de valider un devis, d\'effectuer un '
          'paiement ou d\'envoyer une marchandise vers un entrepôt communiqué par Ahiyoyo.',
        ),
        const LegalBlock.paragraph(
          'En acceptant les CGU, le Client reconnaît notamment avoir pris connaissance des règles applicables, '
          'avoir compris ses obligations, accepter les conditions de paiement, de transport, de livraison et de '
          'réclamation, et s\'engager à fournir des informations exactes concernant son identité et ses '
          'marchandises.',
        ),
      ],
    ),
    LegalSection(
      id: 'regles-essentielles',
      title: 'Règles essentielles à retenir',
      blocks: [
        const LegalBlock.numbered([
          'Tout colis doit être déclaré sur la Plateforme avant son expédition vers l\'entrepôt.',
          'Chaque carton ou colis doit porter clairement le marquage communiqué par Ahiyoyo, notamment le nom ou le code du Client et sa référence de commande.',
          'Les poids, dimensions et volumes communiqués avant réception sont des estimations. La facturation définitive est établie sur la base des mesures réellement constatées.',
          'Les délais de transport sont estimatifs. Ils peuvent être affectés par la production, les transporteurs, les compagnies maritimes ou aériennes, les autorités, les ports, la douane ou des événements indépendants d\'Ahiyoyo.',
          'Une photographie ou un contrôle visuel ne constitue pas un test technique complet du produit.',
          'L\'assurance transport n\'est pas automatiquement incluse. Elle doit être mentionnée dans le devis ou demandée séparément.',
          'Les marchandises ne sont remises au Client qu\'après paiement de toutes les sommes exigibles.',
          'Les dommages visibles doivent être signalés au moment du retrait ou de la livraison. Les dommages non visibles doivent être signalés dès leur découverte, de préférence dans les quarante-huit heures.',
          'Les marchandises interdites, dangereuses ou réglementées doivent être déclarées avant toute commande ou expédition.',
          'Le Client doit effectuer ses paiements uniquement sur les coordonnées officielles indiquées sur la Plateforme, le devis ou la facture.',
        ]),
      ],
    ),
    LegalSection(
      id: 'section-1',
      title: 'I. Accès à la Plateforme et formation du contrat',
      blocks: [
        const LegalBlock.heading('Article 1 – Identification de l\'opérateur'),
        const LegalBlock.paragraph(
          'La Plateforme Ahiyoyo est exploitée par NEW MARKETS TECHNOLOGIES SAS, société par actions '
          'simplifiée de droit béninois exerçant sous l\'enseigne Ahiyoyo.',
        ),
        const LegalBlock.paragraph(
          'Le Client peut contacter le service client par téléphone au +229 01 91 08 41 41, par courrier '
          'électronique à support@ahiyoyo.com ou par les canaux officiels affichés sur la Plateforme.',
        ),
        const LegalBlock.paragraph(
          'Le Client doit vérifier les coordonnées de paiement avant toute opération. Ahiyoyo ne reconnaît pas '
          'les paiements effectués sur un compte personnel ou sur un compte qui n\'a pas été officiellement '
          'communiqué, sauf confirmation écrite d\'un représentant habilité.',
        ),
        const LegalBlock.heading('Article 2 – Objet et champ d\'application'),
        const LegalBlock.paragraph('Les présentes CGU déterminent les droits et obligations d\'Ahiyoyo et du Client concernant :'),
        const LegalBlock.bullets([
          'l\'utilisation de la Plateforme ;',
          'les demandes de devis ;',
          'la recherche et l\'achat de produits ;',
          'le paiement de fournisseurs ;',
          'la réception et l\'entreposage de colis ;',
          'le transport terrestre, maritime ou aérien ;',
          'le groupage de marchandises ;',
          'les formalités douanières ;',
          'la livraison ;',
          'l\'accompagnement à des voyages d\'affaires.',
        ]),
        const LegalBlock.paragraph('Les CGU s\'appliquent à toute commande validée par le Client.'),
        const LegalBlock.paragraph(
          'Une commande peut également être encadrée par un devis, une facture, un bon de commande, un '
          'contrat particulier, un échéancier ou des conditions spécifiques.',
        ),
        const LegalBlock.paragraph(
          'Lorsqu\'une condition particulière acceptée par le Client contredit une disposition générale des '
          'présentes CGU, la condition particulière s\'applique uniquement à la commande concernée.',
        ),
        const LegalBlock.heading('Article 3 – Définitions'),
        const LegalBlock.paragraph(
          'Plateforme : le site internet, l\'application mobile, l\'espace client et les outils numériques exploités '
          'sous la marque Ahiyoyo.',
        ),
        const LegalBlock.paragraph(
          'Client : toute personne physique ou morale qui crée un compte, demande un devis, effectue un '
          'paiement, confie une marchandise ou commande un service.',
        ),
        const LegalBlock.paragraph('Commande : toute opération validée par le Client et acceptée par Ahiyoyo.'),
        const LegalBlock.paragraph(
          'Marchandise : tout produit, colis, équipement, document ou bien faisant l\'objet d\'un achat, d\'un '
          'stockage ou d\'une expédition.',
        ),
        const LegalBlock.paragraph(
          'Groupage : une expédition dans laquelle les marchandises de plusieurs clients sont regroupées dans '
          'un même conteneur, véhicule, palette, avion ou autre moyen de transport.',
        ),
        const LegalBlock.paragraph(
          'Service non groupé : notamment un conteneur complet, une palette complète, un véhicule dédié ou '
          'toute expédition réservée exclusivement à un Client.',
        ),
        const LegalBlock.paragraph(
          'Fournisseur : le vendeur, le fabricant ou le prestataire auprès duquel les produits ou services sont '
          'commandés.',
        ),
        const LegalBlock.paragraph(
          'Débours : une somme payée par Ahiyoyo au nom et pour le compte du Client, lorsque les conditions '
          'juridiques, comptables et fiscales permettent de la traiter comme telle.',
        ),
        const LegalBlock.heading('Article 4 – Acceptation des CGU'),
        const LegalBlock.paragraph('Les CGU sont considérées comme acceptées lorsque le Client réalise au moins l\'une des actions suivantes :'),
        const LegalBlock.bullets([
          'création ou activation d\'un compte ;',
          'validation d\'un devis ;',
          'validation d\'une commande ;',
          'paiement total ou partiel d\'une commande ;',
          'envoi d\'une marchandise vers un entrepôt communiqué par Ahiyoyo ;',
          'utilisation effective d\'un service Ahiyoyo.',
        ]),
        const LegalBlock.paragraph('La version applicable est celle qui était disponible à la date de validation de la commande.'),
        const LegalBlock.paragraph(
          'Ahiyoyo peut conserver la date, l\'heure, l\'adresse de connexion, la version des CGU et toute autre '
          'information permettant de prouver l\'acceptation du Client.',
        ),
        const LegalBlock.heading('Article 5 – Création et sécurité du compte'),
        const LegalBlock.paragraph(
          'Le Client doit fournir des informations exactes, complètes et à jour. Il doit notamment communiquer, '
          'lorsque cela est demandé :',
        ),
        const LegalBlock.bullets([
          'ses nom et prénoms ;',
          'son numéro de téléphone ;',
          'son adresse électronique ;',
          'son adresse de livraison ;',
          'les informations relatives à son entreprise lorsqu\'il agit en qualité de professionnel ;',
          'son IFU, son RCCM et les coordonnées de son représentant lorsque ces informations sont nécessaires.',
        ]),
        const LegalBlock.paragraph(
          'Le Client est responsable de la confidentialité de son mot de passe, de ses codes de connexion et de '
          'toute action effectuée depuis son compte.',
        ),
        const LegalBlock.paragraph(
          'En cas de perte, de piratage ou d\'utilisation non autorisée du compte, le Client doit immédiatement '
          'en informer Ahiyoyo.',
        ),
        const LegalBlock.paragraph(
          'Ahiyoyo peut demander une pièce d\'identité, un justificatif d\'entreprise, une procuration, une preuve '
          'de paiement ou tout autre document nécessaire pour vérifier l\'identité du Client, prévenir la fraude, '
          'effectuer la facturation, accomplir les formalités douanières ou respecter une obligation légale.',
        ),
        const LegalBlock.heading('Article 6 – Fonctionnement et disponibilité de la Plateforme'),
        const LegalBlock.paragraph('La Plateforme permet notamment au Client de :'),
        const LegalBlock.bullets([
          'demander un devis ;',
          'enregistrer un colis attendu ;',
          'transmettre des photographies et des documents ;',
          'déclarer ou effectuer un paiement ;',
          'consulter ses factures ;',
          'suivre ses commandes ;',
          'recevoir des notifications ;',
          'signaler une réclamation.',
        ]),
        const LegalBlock.paragraph(
          'Les informations de suivi affichées sur la Plateforme sont fournies à titre opérationnel. Un retard de '
          'mise à jour du statut ne signifie pas nécessairement que la marchandise n\'a pas été reçue, chargée, '
          'transportée ou livrée.',
        ),
        const LegalBlock.paragraph(
          'Ahiyoyo peut temporairement interrompre tout ou partie de la Plateforme pour effectuer une '
          'maintenance, corriger un incident technique, renforcer la sécurité ou respecter une obligation '
          'réglementaire.',
        ),
        const LegalBlock.paragraph(
          'Une interruption de la Plateforme n\'annule pas les commandes déjà validées ni les sommes déjà '
          'exigibles.',
        ),
      ],
    ),
    LegalSection(
      id: 'section-2',
      title: 'II. Services, devis et commandes',
      blocks: [
        const LegalBlock.heading('Article 7 – Services proposés'),
        const LegalBlock.paragraph('Selon le devis ou la commande, Ahiyoyo peut fournir un ou plusieurs des services suivants :'),
        const LegalBlock.bullets([
          'recherche de produits ou de fournisseurs ;',
          'demande de prix et négociation commerciale ;',
          'vérification de l\'existence d\'un fournisseur ;',
          'mise en relation avec un fournisseur ;',
          'paiement d\'un fournisseur pour le compte du Client ;',
          'achat direct de marchandises ;',
          'suivi de la fabrication ou de la préparation ;',
          'réception des marchandises en entrepôt ;',
          'prise de photographies ou de vidéos ;',
          'contrôle de quantité ;',
          'consolidation de plusieurs colis ;',
          'emballage ou renforcement de l\'emballage ;',
          'stockage temporaire ;',
          'transport terrestre, maritime ou aérien ;',
          'formalités douanières et dédouanement ;',
          'livraison au lieu convenu ;',
          'organisation et accompagnement de voyages d\'affaires.',
        ]),
        const LegalBlock.paragraph(
          'Seuls les services expressément mentionnés dans le devis, la facture ou la commande sont inclus. '
          'Par exemple, si le devis prévoit uniquement le paiement du fournisseur, Ahiyoyo n\'est pas tenue '
          'd\'inspecter, de transporter ou de livrer les produits, sauf ajout écrit de ces prestations.',
        ),
        const LegalBlock.heading('Article 8 – Demande de devis'),
        const LegalBlock.paragraph(
          'Le Client doit décrire son besoin avec suffisamment de précision. Il doit notamment indiquer, lorsque '
          'cela est applicable :',
        ),
        const LegalBlock.bullets([
          'le nom du produit ;',
          'la quantité ;',
          'la matière ;',
          'les dimensions ;',
          'la couleur ;',
          'le modèle ou la référence ;',
          'l\'utilisation prévue ;',
          'le pays et la ville de destination ;',
          'le délai souhaité ;',
          'les photographies ou liens du produit ;',
          'toute exigence technique ou réglementaire particulière.',
        ]),
        const LegalBlock.paragraph('Le devis est établi sur la base des informations disponibles au moment de sa préparation.'),
        const LegalBlock.paragraph(
          'Les montants peuvent être modifiés en cas de variation du prix du fournisseur ou du taux de change, '
          'de modification de la quantité, de poids ou volume réel supérieur à l\'estimation, de changement de '
          'transporteur, de frais imposés par une autorité, d\'autorisation ou inspection particulière, ou de '
          'changement demandé par le Client.',
        ),
        const LegalBlock.paragraph(
          'Les frais de devis, de recherche, d\'inspection, d\'étude ou de déplacement restent dus lorsque le '
          'travail correspondant a déjà commencé, même si le Client décide ensuite de ne pas poursuivre la '
          'commande.',
        ),
        const LegalBlock.heading('Article 9 – Validation de la commande'),
        const LegalBlock.paragraph('Une commande devient ferme lorsque les trois conditions suivantes sont réunies :'),
        const LegalBlock.numbered([
          'le Client accepte le devis ou l\'offre ;',
          'le Client effectue le paiement demandé ;',
          'Ahiyoyo confirme la prise en charge de la commande.',
        ]),
        const LegalBlock.paragraph(
          'Une capture d\'écran de paiement ne constitue pas une preuve définitive d\'encaissement. Le paiement '
          'doit avoir été effectivement reçu, identifié et rapproché de la commande.',
        ),
        const LegalBlock.paragraph(
          'Avant de valider sa commande, le Client doit vérifier les produits, les quantités, les caractéristiques, '
          'les prix, le mode de transport, le lieu de livraison, les délais estimatifs, les services inclus, les '
          'services exclus et les modalités de paiement.',
        ),
        const LegalBlock.paragraph(
          'Toute modification demandée après validation peut entraîner une modification du prix, un nouveau '
          'délai, des frais supplémentaires ou l\'impossibilité d\'annuler une opération déjà engagée.',
        ),
        const LegalBlock.paragraph(
          'Ahiyoyo peut refuser ou suspendre une commande lorsque la marchandise est interdite, dangereuse, '
          'suspecte, insuffisamment décrite, difficilement transportable ou non conforme aux règles applicables.',
        ),
        const LegalBlock.heading('Article 10 – Prix, poids, volume et taux de change'),
        const LegalBlock.paragraph(
          'Les prix applicables sont ceux indiqués sur la Plateforme, le devis, la facture ou le contrat particulier. '
          'Ils peuvent être calculés au kilogramme, au mètre cube ou CBM, au carton, à l\'unité, au forfait, selon '
          'le poids volumétrique ou selon toute autre base clairement indiquée.',
        ),
        const LegalBlock.paragraph('Les poids, dimensions et volumes communiqués avant la réception en entrepôt sont estimatifs.'),
        const LegalBlock.paragraph(
          'La facturation définitive est établie sur la base des mesures constatées ou confirmées par '
          'l\'entrepôt, le transporteur, le port, l\'aéroport, le transitaire ou un autre prestataire chargé de '
          'l\'opération.',
        ),
        const LegalBlock.paragraph(
          'Lorsque le prix est calculé au CBM, le volume facturable peut être arrondi selon les règles tarifaires '
          'affichées ou mentionnées dans le devis. Le minimum facturable applicable est celui indiqué dans le '
          'tarif ou le devis.',
        ),
        const LegalBlock.paragraph(
          'Lorsqu\'un montant dépend d\'une devise étrangère, le taux utilisé est celui intégré au devis pendant '
          'sa période de validité. Lorsque le devis a expiré ou que le paiement n\'a pas encore été '
          'effectivement encaissé, Ahiyoyo peut mettre à jour le montant pour tenir compte du nouveau taux.',
        ),
      ],
    ),
    LegalSection(
      id: 'section-3',
      title: 'III. Paiement, facturation et recouvrement',
      blocks: [
        const LegalBlock.heading('Article 11 – Moyens de paiement'),
        const LegalBlock.paragraph(
          'Le Client doit effectuer ses paiements uniquement sur les comptes bancaires officiels, les numéros '
          'marchands officiels, les liens de paiement officiels ou les moyens indiqués sur la Plateforme, le '
          'devis ou la facture.',
        ),
        const LegalBlock.paragraph(
          'Un paiement envoyé à un employé, un particulier, un intermédiaire ou un compte non autorisé ne '
          'libère pas le Client de sa dette envers Ahiyoyo, sauf confirmation écrite d\'un représentant habilité.',
        ),
        const LegalBlock.paragraph(
          'Chaque paiement doit contenir une référence permettant d\'identifier le Client, la commande et la '
          'facture concernée.',
        ),
        const LegalBlock.paragraph(
          'Les frais bancaires, frais de transfert, frais de retrait, commissions de paiement et pertes de change '
          'sont supportés selon les conditions indiquées dans le devis ou par le moyen de paiement utilisé.',
        ),
        const LegalBlock.heading('Article 12 – Paiement par tranches et échéances'),
        const LegalBlock.paragraph(
          'Ahiyoyo peut demander un paiement intégral avant le début du service, un acompte suivi d\'un solde, '
          'un paiement en plusieurs tranches ou un paiement à différentes étapes de la commande.',
        ),
        const LegalBlock.paragraph('L\'échéancier applicable est celui affiché sur la Plateforme, indiqué sur la facture ou accepté par écrit.'),
        const LegalBlock.paragraph(
          'Sauf condition particulière, une expédition en groupage peut être subordonnée au paiement d\'au '
          'moins 50 % du fret estimé avant le chargement.',
        ),
        const LegalBlock.paragraph(
          'Le solde doit être payé dans les quarante-huit heures suivant la notification d\'arrivée ou l\'appel de '
          'fonds et, dans tous les cas, avant la remise de la marchandise.',
        ),
        const LegalBlock.paragraph(
          'Un paiement partiel ne vaut pas paiement complet et ne donne pas automatiquement droit au retrait '
          'de la marchandise.',
        ),
        const LegalBlock.paragraph(
          'Lorsqu\'une échéance n\'est pas respectée, Ahiyoyo peut suspendre le paiement du fournisseur, la '
          'production, le chargement, l\'expédition, le dédouanement, la livraison ou tout autre service en cours.',
        ),
        const LegalBlock.paragraph('Le non-paiement d\'une échéance peut rendre immédiatement exigible la totalité du solde restant.'),
        const LegalBlock.heading('Article 13 – Facturation et fiscalité'),
        const LegalBlock.paragraph(
          'Le devis, la facture proforma et l\'appel de fonds présentent le montant estimé ou demandent un '
          'paiement. Ils ne remplacent pas la facture normalisée exigée par la réglementation fiscale.',
        ),
        const LegalBlock.paragraph(
          'Ahiyoyo émet les factures normalisées relatives à ses ventes et prestations conformément aux règles '
          'fiscales applicables.',
        ),
        const LegalBlock.paragraph(
          'Le Client professionnel doit transmettre avant facturation sa raison sociale exacte, son IFU, son '
          'adresse et son RCCM lorsque cela est applicable.',
        ),
        const LegalBlock.paragraph(
          'Une erreur provenant des informations communiquées par le Client doit être corrigée selon la '
          'procédure fiscale applicable. Elle ne permet pas de supprimer ou de modifier librement une facture '
          'déjà normalisée.',
        ),
        const LegalBlock.paragraph('Ahiyoyo refuse toute demande visant à :'),
        const LegalBlock.bullets([
          'diminuer artificiellement la valeur d\'une marchandise ;',
          'utiliser une fausse désignation ;',
          'établir une facture fictive ;',
          'dissimuler la nature réelle d\'un produit ;',
          'éviter illégalement une taxe ou un droit de douane.',
        ]),
        const LegalBlock.paragraph(
          'Le Client reste responsable de sa propre fiscalité, de ses activités de revente et des déclarations '
          'fiscales qui lui incombent.',
        ),
        const LegalBlock.heading('Article 14 – Retard de paiement et recouvrement'),
        const LegalBlock.paragraph(
          'En cas de retard, Ahiyoyo peut adresser des relances par notification sur la Plateforme, courrier '
          'électronique, téléphone, SMS, WhatsApp ou courrier formel.',
        ),
        const LegalBlock.paragraph(
          'Les relances ne suspendent pas les frais de stockage, de manutention ou de conservation des '
          'marchandises.',
        ),
        const LegalBlock.paragraph(
          'Ahiyoyo peut retenir les marchandises ou documents qu\'elle détient pour le compte du Client jusqu\'au '
          'paiement complet des sommes exigibles liées à la commande. Cette rétention ne signifie pas '
          'qu\'Ahiyoyo devient propriétaire des marchandises.',
        ),
        const LegalBlock.paragraph(
          'Après une mise en demeure restée sans effet, Ahiyoyo peut engager une procédure amiable, '
          'judiciaire ou conforme aux règles OHADA.',
        ),
        const LegalBlock.paragraph(
          'Les intérêts de retard, frais d\'huissier, frais judiciaires et autres dépenses de recouvrement '
          'légalement récupérables peuvent être mis à la charge du Client.',
        ),
      ],
    ),
    LegalSection(
      id: 'section-4',
      title: 'IV. Achats et achats avec expédition',
      blocks: [
        const LegalBlock.heading('Article 15 – Service d\'achat'),
        const LegalBlock.paragraph(
          'Le service d\'achat peut comprendre la recherche d\'un fournisseur, la comparaison de plusieurs '
          'offres, la négociation, le paiement du fournisseur, le suivi de la production et la réception des '
          'produits en entrepôt. Le devis précise le rôle d\'Ahiyoyo.',
        ),
        const LegalBlock.paragraph(
          'Lorsque le Client choisit lui-même un fournisseur ou transmet un lien précis, Ahiyoyo exécute la '
          'commande sur la base des informations fournies par le Client.',
        ),
        const LegalBlock.paragraph(
          'Dans ce cas, Ahiyoyo ne garantit pas l\'exactitude de toutes les déclarations du fournisseur, les '
          'performances futures ou la durabilité du produit, l\'adaptation à un usage non communiqué ou '
          'l\'obtention d\'une autorisation particulière dans le pays de destination.',
        ),
        const LegalBlock.paragraph(
          'Les frais de service, le prix du produit, le paiement, l\'inspection, le transport local et le fret '
          'international peuvent apparaître séparément sur le devis.',
        ),
        const LegalBlock.heading('Article 16 – Service intégré d\'achat et d\'expédition'),
        const LegalBlock.paragraph(
          'Dans le cadre d\'un service intégré, Ahiyoyo peut prendre en charge l\'achat puis l\'expédition de la '
          'marchandise jusqu\'au lieu convenu.',
        ),
        const LegalBlock.paragraph(
          'Même lorsqu\'il s\'agit d\'une seule commande, les différentes étapes restent distinctes : recherche du '
          'produit, achat, production, réception, contrôle, transport, dédouanement et livraison.',
        ),
        const LegalBlock.paragraph(
          'Le paiement du prix d\'achat ne signifie pas que le transport, la douane, l\'assurance ou la livraison '
          'ont également été payés, sauf si ces prestations sont expressément incluses.',
        ),
        const LegalBlock.paragraph(
          'Ahiyoyo peut suspendre l\'expédition lorsque le Client n\'a pas payé le fret, n\'a pas transmis les '
          'documents nécessaires, n\'a pas validé une différence de prix, refuse de payer une différence de '
          'poids ou de volume constatée, ou n\'a pas répondu à une demande importante concernant la '
          'commande.',
        ),
        const LegalBlock.heading('Article 17 – Contrôle des marchandises'),
        const LegalBlock.paragraph(
          'Une inspection, une photographie, une vidéo, un comptage ou un contrôle n\'est réalisé que s\'il est '
          'inclus dans la commande ou demandé séparément.',
        ),
        const LegalBlock.paragraph('Un contrôle visuel permet principalement de vérifier les éléments visibles, tels que :'),
        const LegalBlock.bullets([
          'l\'apparence générale ;',
          'la couleur ;',
          'la quantité apparente ;',
          'la présence de dommages visibles ;',
          'le modèle ou la référence affichée.',
        ]),
        const LegalBlock.paragraph(
          'Un contrôle visuel ne constitue pas un test technique complet, un test de performance, une '
          'certification, une analyse de laboratoire ou une garantie contre un défaut caché.',
        ),
        const LegalBlock.paragraph(
          'Lorsqu\'une erreur est imputable au fournisseur, Ahiyoyo peut aider le Client à présenter une '
          'réclamation si cette assistance est comprise dans le service.',
        ),
        const LegalBlock.paragraph(
          'Le remboursement, la réparation ou le remplacement dépend notamment des conditions du '
          'fournisseur, des preuves disponibles, du délai de réclamation, de l\'état de la marchandise et de la '
          'possibilité de retourner le produit.',
        ),
      ],
    ),
    LegalSection(
      id: 'section-5',
      title: 'V. Réception, expédition et groupage',
      blocks: [
        const LegalBlock.heading('Article 18 – Pré-enregistrement et identification des colis'),
        const LegalBlock.paragraph(
          'Avant que le fournisseur n\'expédie une marchandise vers un entrepôt Ahiyoyo, le Client doit '
          'enregistrer l\'expédition sur la Plateforme et indiquer notamment le nom du fournisseur, la description '
          'des produits, les quantités, la valeur, le mode de transport souhaité et le numéro de suivi.',
        ),
        const LegalBlock.paragraph('Chaque colis doit porter clairement :'),
        const LegalBlock.bullets([
          'le marquage Ahiyoyo communiqué ;',
          'le nom ou le code du Client ;',
          'le numéro de commande ;',
          'toute autre référence demandée.',
        ]),
        const LegalBlock.paragraph('Le Client est responsable de la transmission de ces instructions à son fournisseur.'),
        const LegalBlock.paragraph(
          'Un colis non déclaré ou mal identifié peut être traité avec retard, être attribué au mauvais Client, être '
          'refusé, être retourné ou entraîner des frais de recherche et de traitement manuel.',
        ),
        const LegalBlock.paragraph(
          'Ahiyoyo ne peut pas être tenue responsable d\'une mauvaise affectation provoquée par l\'absence ou '
          'l\'inexactitude du marquage avant que le véritable propriétaire du colis puisse être identifié.',
        ),
        const LegalBlock.heading('Article 19 – Réception, emballage et mesure'),
        const LegalBlock.paragraph('La réception en entrepôt signifie uniquement que le colis est physiquement arrivé.'),
        const LegalBlock.paragraph(
          'Elle ne confirme pas automatiquement le contenu exact, la quantité exacte, la qualité, le '
          'fonctionnement, l\'authenticité ou la conformité du produit. Ces éléments ne sont vérifiés que lorsqu\'un '
          'contrôle spécifique a été commandé.',
        ),
        const LegalBlock.paragraph('Le fournisseur reste responsable de l\'emballage initial.'),
        const LegalBlock.paragraph(
          'Lorsque l\'emballage est jugé insuffisant pour le transport, Ahiyoyo peut proposer ou imposer un '
          'emballage renforcé, un reconditionnement, une caisse en bois, une palette ou une protection '
          'supplémentaire. Ces prestations sont facturées au Client lorsqu\'elles ne sont pas incluses dans le '
          'devis.',
        ),
        const LegalBlock.paragraph(
          'Après réception, Ahiyoyo ou ses partenaires confirment le nombre de colis, le poids et le volume. Ces '
          'mesures servent de base à la facturation définitive du transport.',
        ),
        const LegalBlock.heading('Article 20 – Transport et délais'),
        const LegalBlock.paragraph('Le mode de transport est celui accepté dans la commande : terrestre, maritime ou aérien.'),
        const LegalBlock.paragraph(
          'Ahiyoyo peut travailler avec des transporteurs, compagnies maritimes, compagnies aériennes, '
          'transitaires, entrepôts, agents et autres prestataires indépendants.',
        ),
        const LegalBlock.paragraph('Les délais annoncés sont des estimations et non des dates garanties, sauf engagement écrit spécifique.'),
        const LegalBlock.paragraph('Ils peuvent être prolongés notamment par :'),
        const LegalBlock.bullets([
          'un retard de production ou du fournisseur ;',
          'une attente de consolidation ;',
          'une modification de la commande ;',
          'l\'indisponibilité d\'un navire ou d\'un avion ;',
          'des conditions météorologiques ;',
          'des contrôles douaniers ;',
          'une congestion portuaire ;',
          'une fermeture de frontière ;',
          'une décision d\'une autorité ;',
          'une grève ;',
          'un événement de force majeure.',
        ]),
        const LegalBlock.paragraph(
          'Un retard ne donne droit à une indemnisation que lorsqu\'une faute directe et prouvée d\'Ahiyoyo est '
          'établie, dans les limites de la loi et des conditions applicables au transport.',
        ),
        const LegalBlock.heading('Article 21 – Douane, droits et taxes'),
        const LegalBlock.paragraph(
          'Pour les expéditions en groupage, le tarif facturé au CBM, au kilogramme, au carton ou au forfait '
          'comprend les frais ordinaires de douane, de transit et de dédouanement du flux consolidé, sauf '
          'mention contraire dans le devis.',
        ),
        const LegalBlock.paragraph(
          'Ne sont pas considérés comme des frais ordinaires et peuvent être facturés séparément les licences, '
          'autorisations spéciales, certificats, analyses de laboratoire, inspections particulières, taxes propres à '
          'certains produits, amendes, magasinage, surestaries, saisie, destruction, redressement douanier et '
          'frais causés par une description ou une valeur inexacte ou par une marchandise réglementée non '
          'déclarée.',
        ),
        const LegalBlock.paragraph(
          'Pour un conteneur complet, une palette complète ou un service dédié, les conditions douanières sont '
          'définies dans le devis.',
        ),
        const LegalBlock.paragraph(
          'Le Client ne peut prendre directement en charge les formalités douanières que si un accord écrit '
          'distinct a été conclu avec Ahiyoyo.',
        ),
        const LegalBlock.heading('Article 22 – Propriété des marchandises en groupage'),
        const LegalBlock.paragraph(
          'Le groupage est uniquement une méthode d\'organisation du transport. Il ne rend pas Ahiyoyo '
          'propriétaire des marchandises du Client et ne crée aucune copropriété entre les différents clients.',
        ),
        const LegalBlock.paragraph(
          'Chaque Client reste propriétaire des marchandises qui lui appartiennent, sous réserve des conditions '
          'du contrat de vente et du paiement intégral lorsque les produits sont directement vendus par Ahiyoyo.',
        ),
        const LegalBlock.paragraph(
          'Les marchandises sont identifiées au moyen du compte du Client, du numéro de commande, du '
          'marquage, des factures, du packing list et des registres d\'entrepôt.',
        ),
        const LegalBlock.paragraph(
          'Un connaissement, une déclaration douanière ou un document de transport établi au nom d\'Ahiyoyo '
          'ou de son agent ne transfère pas automatiquement la propriété des marchandises à Ahiyoyo.',
        ),
        const LegalBlock.heading('Article 23 – Conteneur complet et service dédié'),
        const LegalBlock.paragraph(
          'Pour un service non groupé, le Client doit fournir dans les délais demandés la facture commerciale, le '
          'packing list, les codes douaniers, les autorisations, les informations relatives aux marchandises et '
          'tout document demandé par le transporteur ou les autorités.',
        ),
        const LegalBlock.paragraph(
          'Les coûts supplémentaires résultant notamment d\'une surcharge, d\'un volume supérieur, d\'un retard '
          'documentaire, d\'une immobilisation ou d\'une modification demandée par le Client lui sont refacturés.',
        ),
        const LegalBlock.heading('Article 24 – Risques et assurance'),
        const LegalBlock.paragraph(
          'Les marchandises voyagent selon les risques définis par la loi applicable, le contrat de vente, le '
          'document de transport, les conditions du transporteur et l\'assurance éventuellement souscrite.',
        ),
        const LegalBlock.paragraph(
          'La simple détention matérielle d\'une marchandise par Ahiyoyo ne signifie pas qu\'Ahiyoyo assume '
          'tous les risques sans limite.',
        ),
        const LegalBlock.paragraph(
          'L\'assurance transport n\'est incluse que lorsqu\'elle est expressément mentionnée dans le devis ou la '
          'commande.',
        ),
        const LegalBlock.paragraph(
          'En l\'absence d\'assurance, une indemnisation éventuelle peut être limitée par les règles applicables '
          'au transporteur.',
        ),
        const LegalBlock.paragraph(
          'Le Client doit déclarer la nature et la valeur réelles de ses marchandises. Une déclaration inexacte '
          'peut entraîner un refus de couverture ou une réduction de l\'indemnisation.',
        ),
      ],
    ),
    LegalSection(
      id: 'section-6',
      title: 'VI. Livraison, stockage, annulation et réclamations',
      blocks: [
        const LegalBlock.heading('Article 25 – Notification d\'arrivée et remise'),
        const LegalBlock.paragraph(
          'Lorsque les marchandises sont disponibles, Ahiyoyo informe le Client par la Plateforme ou par un '
          'canal officiel.',
        ),
        const LegalBlock.paragraph(
          'Avant le retrait ou la livraison, le Client doit régler le solde exigible, transmettre les documents '
          'demandés, confirmer l\'identité du bénéficiaire et respecter les instructions de retrait.',
        ),
        const LegalBlock.paragraph(
          'La marchandise peut être remise au Client ou à une personne autorisée sur présentation d\'une pièce '
          'd\'identité, d\'un code ou d\'une procuration.',
        ),
        const LegalBlock.paragraph(
          'Aucune marchandise n\'est remise tant que les sommes exigibles ne sont pas intégralement réglées, '
          'sauf accord écrit contraire.',
        ),
        const LegalBlock.heading('Article 26 – Stockage et marchandises non réclamées'),
        const LegalBlock.paragraph(
          'Un délai de retrait gratuit peut être prévu dans le tarif ou la notification d\'arrivée. Après ce délai, '
          'des frais de stockage, de garde ou de manutention peuvent être facturés.',
        ),
        const LegalBlock.paragraph(
          'Lorsque le Client ne retire pas ses marchandises ou reste injoignable, Ahiyoyo peut les déplacer, les '
          'retourner ou prendre toute mesure raisonnable pour limiter les coûts et les risques.',
        ),
        const LegalBlock.paragraph(
          'Après une mise en demeure restée sans effet et dans le respect de la procédure légale, les '
          'marchandises peuvent être considérées comme abandonnées et faire l\'objet d\'une vente, d\'une '
          'destruction ou d\'une remise à l\'autorité compétente.',
        ),
        const LegalBlock.paragraph('Le produit net éventuel d\'une vente est d\'abord utilisé pour régler les sommes dues par le Client.'),
        const LegalBlock.heading('Article 27 – Annulation, retour et remboursement'),
        const LegalBlock.paragraph('Toute demande d\'annulation doit être adressée par écrit ou depuis la Plateforme.'),
        const LegalBlock.paragraph('Le montant remboursable dépend de l\'état d\'avancement de la commande.'),
        const LegalBlock.paragraph(
          'Avant le paiement du fournisseur ou le début du service, les sommes non engagées peuvent être '
          'remboursées après déduction des frais déjà supportés.',
        ),
        const LegalBlock.paragraph(
          'Après le paiement du fournisseur, le début de la production, la réception ou le chargement, '
          'l\'annulation dépend de l\'accord du fournisseur et du transporteur.',
        ),
        const LegalBlock.paragraph('Peuvent notamment être déduits du remboursement :'),
        const LegalBlock.bullets([
          'les frais de recherche ;',
          'les frais de service déjà exécuté ;',
          'les commissions de paiement ;',
          'les pertes de change ;',
          'les frais de retour ;',
          'les pénalités du fournisseur ;',
          'les frais de transport ;',
          'les frais de stockage.',
        ]),
        const LegalBlock.paragraph('Tout remboursement est effectué au payeur initial ou sur un compte préalablement vérifié.'),
        const LegalBlock.heading('Article 28 – Réclamations, pertes et avaries'),
        const LegalBlock.paragraph('Le Client doit vérifier le nombre de colis et leur état apparent au moment du retrait ou de la livraison.'),
        const LegalBlock.paragraph(
          'Toute perte ou avarie visible doit être signalée avant la signature du reçu et faire l\'objet de réserves '
          'précises.',
        ),
        const LegalBlock.paragraph(
          'Une formule générale telle que « sous réserve de vérification » peut être insuffisante. Le Client doit '
          'décrire clairement l\'anomalie constatée.',
        ),
        const LegalBlock.paragraph(
          'Une anomalie non visible doit être signalée dès sa découverte et, afin de faciliter l\'enquête, au plus '
          'tard dans les quarante-huit heures suivant la remise, sans préjudice d\'un délai légal impératif plus '
          'long.',
        ),
        const LegalBlock.paragraph('La réclamation doit comprendre :'),
        const LegalBlock.bullets([
          'le numéro de commande ;',
          'les factures ;',
          'la preuve de la valeur ;',
          'les photographies du colis ;',
          'les photographies de l\'emballage ;',
          'les photographies du produit ;',
          'une description précise du dommage.',
        ]),
        const LegalBlock.paragraph('Le Client doit conserver l\'emballage jusqu\'à la fin de l\'enquête.'),
        const LegalBlock.paragraph(
          'Une indemnisation éventuelle porte uniquement sur le dommage direct, prouvé et imputable à la '
          'partie responsable, dans les limites de la loi, de l\'assurance et des conditions du transporteur.',
        ),
        const LegalBlock.paragraph(
          'Les pertes de bénéfices, ventes manquées et autres dommages indirects ne sont pas indemnisés, '
          'sauf disposition légale contraire.',
        ),
      ],
    ),
    LegalSection(
      id: 'section-7',
      title: 'VII. Conformité et voyages d\'affaires',
      blocks: [
        const LegalBlock.heading('Article 29 – Marchandises interdites ou réglementées'),
        const LegalBlock.paragraph(
          'Le Client ne doit pas utiliser Ahiyoyo pour acheter ou expédier une marchandise interdite dans le '
          'pays d\'origine, de transit ou de destination.',
        ),
        const LegalBlock.paragraph('Les marchandises réglementées doivent être déclarées avant la commande.'),
        const LegalBlock.paragraph('Sont notamment concernées :'),
        const LegalBlock.bullets([
          'les batteries ;',
          'les liquides ;',
          'les produits alimentaires ;',
          'les médicaments ;',
          'les cosmétiques ;',
          'les produits chimiques ;',
          'les équipements radio ;',
          'les animaux et végétaux ;',
          'les métaux précieux ;',
          'les marchandises dangereuses.',
        ]),
        const LegalBlock.paragraph(
          'Ahiyoyo peut refuser, isoler, retourner ou remettre aux autorités une marchandise interdite ou non '
          'déclarée.',
        ),
        const LegalBlock.paragraph('Les coûts, amendes, pertes et conséquences résultant d\'une fausse déclaration sont supportés par le Client.'),
        const LegalBlock.heading('Article 30 – Voyages d\'affaires'),
        const LegalBlock.paragraph(
          'Le service de voyage d\'affaires peut comprendre l\'élaboration d\'un programme, l\'assistance '
          'documentaire, l\'organisation de visites, l\'interprétariat, les transferts, les réservations et '
          'l\'accompagnement auprès de fournisseurs.',
        ),
        const LegalBlock.paragraph('Ahiyoyo ne garantit pas :'),
        const LegalBlock.bullets([
          'l\'obtention d\'un visa ;',
          'l\'entrée sur un territoire ;',
          'la disponibilité d\'un vol ;',
          'la conclusion d\'un contrat commercial ;',
          'la fiabilité absolue d\'un fournisseur ;',
          'le succès commercial du voyage.',
        ]),
        const LegalBlock.paragraph(
          'Le voyageur reste responsable de son passeport, de son visa, de ses assurances, de ses vaccins, de '
          'ses moyens financiers et du respect des règles du pays visité.',
        ),
        const LegalBlock.paragraph(
          'Les billets, hôtels et autres prestations de tiers restent soumis aux conditions d\'annulation de ces '
          'prestataires.',
        ),
      ],
    ),
    LegalSection(
      id: 'section-8',
      title: 'VIII. Données, responsabilité et dispositions finales',
      blocks: [
        const LegalBlock.heading('Article 31 – Données personnelles et communications'),
        const LegalBlock.paragraph(
          'Ahiyoyo collecte et traite les données nécessaires à la création des comptes, l\'établissement des '
          'devis, la facturation, l\'achat, le paiement, l\'expédition, la douane, la livraison, la gestion des '
          'réclamations, la prévention de la fraude, l\'organisation des voyages et l\'exécution de ses obligations '
          'légales.',
        ),
        const LegalBlock.paragraph(
          'Les données peuvent être communiquées aux fournisseurs, transporteurs, entrepôts, assureurs, '
          'prestataires de paiement, administrations et partenaires nécessaires à la commande, y compris '
          'lorsqu\'ils sont situés hors du Bénin.',
        ),
        const LegalBlock.paragraph(
          'Le Client peut exercer les droits prévus par la réglementation applicable en écrivant à '
          'support@ahiyoyo.com.',
        ),
        const LegalBlock.paragraph(
          'Les messages relatifs aux commandes peuvent être envoyés par notification, courrier électronique, '
          'téléphone, SMS ou WhatsApp.',
        ),
        const LegalBlock.paragraph('Le Client doit maintenir ses coordonnées à jour.'),
        const LegalBlock.heading('Article 32 – Preuve électronique et propriété intellectuelle'),
        const LegalBlock.paragraph(
          'Peuvent être utilisés comme éléments de preuve les validations effectuées sur la Plateforme, les '
          'journaux de connexion, les courriers électroniques, les messages officiels, les devis, les factures, les '
          'reçus, les preuves de paiement, les photographies, les vidéos, les documents de transport et les '
          'données de suivi.',
        ),
        const LegalBlock.paragraph(
          'La marque Ahiyoyo, la Plateforme, les textes, logiciels, modèles, bases de données, visuels et '
          'documents appartiennent à Ahiyoyo ou à leurs titulaires respectifs.',
        ),
        const LegalBlock.paragraph('Leur reproduction, revente ou utilisation non autorisée est interdite.'),
        const LegalBlock.paragraph(
          'Le Client autorise Ahiyoyo à utiliser les photographies et documents transmis uniquement pour '
          'exécuter la commande, assurer le suivi, vérifier la conformité et conserver les preuves nécessaires.',
        ),
        const LegalBlock.heading('Article 33 – Suspension ou fermeture du compte'),
        const LegalBlock.paragraph(
          'Ahiyoyo peut suspendre une commande ou un compte en cas de fraude, impayé, fausse déclaration, '
          'comportement abusif, risque de sécurité, marchandise interdite, violation des CGU ou demande d\'une '
          'autorité.',
        ),
        const LegalBlock.paragraph(
          'La suspension ne supprime pas les factures, frais de stockage, obligations douanières ou '
          'commandes déjà engagées.',
        ),
        const LegalBlock.paragraph(
          'Le Client peut demander la fermeture de son compte après le règlement et la clôture de toutes les '
          'opérations en cours.',
        ),
        const LegalBlock.heading('Article 34 – Responsabilité et force majeure'),
        const LegalBlock.paragraph('Chaque partie est responsable des dommages directs causés par sa faute prouvée.'),
        const LegalBlock.paragraph(
          'Ahiyoyo n\'est notamment pas responsable d\'un défaut propre au produit, d\'une fausse information '
          'communiquée par le Client, d\'un fournisseur directement choisi par le Client, d\'une décision d\'une '
          'autorité, d\'un événement relevant du transporteur, d\'un usage du produit non communiqué ou d\'un '
          'défaut caché non détectable par un contrôle visuel.',
        ),
        const LegalBlock.paragraph('La responsabilité d\'Ahiyoyo est appréciée selon le rôle qu\'elle assume réellement dans la commande.'),
        const LegalBlock.paragraph(
          'Lorsqu\'Ahiyoyo agit comme intermédiaire ou organisateur logistique, elle ne devient pas '
          'automatiquement le fabricant, le vendeur initial, le transporteur ou l\'autorité douanière.',
        ),
        const LegalBlock.paragraph('Aucune partie n\'est responsable d\'un retard ou d\'une inexécution résultant d\'un événement extérieur, imprévisible et irrésistible, notamment :'),
        const LegalBlock.bullets([
          'une catastrophe naturelle ;',
          'une guerre ;',
          'une épidémie ;',
          'un incendie ;',
          'une fermeture de frontière ;',
          'une grève générale ;',
          'une panne majeure ;',
          'une congestion portuaire exceptionnelle ;',
          'une décision d\'une autorité.',
        ]),
        const LegalBlock.heading('Article 35 – Modification des CGU'),
        const LegalBlock.paragraph(
          'Ahiyoyo peut modifier les CGU pour tenir compte d\'une évolution de ses services, de la Plateforme, '
          'de la réglementation ou de ses pratiques opérationnelles.',
        ),
        const LegalBlock.paragraph(
          'La nouvelle version indique sa date d\'entrée en vigueur et s\'applique aux commandes passées après '
          'cette date.',
        ),
        const LegalBlock.paragraph(
          'Une commande déjà validée reste soumise à la version acceptée au moment de sa validation, sauf '
          'modification imposée par la loi ou expressément acceptée par le Client.',
        ),
        const LegalBlock.heading('Article 36 – Réclamations, droit applicable et litiges'),
        const LegalBlock.paragraph(
          'Toute réclamation contractuelle doit d\'abord être adressée à support@ahiyoyo.com avec les '
          'références et documents nécessaires.',
        ),
        const LegalBlock.paragraph('Ahiyoyo et le Client recherchent en priorité une solution amiable.'),
        const LegalBlock.paragraph(
          'Les présentes CGU sont soumises au droit de la République du Bénin ainsi qu\'aux Actes uniformes '
          'OHADA et aux règles impératives relatives au transport lorsqu\'ils sont applicables.',
        ),
        const LegalBlock.paragraph(
          'À défaut d\'accord amiable, les litiges entre professionnels relèvent des juridictions compétentes de '
          'Cotonou, sauf règle impérative ou clause particulière valable.',
        ),
        const LegalBlock.paragraph('Pour un consommateur, la juridiction compétente est déterminée conformément à la législation applicable.'),
        const LegalBlock.paragraph('La version française des CGU fait foi. Les présentes CGU entrent en vigueur le 19 juillet 2026.'),
      ],
    ),
    LegalSection(
      id: 'annexes',
      title: 'Annexes pratiques',
      blocks: [
        const LegalBlock.heading('Annexe 1 – Règles pratiques d\'utilisation'),
        const LegalBlock.numbered([
          'Créer une demande ou une expédition avant d\'envoyer le colis à l\'entrepôt.',
          'Transmettre au fournisseur le marquage Ahiyoyo et la référence du Client.',
          'Vérifier que ces informations sont inscrites sur chaque carton.',
          'Téléverser les factures, preuves de paiement et numéros de suivi.',
          'Déclarer fidèlement la nature, la quantité et la valeur des produits.',
          'Consulter régulièrement le tableau de bord.',
          'Répondre rapidement aux demandes de validation ou de documents.',
          'Effectuer les paiements uniquement sur les coordonnées officielles.',
          'Vérifier le poids et le CBM confirmés après réception.',
          'Régler le solde avant le retrait ou la livraison.',
        ]),
        const LegalBlock.heading('Annexe 2 – Services généralement inclus ou exclus du groupage'),
        const LegalBlock.paragraph('Sauf indication différente dans le devis, le tarif de groupage comprend généralement :'),
        const LegalBlock.bullets([
          'la consolidation ;',
          'le transport principal ;',
          'les frais ordinaires de douane ;',
          'le dédouanement du flux groupé ;',
          'la mise à disposition de la marchandise au point convenu.',
        ]),
        const LegalBlock.paragraph('Peuvent être facturés séparément :'),
        const LegalBlock.bullets([
          'la collecte chez le fournisseur ;',
          'la livraison finale ;',
          'l\'emballage renforcé ;',
          'l\'assurance ;',
          'l\'inspection ;',
          'les autorisations particulières ;',
          'les taxes spécifiques au produit ;',
          'le magasinage ;',
          'les surestaries ;',
          'les frais de retour ;',
          'les frais de destruction ;',
          'les amendes ;',
          'les frais provoqués par une déclaration inexacte.',
        ]),
        const LegalBlock.heading('Annexe 3 – Documents pouvant être demandés'),
        const LegalBlock.bullets([
          'une pièce d\'identité ;',
          'un IFU ;',
          'un RCCM ;',
          'une procuration ;',
          'un justificatif du représentant ;',
          'une facture fournisseur ;',
          'une preuve de paiement ;',
          'un lien ou une fiche produit ;',
          'un packing list ;',
          'les dimensions et poids ;',
          'la matière et l\'usage du produit ;',
          'la valeur réelle de la marchandise ;',
          'le code HS ;',
          'une licence ;',
          'un certificat ;',
          'une fiche de sécurité ;',
          'une autorisation spéciale ;',
          'un passeport ;',
          'un visa ;',
          'une assurance de voyage ;',
          'tout autre document raisonnablement nécessaire à la douane, à la fiscalité, à la sécurité ou à la conformité.',
        ]),
      ],
    ),
    LegalSection(
      id: 'contact',
      title: 'Contact',
      blocks: [
        const LegalBlock.paragraph('NEW MARKETS TECHNOLOGIES SAS — Enseigne commerciale : Ahiyoyo'),
        const LegalBlock.paragraph('Capital social : 2 000 000 FCFA'),
        const LegalBlock.paragraph('RCCM : RB/COT/25 B 40607 • IFU : 3202585063521'),
        const LegalBlock.paragraph(
          'Siège : Ilot 1146, Quartier Houéhoun, Parcelle C, Maison ABUDU RAFIOU YESSOUFOU, Cotonou, Bénin',
        ),
        const LegalBlock.paragraph('Téléphone : +229 01 91 08 41 41 • Email : support@ahiyoyo.com'),
      ],
    ),
  ],
);
