import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/ahiyoyo_badge.dart';
import '../../../../core/widgets/ahiyoyo_button.dart';
import '../../../../core/widgets/ahiyoyo_card.dart';

/// Détail d'une annonce de groupage aérien (données de démonstration en
/// attendant le branchement API du Lot 2).
class AirOfferDetailScreen extends StatelessWidget {
  final String id;

  const AirOfferDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.chevron_left),
          onPressed: () => context.pop(),
        ),
        title: const Text('Groupage aérien', style: AppTypography.titleMedium),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AhiyoyoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(LucideIcons.plane, color: AppColors.primary, size: 22),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text('Chine (Guangzhou) ➔ Cotonou (Bénin)', style: AppTypography.titleSmall),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const AhiyoyoBadge(label: 'Départ imminent', variant: AhiyoyoBadgeVariant.pending),
                const SizedBox(height: 16),
                const Divider(color: AppColors.border),
                const SizedBox(height: 12),
                const Text('Délai de livraison estimé', style: AppTypography.captionTertiary),
                const SizedBox(height: 2),
                const Text('7 à 10 jours', style: AppTypography.bodyMedium),
                const SizedBox(height: 12),
                const Text('Prochain vol', style: AppTypography.captionTertiary),
                const SizedBox(height: 2),
                const Text('24/09/2026', style: AppTypography.bodyMedium),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const Text('Tarification', style: AppTypography.titleSmall),
          const SizedBox(height: 10),
          AhiyoyoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Tarif au kilo', style: AppTypography.bodySecondary),
                    Text(
                      '4 500 FCFA / KG',
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Poids arrondi au kilogramme supérieur.',
                  style: AppTypography.captionTertiary,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          AhiyoyoButton(
            text: 'Réserver ma place',
            onPressed: () {},
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
