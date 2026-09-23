import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/ahiyoyo_badge.dart';
import '../../../../core/widgets/ahiyoyo_card.dart';
import '../../domain/tracking_result.dart';
import '../../domain/tracking_timeline.dart';
import '../controllers/tracking_controller.dart';

/// Écran public de suivi colis/commande — accessible sans compte.
/// Contrat : docs-from-api/04_SUIVI_PUBLIC_COLIS_COMMANDES_MOBILE.md
class TrackingScreen extends ConsumerStatefulWidget {
  final String? initialQuery;

  const TrackingScreen({super.key, this.initialQuery});

  @override
  ConsumerState<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends ConsumerState<TrackingScreen> {
  late final TextEditingController _queryController = TextEditingController(text: widget.initialQuery ?? '');

  @override
  void initState() {
    super.initState();
    final initial = widget.initialQuery?.trim();
    if (initial != null && initial.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(trackingControllerProvider.notifier).search(initial);
      });
    }
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  void _search() {
    FocusScope.of(context).unfocus();
    ref.read(trackingControllerProvider.notifier).search(_queryController.text);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(trackingControllerProvider);
    final isLoading = state is TrackingLoading;
    final canSearch = _queryController.text.trim().isNotEmpty && !isLoading;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.chevron_left),
          onPressed: () => context.pop(),
        ),
        title: const Text('Suivi en direct', style: AppTypography.titleMedium),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AhiyoyoCard(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _queryController,
                    onChanged: (_) => setState(() {}),
                    onSubmitted: (_) => _search(),
                    textInputAction: TextInputAction.search,
                    decoration: const InputDecoration(
                      hintText: 'N° de suivi ou référence de commande',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      fillColor: Colors.transparent,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 42,
                  child: ElevatedButton(
                    onPressed: canSearch ? _search : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.4),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.onPrimary),
                          )
                        : const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(LucideIcons.search, size: 16),
                              SizedBox(width: 6),
                              Text('Suivre', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          switch (state) {
            TrackingIdle() => const _HintState(),
            TrackingLoading() => const SizedBox.shrink(),
            TrackingNotFound() => const _MessageState(
                icon: LucideIcons.search_x,
                message: 'Aucun colis ni aucune commande ne correspond à cette référence. Vérifiez le numéro puis réessayez.',
              ),
            TrackingError(:final message) => _MessageState(
                icon: LucideIcons.circle_alert,
                message: message,
                actionLabel: 'Réessayer',
                onAction: _search,
              ),
            TrackingSuccess(:final result) => switch (result) {
                ColisTrackingResult() => _ColisResultView(colis: result),
                CommandeTrackingResult() => _CommandeResultView(commande: result),
              },
          },
        ],
      ),
    );
  }
}

class _HintState extends StatelessWidget {
  const _HintState();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Icon(LucideIcons.package_search, size: 48, color: AppColors.textTertiary),
          SizedBox(height: 12),
          Text(
            'Entrez un numéro de suivi Ahiyoyo, un numéro de transporteur ou une référence de commande.',
            style: AppTypography.bodySecondary,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _MessageState extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _MessageState({required this.icon, required this.message, this.actionLabel, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Icon(icon, size: 48, color: AppColors.textTertiary),
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
      ),
    );
  }
}

AhiyoyoBadgeVariant _colisBadgeVariant(String status) {
  switch (status) {
    case 'EN_ATTENTE_CONFIRMATION':
    case 'EN_ATTENTE_RETRAIT':
      return AhiyoyoBadgeVariant.pending;
    case 'RECU_AU_CARGO':
    case 'ARRIVE_A_DESTINATION':
      return AhiyoyoBadgeVariant.submitted;
    case 'ENVOI_EN_COURS':
    case 'EN_TRANSIT':
      return AhiyoyoBadgeVariant.processing;
    case 'RETRAIT_EFFECTUE':
    case 'LIVRE':
      return AhiyoyoBadgeVariant.success;
    case 'ANNULE':
      return AhiyoyoBadgeVariant.error;
    default:
      return AhiyoyoBadgeVariant.neutral;
  }
}

AhiyoyoBadgeVariant _commandeBadgeVariant(String statut) {
  switch (statut) {
    case 'EN_ATTENTE_VALIDATION':
    case 'EN_ATTENTE_PAIEMENT':
      return AhiyoyoBadgeVariant.pending;
    case 'ENVOYEE_AU_CARGO':
    case 'RECUE_AU_CARGO':
      return AhiyoyoBadgeVariant.submitted;
    case 'COMMANDE_EN_COURS':
    case 'ENVOI_EN_COURS':
    case 'FORMALITES_EN_COURS':
      return AhiyoyoBadgeVariant.processing;
    case 'DISPONIBLE_ENTREPOT':
      return AhiyoyoBadgeVariant.success;
    default:
      return AhiyoyoBadgeVariant.neutral;
  }
}

Future<void> _copyToClipboard(BuildContext context, String text) async {
  await Clipboard.setData(ClipboardData(text: text));
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Référence copiée.')));
  }
}

Future<void> _shareText(String text) async {
  await SharePlus.instance.share(ShareParams(text: text));
}

Future<void> _openUrl(String url) async {
  await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
}

class _ReferenceHeader extends StatelessWidget {
  final String reference;
  final String badgeLabel;
  final AhiyoyoBadgeVariant badgeVariant;

  const _ReferenceHeader({required this.reference, required this.badgeLabel, required this.badgeVariant});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            reference,
            style: AppTypography.titleLarge.copyWith(fontSize: 20, color: AppColors.primary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        IconButton(
          icon: const Icon(LucideIcons.copy, size: 18, color: AppColors.textSecondary),
          onPressed: () => _copyToClipboard(context, reference),
        ),
        IconButton(
          icon: const Icon(LucideIcons.share_2, size: 18, color: AppColors.textSecondary),
          onPressed: () => _shareText(reference),
        ),
        AhiyoyoBadge(label: badgeLabel, variant: badgeVariant),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.caption),
          Flexible(child: Text(value, style: AppTypography.bodyMedium, textAlign: TextAlign.end)),
        ],
      ),
    );
  }
}

class _ColisResultView extends StatelessWidget {
  final ColisTrackingResult colis;

  const _ColisResultView({required this.colis});

  @override
  Widget build(BuildContext context) {
    final timeline = buildColisTimeline(colis.statusHistory, colis.historique);
    final quantite = colis.volumeValue != null && colis.volumeUnit != null
        ? '${colis.volumeValue} ${colis.volumeUnit}'
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AhiyoyoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ReferenceHeader(
                reference: colis.trackingNumber,
                badgeLabel: colisStatusLabel(colis.status),
                badgeVariant: _colisBadgeVariant(colis.status),
              ),
              if (colis.carrierTrackingNumber != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text('Transporteur : ${colis.carrierTrackingNumber}', style: AppTypography.captionTertiary),
                ),
              const SizedBox(height: 10),
              Text(
                '${colis.originCountry} (${colis.originCity}) ➔ ${colis.destinationCountry} (${colis.destinationCity})',
                style: AppTypography.bodySecondary,
              ),
              const Divider(color: AppColors.border, height: 24),
              _InfoRow(label: 'Mode de transport', value: shippingModeLabel(colis.shippingMode)),
              if (quantite != null) _InfoRow(label: 'Quantité déclarée', value: quantite),
              _InfoRow(label: 'Enregistré le', value: DateFormatter.formatDate(colis.createdAt)),
              if (colis.estimatedDeliveryAt != null)
                _InfoRow(label: 'Livraison estimée', value: DateFormatter.formatDate(colis.estimatedDeliveryAt)),
              if (colis.documentsUrl != null) ...[
                const SizedBox(height: 14),
                OutlinedButton.icon(
                  onPressed: () => _openUrl(colis.documentsUrl!),
                  icon: const Icon(LucideIcons.file_text, size: 16),
                  label: const Text('Consulter le document'),
                  style: OutlinedButton.styleFrom(foregroundColor: AppColors.primary, side: const BorderSide(color: AppColors.border)),
                ),
              ],
            ],
          ),
        ),
        if (colis.articles.isNotEmpty) ...[
          const SizedBox(height: 18),
          const Text('Articles', style: AppTypography.titleSmall),
          const SizedBox(height: 10),
          for (final article in colis.articles) ...[
            _ArticleTile(article: article),
            const SizedBox(height: 10),
          ],
        ],
        const SizedBox(height: 18),
        const Text('Historique d\'acheminement', style: AppTypography.titleSmall),
        const SizedBox(height: 14),
        AhiyoyoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < timeline.steps.length; i++)
                _TimelineStep(
                  title: colisStatusLabel(timeline.steps[i].status),
                  subtitle: timeline.steps[i].commentaire ?? timeline.steps[i].adminNom,
                  fichierUrl: timeline.steps[i].fichierUrl,
                  fichierNom: timeline.steps[i].fichierNom,
                  date: DateFormatter.formatDateTime(timeline.steps[i].date),
                  isCurrent: i == timeline.steps.length - 1,
                  isLast: i == timeline.steps.length - 1 && timeline.extra.isEmpty,
                ),
            ],
          ),
        ),
        if (timeline.extra.isNotEmpty) ...[
          const SizedBox(height: 18),
          const Text('Mises à jour détaillées', style: AppTypography.titleSmall),
          const SizedBox(height: 14),
          AhiyoyoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < timeline.extra.length; i++)
                  _TimelineStep(
                    title: colisStatusLabel(timeline.extra[i].statut),
                    subtitle: timeline.extra[i].commentaire ?? timeline.extra[i].adminNom,
                    fichierUrl: timeline.extra[i].fichierUrl,
                    fichierNom: timeline.extra[i].fichierNom,
                    date: DateFormatter.formatDateTime(timeline.extra[i].date),
                    isCurrent: false,
                    isLast: i == timeline.extra.length - 1,
                  ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _CommandeResultView extends StatelessWidget {
  final CommandeTrackingResult commande;

  const _CommandeResultView({required this.commande});

  @override
  Widget build(BuildContext context) {
    final facture = commande.facture;
    final ligne = facture?.ligneTarifaire;
    final steps = List<HistoriqueEntry>.from(commande.historique)..sort((a, b) => a.date.compareTo(b.date));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AhiyoyoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ReferenceHeader(
                reference: commande.reference,
                badgeLabel: commandeStatusLabel(commande.statut),
                badgeVariant: _commandeBadgeVariant(commande.statut),
              ),
              const Divider(color: AppColors.border, height: 24),
              _InfoRow(label: 'Créée le', value: DateFormatter.formatDate(commande.createdAt)),
              if (commande.paiementConfirmeAt != null)
                _InfoRow(label: 'Paiement confirmé le', value: DateFormatter.formatDate(commande.paiementConfirmeAt)),
            ],
          ),
        ),
        if (facture != null) ...[
          const SizedBox(height: 18),
          const Text('Facture', style: AppTypography.titleSmall),
          const SizedBox(height: 10),
          AhiyoyoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (facture.numero != null) _InfoRow(label: 'Numéro', value: facture.numero!),
                if (facture.nomArticle != null) _InfoRow(label: 'Article', value: facture.nomArticle!),
                if (facture.montantTotal != null)
                  _InfoRow(label: 'Montant total', value: CurrencyFormatter.format(facture.montantTotal)),
                if (facture.delaiEstimatif != null) _InfoRow(label: 'Délai estimatif', value: facture.delaiEstimatif!),
                if (ligne != null) ...[
                  const Divider(color: AppColors.border, height: 24),
                  Text(
                    '${ligne.paysDepart} (${ligne.villeDepart}) ➔ ${ligne.paysDestination} (${ligne.villeDestination})',
                    style: AppTypography.bodySecondary,
                  ),
                  const SizedBox(height: 4),
                  Text(shippingModeLabel(ligne.modeTransport), style: AppTypography.captionTertiary),
                ],
              ],
            ),
          ),
        ],
        const SizedBox(height: 18),
        const Text('Historique', style: AppTypography.titleSmall),
        const SizedBox(height: 14),
        AhiyoyoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: steps.isEmpty
                ? [
                    _TimelineStep(
                      title: commandeStatusLabel(commande.statut),
                      subtitle: null,
                      fichierUrl: null,
                      fichierNom: null,
                      date: DateFormatter.formatDateTime(commande.createdAt),
                      isCurrent: true,
                      isLast: true,
                    ),
                  ]
                : [
                    for (var i = 0; i < steps.length; i++)
                      _TimelineStep(
                        title: commandeStatusLabel(steps[i].statut),
                        subtitle: steps[i].commentaire ?? steps[i].adminNom,
                        fichierUrl: steps[i].fichierUrl,
                        fichierNom: steps[i].fichierNom,
                        date: DateFormatter.formatDateTime(steps[i].date),
                        isCurrent: i == steps.length - 1,
                        isLast: i == steps.length - 1,
                      ),
                  ],
          ),
        ),
      ],
    );
  }
}

class _ArticleTile extends StatelessWidget {
  final TrackingArticle article;

  const _ArticleTile({required this.article});

  @override
  Widget build(BuildContext context) {
    return AhiyoyoCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (article.imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: article.imageUrl!,
                width: 52,
                height: 52,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Container(
                  width: 52,
                  height: 52,
                  color: AppColors.surfaceElevated,
                  child: const Icon(LucideIcons.image_off, size: 18, color: AppColors.textTertiary),
                ),
              ),
            )
          else
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(color: AppColors.surfaceElevated, borderRadius: BorderRadius.circular(8)),
              child: const Icon(LucideIcons.package, size: 20, color: AppColors.textTertiary),
            ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(article.description, style: AppTypography.bodyMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(
                  '${article.quantity} x ${CurrencyFormatter.format(article.unitPrice)} = ${CurrencyFormatter.format(article.totalPrice)}',
                  style: AppTypography.captionTertiary,
                ),
                if (article.purchaseLink != null)
                  GestureDetector(
                    onTap: () => _openUrl(article.purchaseLink!),
                    child: const Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Text('Voir le produit', style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineStep extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? fichierUrl;
  final String? fichierNom;
  final String date;
  final bool isCurrent;
  final bool isLast;

  const _TimelineStep({
    required this.title,
    required this.subtitle,
    required this.fichierUrl,
    required this.fichierNom,
    required this.date,
    required this.isCurrent,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCurrent ? AppColors.primary : AppColors.statusSuccess,
              ),
              child: const Icon(LucideIcons.check, size: 10, color: Colors.black),
            ),
            if (!isLast) Container(width: 2, height: 48, color: AppColors.border),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.titleSmall.copyWith(color: isCurrent ? AppColors.primary : AppColors.textPrimary),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(subtitle!, style: AppTypography.caption),
                ],
                const SizedBox(height: 2),
                Text(date, style: AppTypography.captionTertiary),
                if (fichierUrl != null) ...[
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () => _openUrl(fichierUrl!),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(LucideIcons.paperclip, size: 13, color: AppColors.primary),
                        const SizedBox(width: 4),
                        Text(
                          fichierNom ?? 'Pièce jointe',
                          style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
