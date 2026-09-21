import 'legal_document.dart';

/// Contenu intégral de la politique de confidentialité Ahiyoyo (version
/// révisée du 19 juillet 2026), transcrit depuis
/// legal-docs/politique-confidentialite-ahiyoyo-19-juillet-2026.pdf.
final LegalDocument privacyPolicyDocument = LegalDocument(
  title: 'Politique de confidentialité',
  subtitle: 'Plateforme web et mobile Ahiyoyo — Achats • Expéditions • Achats avec expédition • Voyages d\'affaires',
  versionLabel: 'Version révisée du 19 juillet 2026',
  pdfAssetPath: 'legal-docs/politique-confidentialite-ahiyoyo-19-juillet-2026.pdf',
  pdfFileName: 'Politique-de-confidentialite-Ahiyoyo.pdf',
  sections: [
    LegalSection(
      id: 'a-retenir',
      title: 'À retenir',
      blocks: [
        const LegalBlock.bullets([
          'Ahiyoyo utilise les données nécessaires pour faire fonctionner la plateforme, exécuter et sécuriser les services, suivre les paiements, prévenir les abus et améliorer ses opérations.',
          'Les données peuvent être communiquées aux équipes, fournisseurs, transporteurs, entrepôts, prestataires de paiement, autorités et partenaires utiles à l\'opération, y compris à l\'étranger.',
          'Vous conservez les droits prévus par la loi. Certaines données restent toutefois conservées lorsqu\'elles sont nécessaires à une opération, une facture, un recouvrement, une obligation légale ou la défense d\'un droit.',
        ]),
        const LegalBlock.paragraph(
          'Ahiyoyo utilise les données nécessaires au fonctionnement de la plateforme, à l\'exécution des '
          'commandes, au suivi des paiements, à la sécurité des opérations et à l\'amélioration de ses services. '
          'Pour toute demande relative aux données personnelles : support@ahiyoyo.com, objet « Protection '
          'des données ».',
        ),
      ],
    ),
    LegalSection(
      id: 's1',
      title: '1. Objet de la politique',
      blocks: [
        const LegalBlock.paragraph(
          'La présente politique explique comment NEW MARKETS TECHNOLOGIES SAS, exploitant la '
          'plateforme Ahiyoyo, collecte, utilise, conserve et protège les données personnelles des utilisateurs, '
          'clients, prospects, fournisseurs, partenaires, destinataires de colis et participants aux voyages '
          'd\'affaires.',
        ),
        const LegalBlock.paragraph(
          'Elle s\'applique au site internet, à l\'application mobile, au tableau de bord client, aux formulaires, '
          'aux échanges avec le service client ainsi qu\'aux services d\'achat, d\'expédition terrestre, maritime '
          'ou aérienne, d\'achat avec expédition et d\'organisation de voyages d\'affaires.',
        ),
        const LegalBlock.paragraph(
          'Elle complète les Conditions générales d\'utilisation et de services de la plateforme. Les deux '
          'documents s\'interprètent ensemble. Les Conditions générales régissent l\'exécution des services ; la '
          'présente politique régit l\'utilisation des données personnelles, sous réserve des dispositions '
          'impératives de la loi.',
        ),
      ],
    ),
    LegalSection(
      id: 's2',
      title: '2. Responsable du traitement',
      blocks: [
        const LegalBlock.paragraph(
          'Le responsable du traitement est NEW MARKETS TECHNOLOGIES SAS, enseigne Ahiyoyo, société '
          'immatriculée au RCCM sous le numéro RB/COT/25 B 40607, IFU 3202585063521, dont le siège est '
          'situé à Cotonou, Bénin.',
        ),
        const LegalBlock.paragraph(
          'Les demandes relatives aux données personnelles peuvent être adressées à support@ahiyoyo.com '
          'ou au +229 01 91 08 41 41. Ahiyoyo peut demander toute information raisonnablement nécessaire '
          'pour vérifier l\'identité, le compte ou la qualité du demandeur avant de donner suite à une demande.',
        ),
      ],
    ),
    LegalSection(
      id: 's3',
      title: '3. Données collectées',
      blocks: [
        const LegalBlock.paragraph('Selon le service utilisé, Ahiyoyo peut collecter les catégories de données suivantes :'),
        const LegalBlock.bullets([
          'Données d\'identification et de contact : nom, prénom, raison sociale, adresse, pays, numéro de téléphone, adresse électronique, photo de profil et, lorsque la réglementation ou la nature du service l\'exige, pièce d\'identité.',
          'Données du compte : identifiant, mot de passe chiffré ou autre moyen d\'authentification, rôle, préférences, historique de connexion et actions réalisées sur la plateforme.',
          'Données commerciales : demandes de devis, liens et photos de produits, quantités, caractéristiques, préférences, échanges avec les fournisseurs, commandes, factures proforma, contrats, instructions, réclamations et historique de la relation client.',
          'Données de paiement et de facturation : montant, devise, référence de transaction, compte ou moyen de paiement utilisé, preuve de paiement, statut du règlement, IFU, RCCM, adresse de facturation, factures normalisées, avoirs et informations nécessaires au recouvrement.',
          'Données logistiques : contenu déclaré, valeur, poids, dimensions, CBM, nombre de cartons, shipping mark, numéro de suivi, entrepôt, itinéraire, photos du colis, documents de transport, documents douaniers, identité et coordonnées du destinataire, preuve de remise ou de livraison.',
          'Données relatives aux voyages d\'affaires : identité, nationalité, numéro de passeport, visa, dates de voyage, itinéraire, réservations, entreprise représentée, invitations, contacts professionnels, besoins d\'assistance et documents demandés par les autorités, compagnies ou prestataires de voyage.',
          'Données de communication : messages, courriels, appels, notes du service client, fichiers transmis, échanges WhatsApp, comptes rendus, instructions et informations publiées dans un groupe de travail créé pour une commande ou une mission.',
          'Données techniques : adresse IP, type d\'appareil, système d\'exploitation, navigateur, journaux de sécurité, pages consultées, date et heure d\'accès, identifiants techniques, cookies et technologies similaires.',
          'Autorisations de l\'appareil : appareil photo, galerie, fichiers ou notifications, uniquement lorsque l\'utilisateur active une fonction qui nécessite cette autorisation, par exemple l\'envoi d\'une photo d\'article ou d\'une preuve de paiement.',
        ]),
      ],
    ),
    LegalSection(
      id: 's4',
      title: '4. Origine des données',
      blocks: [
        const LegalBlock.paragraph(
          'Les données sont principalement fournies par l\'utilisateur lorsqu\'il crée un compte, demande un '
          'devis, transmet une commande, effectue un paiement, enregistre un colis, suit une expédition, '
          'sollicite une facture ou contacte le support. Ahiyoyo peut rapprocher les informations reçues par '
          'différents canaux afin de tenir un dossier unique et cohérent.',
        ),
        const LegalBlock.paragraph(
          'Ahiyoyo peut aussi recevoir des informations d\'un représentant de l\'utilisateur, d\'un fournisseur, '
          'd\'une place de marché, d\'un entrepôt, d\'un transporteur, d\'un transitaire, d\'un prestataire de '
          'paiement, d\'une administration, d\'un partenaire de voyage ou d\'un autre client qui désigne '
          'l\'utilisateur comme destinataire ou personne de contact.',
        ),
        const LegalBlock.paragraph('Certaines données techniques sont recueillies automatiquement lorsque la plateforme est utilisée.'),
      ],
    ),
    LegalSection(
      id: 's5',
      title: '5. Finalités et bases du traitement',
      blocks: [
        const LegalBlock.paragraph(
          'Ahiyoyo traite les données uniquement pour des finalités déterminées. Les principaux traitements '
          'sont présentés ci-dessous.',
        ),
        const LegalBlock.table(
          headers: ['Finalité', 'Exemples d\'utilisation', 'Fondement principal'],
          rows: [
            ['Créer et sécuriser le compte', 'Inscription, authentification, gestion du profil, contrôle des habilitations et prévention des accès frauduleux.', 'Exécution du service et intérêt légitime lié à la sécurité.'],
            ['Répondre aux demandes de devis', 'Analyse du besoin, recherche fournisseur, estimation du prix, du poids, du volume et du délai.', 'Mesures précontractuelles demandées par l\'utilisateur.'],
            ['Exécuter les achats', 'Commande fournisseur, négociation, paiement, inspection ou vérification lorsqu\'elle est prévue.', 'Exécution du contrat.'],
            ['Organiser les expéditions', 'Réception en entrepôt, groupage, transport, suivi, douane, remise et preuve de livraison.', 'Exécution du contrat et obligations légales.'],
            ['Traiter les paiements et recouvrements', 'Acomptes, soldes, rapprochements, appréciation du risque, relances, remboursement, lutte contre la fraude et recouvrement.', 'Exécution du contrat, intérêt légitime et obligations légales.'],
            ['Émettre les documents fiscaux', 'Factures normalisées, factures d\'acompte, avoirs, pièces justificatives, conservation comptable.', 'Obligations fiscales et comptables.'],
            ['Organiser les voyages d\'affaires', 'Visa, invitation, billet, hébergement, rendez-vous, accompagnement local et assistance.', 'Exécution du contrat et consentement lorsque requis.'],
            ['Assurer le support', 'Réponse aux demandes, suivi d\'incident, réclamation, contrôle qualité, preuve des instructions et amélioration du service.', 'Exécution du contrat et intérêt légitime.'],
            ['Respecter la loi et protéger les parties', 'Contrôles de conformité, détection des abus, prévention des fraudes, demandes des autorités, contentieux et sécurité.', 'Obligation légale et intérêt légitime.'],
            ['Informer sur les services', 'Notifications opérationnelles, informations sur les tarifs, destinations, services complémentaires et campagnes autorisées.', 'Exécution du service, intérêt légitime ou consentement selon le message.'],
          ],
        ),
        const LegalBlock.paragraph(
          'Ahiyoyo peut croiser les données du compte, des commandes, des paiements, des échanges et des '
          'opérations logistiques afin de détecter les doublons, erreurs, incohérences, fraudes, impayés ou '
          'usages contraires aux Conditions générales.',
        ),
        const LegalBlock.paragraph(
          'Ahiyoyo peut également établir des statistiques, tableaux de bord, indicateurs et analyses internes '
          'pour piloter ses activités, adapter ses tarifs, améliorer les délais, la qualité du support et la sécurité. '
          'Ces analyses sont, autant que possible, réalisées à partir de données agrégées ou pseudonymisées.',
        ),
      ],
    ),
    LegalSection(
      id: 's6',
      title: '6. Données obligatoires et facultatives',
      blocks: [
        const LegalBlock.paragraph(
          'Les champs signalés comme obligatoires sont nécessaires pour créer un compte, établir un devis, '
          'vérifier un paiement, identifier un colis, émettre une facture ou fournir le service demandé. Sans ces '
          'informations, Ahiyoyo peut ne pas être en mesure de traiter la demande.',
        ),
        const LegalBlock.paragraph(
          'Les informations facultatives servent à mieux préciser le besoin ou à faciliter la communication. '
          'Ahiyoyo peut toutefois demander des informations ou justificatifs complémentaires lorsqu\'ils sont '
          'utiles à la sécurité, à la conformité, à la facturation, au paiement, au transport, à la douane ou au '
          'traitement d\'une réclamation. À défaut, le service peut être limité, suspendu ou refusé.',
        ),
      ],
    ),
    LegalSection(
      id: 's7',
      title: '7. Paiements, facturation et recouvrement',
      blocks: [
        const LegalBlock.paragraph(
          'Ahiyoyo conserve les informations nécessaires pour identifier les paiements, les rapprocher des '
          'devis et commandes, établir les factures normalisées, suivre les règlements partiels, apprécier les '
          'risques d\'impayé, relancer les échéances et justifier les opérations auprès des autorités, auditeurs '
          'ou conseils habilités.',
        ),
        const LegalBlock.paragraph(
          'Lorsqu\'un paiement est traité par une banque, un opérateur de mobile money ou un prestataire '
          'externe, celui-ci traite les données nécessaires au paiement selon ses propres règles. Ahiyoyo reçoit '
          'généralement le montant, la référence, la date, le statut et les informations utiles au rapprochement, '
          'mais n\'a pas vocation à conserver les données secrètes d\'authentification du client.',
        ),
        const LegalBlock.paragraph(
          'Les données liées aux impayés peuvent être utilisées pour les relances amiables, la négociation '
          'd\'un échéancier, la mise en demeure, l\'exercice d\'un droit de rétention, la compensation, la '
          'transmission du dossier à un conseil ou prestataire de recouvrement, le recouvrement judiciaire et la '
          'défense des droits d\'Ahiyoyo, dans les limites prévues par la loi et les Conditions générales.',
        ),
      ],
    ),
    LegalSection(
      id: 's8',
      title: '8. Données logistiques et groupage',
      blocks: [
        const LegalBlock.paragraph(
          'Pour les expéditions groupées, Ahiyoyo doit pouvoir rattacher chaque colis à son propriétaire ou '
          'donneur d\'ordre. Le shipping mark, le numéro client, la description, la valeur, le poids, le volume, les '
          'photos, les documents d\'achat et les coordonnées du destinataire peuvent donc être communiqués '
          'aux entrepôts, transporteurs, transitaires et autorités concernés.',
        ),
        const LegalBlock.paragraph(
          'Les informations relatives à un colis ne confèrent aucun droit sur les marchandises des autres '
          'participants au groupage. Ahiyoyo limite l\'accès aux données de chaque client aux personnes qui '
          'en ont besoin pour la réception, la consolidation, le transport, le dédouanement, la facturation et la '
          'remise.',
        ),
        const LegalBlock.paragraph(
          'Lorsque des documents de transport ou de douane regroupent plusieurs clients, Ahiyoyo peut '
          'conserver les pièces communes et produire, pour chaque client, les justificatifs individualisés '
          'disponibles.',
        ),
      ],
    ),
    LegalSection(
      id: 's9',
      title: '9. Voyages d\'affaires',
      blocks: [
        const LegalBlock.paragraph(
          'Pour organiser un voyage d\'affaires, Ahiyoyo peut traiter des données figurant sur le passeport, le '
          'visa, la lettre d\'invitation, le billet, les réservations, l\'assurance, le programme de rendez-vous et '
          'les documents professionnels remis par le participant.',
        ),
        const LegalBlock.paragraph(
          'Ces informations peuvent être transmises, selon la mission, aux ambassades et consulats, centres '
          'de visas, administrations, compagnies aériennes, hôtels, assureurs, agences, chauffeurs, '
          'interprètes, organisateurs de salons, fournisseurs et partenaires locaux.',
        ),
        const LegalBlock.paragraph(
          'Le participant ne doit transmettre que les informations demandées. Les données particulièrement '
          'sensibles ou sans lien avec le voyage ne doivent pas être envoyées. Lorsque la mission est '
          'organisée pour plusieurs participants, chacun doit respecter la confidentialité des informations '
          'visibles dans les échanges communs.',
        ),
      ],
    ),
    LegalSection(
      id: 's10',
      title: '10. WhatsApp, messageries et groupes de travail',
      blocks: [
        const LegalBlock.paragraph(
          'Ahiyoyo peut choisir le canal de communication le plus adapté, notamment la plateforme, WhatsApp, '
          'le courrier électronique, le téléphone, le SMS ou les notifications mobiles. Les messages, fichiers, '
          'numéros, noms de profil, confirmations de lecture et dates d\'échange peuvent être conservés '
          'lorsqu\'ils sont utiles au suivi du service, à la preuve d\'une instruction, au recouvrement ou au '
          'traitement d\'une réclamation.',
        ),
        const LegalBlock.paragraph(
          'Lorsqu\'un groupe de travail réunit un client, un fournisseur, un agent, un transporteur ou un autre '
          'partenaire, les participants peuvent voir les informations que chaque membre rend visibles dans '
          'l\'application. Il est demandé de ne pas publier de document personnel, de mot de passe, de donnée '
          'bancaire confidentielle ou d\'information sans rapport avec l\'opération.',
        ),
        const LegalBlock.paragraph(
          'Ahiyoyo peut extraire, résumer, classer et archiver les éléments utiles des échanges afin de mettre '
          'à jour le compte, la commande, la facture, le suivi logistique, le dossier de paiement ou la '
          'réclamation. Ces éléments peuvent servir de preuve des instructions et validations données dans le '
          'cadre de l\'opération.',
        ),
      ],
    ),
    LegalSection(
      id: 's11',
      title: '11. Destinataires des données',
      blocks: [
        const LegalBlock.paragraph('Dans la limite de leurs missions, les données peuvent être accessibles :'),
        const LegalBlock.bullets([
          'aux salariés, agents, représentants locaux, consultants et prestataires d\'Ahiyoyo soumis à une obligation de confidentialité ;',
          'aux fournisseurs et vendeurs chargés de préparer ou personnaliser les marchandises ;',
          'aux entrepôts, transporteurs, transitaires, manutentionnaires, livreurs et compagnies aériennes ou maritimes ;',
          'aux prestataires de paiement, banques, opérateurs de mobile money, assureurs, comptables, auditeurs et conseils ;',
          'aux hébergeurs, éditeurs de logiciels, outils de gestion, services de communication, support technique, analystes et prestataires de cybersécurité ;',
          'aux partenaires chargés des voyages d\'affaires, visas, réservations, interprétation et rendez-vous ;',
          'aux administrations fiscales, douanières, judiciaires, policières ou autres autorités légalement habilitées ;',
          'à un acquéreur, investisseur, financeur ou partenaire en cas d\'audit, de financement, de réorganisation, de cession ou de transfert de tout ou partie de l\'activité, sous réserve de mesures de confidentialité appropriées.',
        ]),
        const LegalBlock.paragraph(
          'Ahiyoyo ne commercialise pas les données personnelles comme un fichier de contacts. Les '
          'partenaires reçoivent les informations utiles à leur intervention et peuvent les traiter conformément à '
          'leurs obligations propres lorsqu\'ils agissent comme responsables indépendants, notamment les '
          'banques, transporteurs, compagnies, administrations et prestataires de voyage.',
        ),
      ],
    ),
    LegalSection(
      id: 's12',
      title: '12. Transferts internationaux',
      blocks: [
        const LegalBlock.paragraph(
          'Les services Ahiyoyo sont internationaux. Leur utilisation implique que certaines données puissent '
          'être consultées ou traitées dans le pays d\'achat, de départ, de transit ou de destination des '
          'marchandises ou du voyage, notamment lorsque le fournisseur, l\'entrepôt, le transporteur, le '
          'prestataire technique ou le partenaire se trouve hors du Bénin.',
        ),
        const LegalBlock.paragraph(
          'Ahiyoyo transmet les informations raisonnablement nécessaires à l\'opération et met en place, selon '
          'le contexte, des restrictions d\'accès, des engagements contractuels, des mesures de sécurité ou les '
          'formalités exigées par la réglementation applicable. Lorsque le transfert est indispensable à '
          'l\'exécution du service demandé, l\'utilisateur reconnaît que l\'opération ne peut pas toujours être '
          'réalisée sans cette transmission.',
        ),
        const LegalBlock.paragraph(
          'L\'utilisateur peut demander des informations complémentaires sur les garanties appliquées à un '
          'transfert lié à son dossier, sous réserve de la confidentialité des contrats et des mesures de '
          'sécurité.',
        ),
      ],
    ),
    LegalSection(
      id: 's13',
      title: '13. Cookies et technologies similaires',
      blocks: [
        const LegalBlock.paragraph(
          'La plateforme peut utiliser des cookies, identifiants d\'appareil, journaux techniques ou technologies '
          'similaires pour maintenir la session, sécuriser le compte, mémoriser les préférences, mesurer '
          'l\'utilisation du service, corriger les erreurs, prévenir les abus et améliorer les parcours. Les outils '
          'non essentiels sont activés selon les règles de consentement applicables.',
        ),
        const LegalBlock.table(
          headers: ['Catégorie', 'Utilité', 'Choix de l\'utilisateur'],
          rows: [
            ['Strictement nécessaires', 'Connexion, sécurité, panier, formulaires, choix de confidentialité et fonctionnement essentiel.', 'Toujours actifs car nécessaires au service.'],
            ['Préférences', 'Langue, pays, affichage et options choisies par l\'utilisateur.', 'Peuvent être désactivés lorsque la plateforme le permet.'],
            ['Mesure d\'audience', 'Comprendre les parcours, erreurs et performances afin d\'améliorer la plateforme.', 'Activés selon le consentement requis.'],
            ['Publicité ou campagnes', 'Mesurer une campagne ou proposer un contenu pertinent sur un service tiers.', 'Activés uniquement lorsque ce traitement est utilisé et autorisé.'],
          ],
        ),
        const LegalBlock.paragraph(
          'Lorsque le consentement est requis, l\'utilisateur peut accepter, refuser ou modifier ses choix depuis '
          'l\'outil de gestion des cookies mis à disposition sur la plateforme. Le refus des cookies non '
          'essentiels ne bloque pas l\'accès aux fonctions principales.',
        ),
      ],
    ),
    LegalSection(
      id: 's14',
      title: '14. Communications et prospection',
      blocks: [
        const LegalBlock.paragraph(
          'Les messages nécessaires au service, par exemple une demande de paiement, une notification '
          'd\'arrivée, une mise à jour de suivi, une alerte de sécurité ou une information sur une commande, ne '
          'sont pas des messages publicitaires et peuvent être envoyés pendant l\'exécution de la relation.',
        ),
        const LegalBlock.paragraph(
          'Ahiyoyo peut informer ses clients et prospects de ses offres, nouveautés, tarifs, destinations, délais '
          'ou services complémentaires lorsque la réglementation le permet. Les communications '
          'commerciales comportent un moyen simple de s\'opposer ou de se désabonner. Pour WhatsApp ou '
          'SMS, la demande d\'arrêt peut être adressée au support.',
        ),
        const LegalBlock.paragraph(
          'Le retrait du consentement n\'empêche pas Ahiyoyo d\'envoyer les informations nécessaires à une '
          'commande ou à une obligation légale en cours.',
        ),
      ],
    ),
    LegalSection(
      id: 's15',
      title: '15. Sécurité et confidentialité',
      blocks: [
        const LegalBlock.paragraph(
          'Ahiyoyo met en œuvre des mesures raisonnables et proportionnées à la nature des données, aux '
          'moyens disponibles et aux risques : contrôle des accès, gestion des habilitations, authentification, '
          'journalisation, sauvegardes, protection des équipements, transmission sécurisée lorsque cela est '
          'possible, clauses de confidentialité, sensibilisation des équipes et procédures de gestion des '
          'incidents.',
        ),
        const LegalBlock.paragraph(
          'Aucun système n\'offre une sécurité absolue. L\'utilisateur doit protéger son mot de passe, éviter de '
          'le partager, vérifier les coordonnées de paiement communiquées et signaler rapidement toute '
          'connexion ou demande inhabituelle.',
        ),
        const LegalBlock.paragraph(
          'En cas d\'incident susceptible de porter atteinte aux données personnelles, Ahiyoyo prend les '
          'mesures utiles pour limiter les conséquences, documenter l\'incident et informer les autorités ou les '
          'personnes concernées lorsque la loi l\'exige.',
        ),
        const LegalBlock.paragraph(
          'Les journaux de connexion, validations électroniques, historiques de statut, confirmations de '
          'paiement, messages et instructions enregistrés dans les outils d\'Ahiyoyo peuvent être conservés '
          'comme éléments de traçabilité et de preuve, sous réserve des règles applicables.',
        ),
      ],
    ),
    LegalSection(
      id: 's16',
      title: '16. Durées de conservation',
      blocks: [
        const LegalBlock.paragraph(
          'Les données sont conservées pendant la durée utile au fonctionnement du compte, à la relation '
          'commerciale, à l\'exécution des opérations, au suivi des paiements, à la conformité, aux contrôles '
          'internes et à la défense des droits d\'Ahiyoyo. Les durées peuvent varier selon la nature du dossier '
          'et les obligations applicables.',
        ),
        const LegalBlock.table(
          headers: ['Catégorie', 'Durée ou critère de conservation'],
          rows: [
            ['Compte et profil', 'Pendant la durée d\'utilisation du compte, puis pendant la période utile à la relation commerciale, à la sécurité, aux réclamations, au recouvrement et aux obligations légales.'],
            ['Devis sans commande', 'Pendant la durée utile au suivi commercial et à l\'analyse du besoin, puis suppression, anonymisation ou archivage limité selon l\'intérêt légitime et les obligations applicables.'],
            ['Commandes, paiements, transport et facturation', 'Pendant l\'exécution de l\'opération, puis pendant les durées contractuelles, comptables et fiscales applicables, généralement jusqu\'à dix ans, et plus longtemps en cas de litige ou de contrôle.'],
            ['Documents de voyage', 'Pendant la préparation et l\'exécution de la mission, puis conservation limitée lorsque le document reste utile à la preuve, à la conformité, à une réclamation ou à une obligation légale.'],
            ['Support et réclamations', 'Pendant le traitement de la demande, puis pendant la période utile au contrôle qualité, à la preuve des instructions, au recouvrement ou à la défense des droits.'],
            ['Prospection', 'Pendant la relation commerciale et jusqu\'à l\'opposition, au désabonnement ou à l\'expiration de la durée autorisée par la réglementation.'],
            ['Journaux de sécurité', 'Pendant une durée proportionnée au risque et aux besoins de preuve, afin de détecter les incidents, fraudes, erreurs et accès non autorisés.'],
            ['Cookies', 'Pendant la durée indiquée dans le module de gestion des cookies ou jusqu\'au retrait du consentement pour les cookies non essentiels.'],
          ],
        ),
        const LegalBlock.paragraph(
          'À l\'expiration de la durée utile, les données peuvent être supprimées, anonymisées ou placées en '
          'archivage intermédiaire avec un accès limité. Les copies de sauvegarde peuvent subsister pendant '
          'leur cycle normal de rotation, sans être réutilisées pour les opérations courantes.',
        ),
      ],
    ),
    LegalSection(
      id: 's17',
      title: '17. Droits des personnes',
      blocks: [
        const LegalBlock.paragraph('Sous réserve des conditions prévues par la loi, toute personne concernée peut exercer les droits suivants :'),
        const LegalBlock.bullets([
          'obtenir des informations sur l\'utilisation de ses données ;',
          'demander l\'accès aux données qui la concernent ;',
          'faire rectifier, compléter ou actualiser une information inexacte ;',
          'demander la suppression ou l\'oubli lorsque la conservation n\'est plus justifiée ;',
          's\'opposer à un traitement, notamment à la prospection commerciale ;',
          'retirer son consentement à tout moment lorsque le traitement repose sur le consentement ;',
          'demander la portabilité des données lorsque ce droit est applicable ;',
          'demander la limitation ou le verrouillage d\'un traitement dans les cas prévus ;',
          'introduire une réclamation auprès de l\'Autorité de Protection des Données Personnelles du Bénin.',
        ]),
        const LegalBlock.paragraph(
          'La demande doit préciser le droit exercé, les données ou le compte concerné et les coordonnées '
          'permettant de répondre. Ahiyoyo répond dans le délai prévu par la réglementation après vérification '
          'de l\'identité et de la portée de la demande. Une demande peut être limitée, différée ou refusée '
          'lorsqu\'elle porte atteinte aux droits d\'un tiers, qu\'elle est manifestement abusive ou répétitive, '
          'qu\'une obligation impose la conservation, qu\'une opération est encore en cours ou que les données '
          'sont nécessaires à la sécurité, au recouvrement ou à la défense d\'un droit.',
        ),
      ],
    ),
    LegalSection(
      id: 's18',
      title: '18. Fermeture du compte et suppression',
      blocks: [
        const LegalBlock.paragraph(
          'L\'utilisateur peut demander la fermeture de son compte par les moyens proposés sur la plateforme '
          'ou auprès du support. Ahiyoyo peut également suspendre ou fermer un compte pour raisons de '
          'sécurité, d\'inactivité, de non-conformité, d\'impayé, d\'abus ou de cessation du service. La fermeture '
          'n\'entraîne pas la suppression immédiate des factures, preuves de paiement, documents de '
          'transport, journaux de sécurité ou pièces nécessaires à une opération, une réclamation, un '
          'recouvrement ou une obligation légale.',
        ),
        const LegalBlock.paragraph(
          'Lorsque la suppression immédiate n\'est pas possible, les données sont isolées et leur accès est '
          'limité aux personnes autorisées jusqu\'à l\'expiration de la durée de conservation applicable.',
        ),
      ],
    ),
    LegalSection(
      id: 's19',
      title: '19. Données relatives à des tiers',
      blocks: [
        const LegalBlock.paragraph(
          'Un utilisateur peut transmettre les coordonnées d\'un destinataire, d\'un employé, d\'un fournisseur, '
          'd\'un représentant ou d\'un participant à un voyage. Il garantit qu\'il est autorisé à les communiquer, '
          'qu\'elles sont exactes et qu\'il a informé la personne concernée de leur utilisation dans le cadre du '
          'service.',
        ),
        const LegalBlock.paragraph(
          'Il est interdit de déposer sur la plateforme des pièces d\'identité, coordonnées bancaires ou '
          'informations confidentielles appartenant à un tiers sans nécessité et sans autorisation.',
        ),
      ],
    ),
    LegalSection(
      id: 's20',
      title: '20. Utilisation par les mineurs',
      blocks: [
        const LegalBlock.paragraph(
          'La plateforme est destinée aux personnes majeures, aux professionnels et aux représentants '
          'autorisés d\'une organisation. Un mineur ne peut pas conclure seul une opération sur Ahiyoyo. '
          'Ahiyoyo peut demander tout justificatif utile et refuser ou suspendre une opération lorsqu\'un doute '
          'existe sur l\'âge, la capacité ou le pouvoir de représentation de l\'utilisateur.',
        ),
      ],
    ),
    LegalSection(
      id: 's21',
      title: '21. Liens et services de tiers',
      blocks: [
        const LegalBlock.paragraph(
          'La plateforme peut contenir des liens vers des sites de fournisseurs, transporteurs, moyens de '
          'paiement, hôtels, compagnies, réseaux sociaux ou autres partenaires. Ces services disposent de '
          'leurs propres politiques de confidentialité. Ahiyoyo n\'est pas responsable de leurs pratiques '
          'lorsqu\'ils déterminent eux-mêmes la manière dont ils utilisent les données.',
        ),
        const LegalBlock.paragraph(
          'Lorsqu\'un prestataire agit pour le compte d\'Ahiyoyo, il reçoit des instructions adaptées à sa '
          'mission. Ahiyoyo peut changer de prestataire, ajouter un outil ou réorganiser ses moyens techniques '
          'sans accord individuel préalable, sous réserve de maintenir un niveau de protection approprié et de '
          'mettre à jour la présente politique lorsque cela est nécessaire.',
        ),
      ],
    ),
    LegalSection(
      id: 's22',
      title: '22. Modification de la politique',
      blocks: [
        const LegalBlock.paragraph(
          'Ahiyoyo peut modifier la présente politique pour tenir compte d\'une évolution de la plateforme, des '
          'services, de l\'organisation, des prestataires, des pays desservis ou de la réglementation. La date de '
          'la version en vigueur figure sur la première page.',
        ),
        const LegalBlock.paragraph(
          'Les modifications courantes prennent effet dès leur publication. Lorsqu\'une modification affecte de '
          'manière substantielle les droits des utilisateurs ou l\'utilisation de leurs données, Ahiyoyo fournit '
          'une information appropriée avant son application lorsque la réglementation l\'exige. La poursuite de '
          'l\'utilisation de la plateforme vaut prise de connaissance de la version publiée, sans limiter les droits '
          'qui nécessitent un consentement distinct.',
        ),
      ],
    ),
    LegalSection(
      id: 's23',
      title: '23. Contact et réclamation',
      blocks: [
        const LegalBlock.paragraph('Toute question ou demande relative aux données personnelles peut être envoyée à :'),
        const LegalBlock.paragraph('NEW MARKETS TECHNOLOGIES SAS — Ahiyoyo'),
        const LegalBlock.paragraph('Objet : Protection des données'),
        const LegalBlock.paragraph('Email : support@ahiyoyo.com'),
        const LegalBlock.paragraph('Téléphone : +229 01 91 08 41 41'),
        const LegalBlock.paragraph('Adresse : Ilot 1146, Quartier Houéhoun, Parcelle C, Maison ABUDU RAFIOU YESSOUFOU, Cotonou, Bénin'),
        const LegalBlock.paragraph(
          'Si la réponse apportée n\'est pas satisfaisante, la personne concernée peut saisir l\'Autorité de '
          'Protection des Données Personnelles du Bénin selon la procédure mise à disposition par cette '
          'autorité.',
        ),
        const LegalBlock.heading('Cadre de référence'),
        const LegalBlock.paragraph(
          'La présente politique est rédigée en tenant compte du Code du numérique en République du Bénin, '
          'des recommandations de l\'Autorité de Protection des Données Personnelles et des obligations '
          'comptables et fiscales applicables à NEW MARKETS TECHNOLOGIES SAS.',
        ),
      ],
    ),
  ],
);
