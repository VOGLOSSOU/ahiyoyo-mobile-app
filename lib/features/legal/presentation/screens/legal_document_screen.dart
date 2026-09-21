import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/ahiyoyo_button.dart';
import '../../../../core/widgets/ahiyoyo_card.dart';
import '../../domain/legal_document.dart';

/// Écran générique pour un document légal statique (CGU, politique de
/// confidentialité) : téléchargement du PDF source, sommaire cliquable et
/// rendu aéré des sections.
class LegalDocumentScreen extends StatefulWidget {
  final LegalDocument document;

  const LegalDocumentScreen({super.key, required this.document});

  @override
  State<LegalDocumentScreen> createState() => _LegalDocumentScreenState();
}

class _LegalDocumentScreenState extends State<LegalDocumentScreen> {
  final Map<String, GlobalKey> _sectionKeys = {};
  bool _isPreparingDownload = false;

  @override
  void initState() {
    super.initState();
    for (final section in widget.document.sections) {
      _sectionKeys[section.id] = GlobalKey();
    }
  }

  void _scrollToSection(String id) {
    final key = _sectionKeys[id];
    final sectionContext = key?.currentContext;
    if (sectionContext == null) return;
    Scrollable.ensureVisible(
      sectionContext,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      alignment: 0,
    );
  }

  Future<void> _downloadPdf() async {
    if (_isPreparingDownload) return;
    setState(() => _isPreparingDownload = true);
    try {
      final data = await rootBundle.load(widget.document.pdfAssetPath);
      final bytes = data.buffer.asUint8List();
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile.fromData(bytes, name: widget.document.pdfFileName, mimeType: 'application/pdf')],
          subject: widget.document.pdfFileName,
        ),
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Impossible de préparer le document pour le moment.')),
        );
      }
    } finally {
      if (mounted) setState(() => _isPreparingDownload = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final doc = widget.document;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.chevron_left),
          onPressed: () => context.pop(),
        ),
        title: Text(doc.title, style: AppTypography.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          if (doc.subtitle.isNotEmpty) ...[
            Text(doc.subtitle, style: AppTypography.bodySecondary.copyWith(height: 1.5)),
            const SizedBox(height: 14),
          ],
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.primaryMuted,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              doc.versionLabel,
              style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.primary),
            ),
          ),
          const SizedBox(height: 20),

          AhiyoyoButton(
            text: _isPreparingDownload ? 'Préparation du PDF...' : 'Télécharger le PDF',
            variant: AhiyoyoButtonVariant.outline,
            isLoading: _isPreparingDownload,
            icon: const Icon(LucideIcons.download, size: 18),
            onPressed: _isPreparingDownload ? null : _downloadPdf,
          ),
          const SizedBox(height: 36),

          // Sommaire cliquable
          const Text('Sommaire', style: AppTypography.titleSmall),
          const SizedBox(height: 12),
          AhiyoyoCard(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              children: [
                for (final section in doc.sections) ...[
                  InkWell(
                    onTap: () => _scrollToSection(section.id),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      child: Row(
                        children: [
                          Expanded(child: Text(section.title, style: AppTypography.bodyMedium)),
                          const Icon(LucideIcons.chevron_right, size: 16, color: AppColors.textTertiary),
                        ],
                      ),
                    ),
                  ),
                  if (section != doc.sections.last) const Divider(color: AppColors.border, height: 1),
                ],
              ],
            ),
          ),
          const SizedBox(height: 44),

          for (final section in doc.sections) ...[
            Container(key: _sectionKeys[section.id]),
            Text(section.title, style: AppTypography.titleLarge.copyWith(fontSize: 19)),
            const SizedBox(height: 18),
            for (final block in section.blocks) ...[
              _LegalBlockView(block: block),
              const SizedBox(height: 18),
            ],
            if (section != doc.sections.last) ...[
              const SizedBox(height: 12),
              const Divider(color: AppColors.border),
              const SizedBox(height: 36),
            ],
          ],
        ],
      ),
    );
  }
}

class _LegalBlockView extends StatelessWidget {
  final LegalBlock block;

  const _LegalBlockView({required this.block});

  @override
  Widget build(BuildContext context) {
    switch (block.type) {
      case LegalBlockType.heading:
        return Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 4),
          child: Text(block.text!, style: AppTypography.titleSmall.copyWith(color: AppColors.primary)),
        );

      case LegalBlockType.paragraph:
        return Text(block.text!, style: AppTypography.bodyMedium.copyWith(height: 1.6));

      case LegalBlockType.bullets:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final item in block.items!)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 8, right: 10),
                      child: Icon(Icons.circle, size: 4, color: AppColors.textSecondary),
                    ),
                    Expanded(child: Text(item, style: AppTypography.bodyMedium.copyWith(height: 1.6))),
                  ],
                ),
              ),
          ],
        );

      case LegalBlockType.numbered:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int i = 0; i < block.items!.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 24,
                      child: Text(
                        '${i + 1}.',
                        style: AppTypography.bodyMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(child: Text(block.items![i], style: AppTypography.bodyMedium.copyWith(height: 1.6))),
                  ],
                ),
              ),
          ],
        );

      case LegalBlockType.table:
        return Column(
          children: [
            for (final row in block.tableRows!) ...[
              AhiyoyoCard(
                backgroundColor: AppColors.surfaceElevated,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 0; i < row.length; i++) ...[
                      Text(
                        block.tableHeaders![i],
                        style: AppTypography.captionTertiary.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(row[i], style: AppTypography.bodySecondary.copyWith(height: 1.5)),
                      if (i != row.length - 1) const SizedBox(height: 14),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 14),
            ],
          ],
        );
    }
  }
}
