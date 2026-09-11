import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/ahiyoyo_badge.dart';
import '../../../../core/widgets/ahiyoyo_card.dart';

class ParcelsScreen extends StatelessWidget {
  const ParcelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes colis', style: AppTypography.titleMedium),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.plus, color: AppColors.primary),
            onPressed: () {},
          ),
        ],
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
                    Text('AHI-849204', style: AppTypography.titleSmall.copyWith(color: AppColors.primary)),
                    const AhiyoyoBadge(label: 'En transit', variant: AhiyoyoBadgeVariant.submitted),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('Guangzhou ➔ Cotonou • Maritime (1.2 CBM)', style: AppTypography.bodySecondary),
                const SizedBox(height: 12),
                const Divider(color: AppColors.border),
                const SizedBox(height: 8),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Arrivée estimée : 28/09/2026', style: AppTypography.caption),
                    Icon(LucideIcons.chevron_right, size: 16, color: AppColors.textSecondary),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
