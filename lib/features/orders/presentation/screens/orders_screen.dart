import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/ahiyoyo_badge.dart';
import '../../../../core/widgets/ahiyoyo_card.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Devis & Commandes', style: AppTypography.titleMedium),
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
                    Text('CMD-2026-0042', style: AppTypography.titleSmall.copyWith(color: AppColors.primary)),
                    const AhiyoyoBadge(label: 'En préparation', variant: AhiyoyoBadgeVariant.processing),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('Machines industrielles et outillage', style: AppTypography.bodySecondary),
                const SizedBox(height: 4),
                Text('Montant : 1 450 000 FCFA', style: AppTypography.titleSmall.copyWith(fontSize: 15)),
                const SizedBox(height: 12),
                const Divider(color: AppColors.border),
                const SizedBox(height: 8),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Suivre l\'acheminement', style: AppTypography.caption),
                    Icon(LucideIcons.arrow_right, size: 16, color: AppColors.primary),
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
