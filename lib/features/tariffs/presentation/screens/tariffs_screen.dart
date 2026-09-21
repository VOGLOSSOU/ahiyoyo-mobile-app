import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/ahiyoyo_card.dart';
import '../../domain/tariff_line.dart';
import '../providers/tariffs_providers.dart';

/// Écran public "Adresses et tarifs" — lecture seule, sans authentification.
/// Contrat détaillé : docs-from-api/MOBILE_GUIDE_TARIFS_ADRESSES.md
class TariffsScreen extends ConsumerStatefulWidget {
  const TariffsScreen({super.key});

  @override
  ConsumerState<TariffsScreen> createState() => _TariffsScreenState();
}

class _TariffsScreenState extends ConsumerState<TariffsScreen> {
  TariffFilter _filter = TariffFilter.all;

  @override
  Widget build(BuildContext context) {
    final tariffsAsync = ref.watch(tariffsProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.chevron_left),
          onPressed: () => context.pop(),
        ),
        title: const Text('Adresses & Tarifs', style: AppTypography.titleMedium),
      ),
      body: tariffsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (error, stackTrace) => _MessageState(
          icon: LucideIcons.circle_alert,
          message: error is AppException ? error.message : 'Une erreur est survenue. Réessayez.',
          actionLabel: 'Réessayer',
          onAction: () => ref.invalidate(tariffsProvider),
        ),
        data: (lines) {
          if (lines.isEmpty) {
            return const _MessageState(
              icon: LucideIcons.map_pin,
              message: 'Les tarifs seront affichés ici dès leur mise en place.',
            );
          }

          final counts = {
            for (final filter in TariffFilter.values) filter: lines.where(filter.matches).length,
          };
          final filtered = lines.where(_filter.matches).toList();

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () => ref.refresh(tariffsProvider.future),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Center(
                  child: Text(
                    'ROUTES PUBLIQUES AHIYOYO',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text('Nos adresses & tarifs d\'envoi', style: AppTypography.titleLarge),
                const SizedBox(height: 8),
                const Text(
                  'Adresses de nos entrepôts, tarifs de transport et instructions d\'envoi pour chaque route disponible.',
                  style: AppTypography.bodySecondary,
                ),
                const SizedBox(height: 24),
                _FilterRow(
                  counts: counts,
                  selected: _filter,
                  onSelect: (filter) => setState(() => _filter = filter),
                ),
                const SizedBox(height: 16),
                if (filtered.isEmpty)
                  const _MessageState(
                    icon: LucideIcons.list_filter,
                    message: 'Aucune ligne pour ce mode de transport.',
                    compact: true,
                  )
                else
                  for (final line in filtered) ...[
                    _TariffCard(line: line),
                    const SizedBox(height: 14),
                  ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  final Map<TariffFilter, int> counts;
  final TariffFilter selected;
  final ValueChanged<TariffFilter> onSelect;

  const _FilterRow({required this.counts, required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    // "Tous" reste toujours visible ; les autres filtres à 0 résultat sont masqués.
    final visibleFilters = TariffFilter.values.where((f) => f == TariffFilter.all || (counts[f] ?? 0) > 0);

    return SizedBox(
      height: 38,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (final filter in visibleFilters) ...[
            _FilterChip(
              label: '${filter.label} (${counts[filter] ?? 0})',
              selected: filter == selected,
              onTap: () => onSelect(filter),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primary : Colors.transparent,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: selected ? null : Border.all(color: AppColors.border),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: selected ? AppColors.onPrimary : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _MessageState extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool compact;

  const _MessageState({
    required this.icon,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: compact ? 32 : 48, color: AppColors.textTertiary),
        const SizedBox(height: 12),
        Text(message, style: AppTypography.bodySecondary, textAlign: TextAlign.center),
        if (actionLabel != null) ...[
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: onAction,
            style: OutlinedButton.styleFrom(foregroundColor: AppColors.primary, side: const BorderSide(color: AppColors.primary)),
            child: Text(actionLabel!),
          ),
        ],
      ],
    );

    if (compact) {
      return Padding(padding: const EdgeInsets.symmetric(vertical: 24), child: content);
    }
    return Center(child: Padding(padding: const EdgeInsets.all(32), child: content));
  }
}

class _TariffCard extends StatefulWidget {
  final TariffLine line;

  const _TariffCard({required this.line});

  @override
  State<_TariffCard> createState() => _TariffCardState();
}

class _TariffCardState extends State<_TariffCard> {
  bool _addressCopied = false;
  bool _instructionsCopied = false;
  Timer? _addressResetTimer;
  Timer? _instructionsResetTimer;

  @override
  void dispose() {
    _addressResetTimer?.cancel();
    _instructionsResetTimer?.cancel();
    super.dispose();
  }

  /// `<adressePhysique>，<contactNom> <contactTelephone>` — séparateur virgule
  /// chinoise pleine largeur (intentionnel, cohérent avec le web). N'inclut
  /// que les parties présentes, sans séparateur orphelin.
  String _addressWithContact(TariffLine line) {
    final contact = [line.contactNom, line.contactTelephone]
        .whereType<String>()
        .where((e) => e.isNotEmpty)
        .join(' ');
    return [line.adressePhysique, contact.isEmpty ? null : contact]
        .whereType<String>()
        .where((e) => e.isNotEmpty)
        .join('，');
  }

  String _buildWhatsAppMessage(TariffLine line, String modeLabel) {
    final lines = <String>['AHIYOYO'];

    if (line.adressePhysique != null) {
      lines.add('');
      lines.add('Adresse de dépôt :');
      lines.add(_addressWithContact(line));
    }

    if (line.instructionsClient != null) {
      lines.add('');
      lines.add('À écrire sur le colis :');
      lines.add(line.instructionsClient!);
    }

    lines.add('');
    lines.add('Trajet : ${line.paysDepart} (${line.villeDepart}) → ${line.paysDestination} (${line.villeDestination})');
    lines.add('Mode : $modeLabel');
    if (line.categorie != null) lines.add('Service : ${line.categorie}');

    return lines.join('\n');
  }

  Future<void> _copyAddress() async {
    if (widget.line.adressePhysique == null) return;
    await Clipboard.setData(ClipboardData(text: _addressWithContact(widget.line)));
    _addressResetTimer?.cancel();
    setState(() => _addressCopied = true);
    _addressResetTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _addressCopied = false);
    });
  }

  Future<void> _copyInstructions() async {
    final instructions = widget.line.instructionsClient;
    if (instructions == null) return;
    await Clipboard.setData(ClipboardData(text: instructions));
    _instructionsResetTimer?.cancel();
    setState(() => _instructionsCopied = true);
    _instructionsResetTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _instructionsCopied = false);
    });
  }

  Future<void> _shareOnWhatsApp(String modeLabel) async {
    final text = _buildWhatsAppMessage(widget.line, modeLabel);
    final uri = Uri.parse(
      'https://api.whatsapp.com/send/?text=${Uri.encodeComponent(text)}&type=custom_url&app_absent=0',
    );
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _callContact(String phone) async {
    await launchUrl(Uri(scheme: 'tel', path: phone));
  }

  @override
  Widget build(BuildContext context) {
    final line = widget.line;
    final modeInfo = transportModeInfo(line);
    final minimum = minimumForMode(line.modeTransport);

    return AhiyoyoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _Badge(icon: modeInfo.icon, label: modeInfo.label, filled: true),
              if (minimum != null) _Badge(label: 'Minimum $minimum'),
              if (line.categorie != null) _Badge(label: line.categorie!),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${line.paysDepart}, ${line.villeDepart} → ${line.paysDestination}, ${line.villeDestination}',
                  style: AppTypography.titleSmall,
                ),
              ),
            ],
          ),
          if (line.tarifParKg != null || line.tarifParCbm != null || line.delaiJours != null) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                if (line.tarifParKg != null)
                  _StatItem(label: 'Tarif / kg', value: CurrencyFormatter.format(line.tarifParKg)),
                if (line.tarifParCbm != null)
                  _StatItem(label: 'Tarif / CBM', value: CurrencyFormatter.format(line.tarifParCbm)),
                if (line.delaiJours != null)
                  _StatItem(label: 'Délai', value: '${line.delaiJours} jours', accent: true),
              ],
            ),
          ],
          if (line.adressePhysique != null) ...[
            const SizedBox(height: 14),
            const Divider(color: AppColors.border),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(LucideIcons.map_pin, size: 18, color: AppColors.textSecondary),
                const SizedBox(width: 10),
                Expanded(child: Text(line.adressePhysique!, style: AppTypography.bodySecondary)),
              ],
            ),
          ],
          if (line.contactNom != null || line.contactTelephone != null) ...[
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(LucideIcons.user, size: 18, color: AppColors.textSecondary),
                const SizedBox(width: 10),
                Expanded(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (line.contactNom != null) Text(line.contactNom!, style: AppTypography.bodySecondary),
                      if (line.contactNom != null && line.contactTelephone != null) const Text('  •  ', style: AppTypography.bodySecondary),
                      if (line.contactTelephone != null)
                        GestureDetector(
                          onTap: () => _callContact(line.contactTelephone!),
                          child: Text(
                            line.contactTelephone!,
                            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
          if (line.instructionsClient != null) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(LucideIcons.info, size: 18, color: AppColors.primary),
                  const SizedBox(width: 10),
                  Expanded(child: Text(line.instructionsClient!, style: AppTypography.bodySecondary)),
                ],
              ),
            ),
          ],
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  icon: _addressCopied ? LucideIcons.check : LucideIcons.copy,
                  label: _addressCopied ? 'Copié !' : 'Copier l\'adresse',
                  enabled: line.adressePhysique != null,
                  highlighted: _addressCopied,
                  onTap: _copyAddress,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ActionButton(
                  icon: _instructionsCopied ? LucideIcons.check : LucideIcons.clipboard_copy,
                  label: _instructionsCopied ? 'Copié !' : 'Instructions',
                  enabled: line.instructionsClient != null,
                  highlighted: _instructionsCopied,
                  onTap: _copyInstructions,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ActionButton(
                  icon: LucideIcons.share_2,
                  label: 'WhatsApp',
                  enabled: true,
                  onTap: () => _shareOnWhatsApp(modeInfo.label),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool filled;

  const _Badge({required this.label, this.icon, this.filled = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: filled ? AppColors.primary : AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(999),
        border: filled ? null : Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: filled ? AppColors.onPrimary : AppColors.textSecondary),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: filled ? AppColors.onPrimary : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final bool accent;

  const _StatItem({required this.label, required this.value, this.accent = false});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.captionTertiary),
          const SizedBox(height: 2),
          Text(
            value,
            style: AppTypography.titleSmall.copyWith(color: accent ? AppColors.primary : AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool enabled;
  final bool highlighted;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.enabled,
    required this.onTap,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = !enabled
        ? AppColors.textTertiary
        : highlighted
            ? AppColors.statusSuccess
            : AppColors.textSecondary;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: enabled ? AppColors.border : AppColors.borderDark),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(height: 4),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
