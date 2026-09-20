import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/ahiyoyo_badge.dart';
import '../../../../core/widgets/ahiyoyo_button.dart';
import '../../../../core/widgets/ahiyoyo_card.dart';

/// Détail d'une annonce de groupage maritime (données de démonstration en
/// attendant le branchement API du Lot 2).
class SeaGroupageDetailScreen extends StatelessWidget {
  final String id;

  const SeaGroupageDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.arrow_left),
          onPressed: () => context.pop(),
        ),
        title: const Text('Groupage maritime', style: AppTypography.titleMedium),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AhiyoyoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(LucideIcons.ship, color: AppColors.primary, size: 22),
                        const SizedBox(width: 8),
                        const Text('Chine (Guangzhou) ➔ Cotonou (Bénin)', style: AppTypography.titleSmall),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const AhiyoyoBadge(label: 'Actif', variant: AhiyoyoBadgeVariant.success),
                const SizedBox(height: 16),
                const Divider(color: AppColors.border),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Remplissage du conteneur (68 CBM)', style: AppTypography.caption),
                    Text('65%', style: AppTypography.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: const LinearProgressIndicator(
                    value: 0.65,
                    minHeight: 8,
                    backgroundColor: AppColors.surfaceElevated,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(color: AppColors.border),
                const SizedBox(height: 12),
                const Text('Départ estimé', style: AppTypography.captionTertiary),
                const SizedBox(height: 2),
                const Text('30/09/2026', style: AppTypography.bodyMedium),
                const SizedBox(height: 12),
                const Text('Clôture des réservations', style: AppTypography.captionTertiary),
                const SizedBox(height: 2),
                const Text('25/09/2026', style: AppTypography.bodyMedium),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const Text('Barème tarifaire dégressif', style: AppTypography.titleSmall),
          const SizedBox(height: 10),
          AhiyoyoCard(
            child: Column(
              children: [
                _TariffRow(range: '0,5 à 1 CBM', price: '285 000 FCFA / CBM'),
                Divider(color: AppColors.border, height: 24),
                _TariffRow(range: '1 à 3 CBM', price: '265 000 FCFA / CBM'),
                Divider(color: AppColors.border, height: 24),
                _TariffRow(range: '3 CBM et plus', price: '240 000 FCFA / CBM', highlighted: true),
              ],
            ),
          ),
          const SizedBox(height: 24),
          AhiyoyoButton(
            text: 'Participer à ce groupage',
            onPressed: () {},
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _TariffRow extends StatelessWidget {
  final String range;
  final String price;
  final bool highlighted;

  const _TariffRow({required this.range, required this.price, this.highlighted = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(range, style: AppTypography.bodySecondary),
        Text(
          price,
          style: AppTypography.bodyMedium.copyWith(
            color: highlighted ? AppColors.primary : AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
