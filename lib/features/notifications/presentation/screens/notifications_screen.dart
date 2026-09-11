import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/ahiyoyo_card.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications', style: AppTypography.titleMedium),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Tout lire', style: TextStyle(color: AppColors.primary, fontSize: 13)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AhiyoyoCard(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.statusSubmittedBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(LucideIcons.package, color: AppColors.statusSubmitted, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Colis reçu à l\'entrepôt',
                        style: AppTypography.titleSmall,
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Votre colis AHI-849204 a bien été réceptionné à Guangzhou.',
                        style: AppTypography.bodySecondary,
                      ),
                      const SizedBox(height: 6),
                      Text('Il y a 2 heures', style: AppTypography.captionTertiary),
                    ],
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
