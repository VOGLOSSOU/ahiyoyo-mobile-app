/// Modèle générique pour un document légal statique (CGU, politique de
/// confidentialité) rendu nativement dans l'app, à partir du contenu
/// officiel fourni en PDF (dossier `legal-docs/` à la racine du projet).
library;

enum LegalBlockType { paragraph, heading, bullets, numbered, table }

class LegalBlock {
  final LegalBlockType type;
  final String? text;
  final List<String>? items;
  final List<String>? tableHeaders;
  final List<List<String>>? tableRows;

  const LegalBlock.paragraph(this.text)
      : type = LegalBlockType.paragraph,
        items = null,
        tableHeaders = null,
        tableRows = null;

  /// Sous-titre à l'intérieur d'une section (ex. "Article 1 – ...").
  const LegalBlock.heading(this.text)
      : type = LegalBlockType.heading,
        items = null,
        tableHeaders = null,
        tableRows = null;

  const LegalBlock.bullets(this.items)
      : type = LegalBlockType.bullets,
        text = null,
        tableHeaders = null,
        tableRows = null;

  const LegalBlock.numbered(this.items)
      : type = LegalBlockType.numbered,
        text = null,
        tableHeaders = null,
        tableRows = null;

  const LegalBlock.table({required List<String> headers, required List<List<String>> rows})
      : type = LegalBlockType.table,
        tableHeaders = headers,
        tableRows = rows,
        text = null,
        items = null;
}

/// Une section de premier niveau, ancrée pour le sommaire cliquable.
class LegalSection {
  final String id;
  final String title;
  final List<LegalBlock> blocks;

  const LegalSection({required this.id, required this.title, required this.blocks});
}

class LegalDocument {
  final String title;
  final String subtitle;
  final String versionLabel;
  final String pdfAssetPath;
  final String pdfFileName;
  final List<LegalSection> sections;

  const LegalDocument({
    required this.title,
    required this.subtitle,
    required this.versionLabel,
    required this.pdfAssetPath,
    required this.pdfFileName,
    required this.sections,
  });
}
