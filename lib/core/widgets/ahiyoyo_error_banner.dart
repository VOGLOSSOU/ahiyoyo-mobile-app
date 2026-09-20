import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';

/// Bandeau d'erreur globale utilisé dans les formulaires (auth, etc.).
class AhiyoyoErrorBanner extends StatelessWidget {
  final String message;

  const AhiyoyoErrorBanner({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.statusErrorBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.statusError.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(LucideIcons.circle_alert, color: AppColors.statusError, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: AppTypography.bodySecondary.copyWith(color: AppColors.statusError),
            ),
          ),
        ],
      ),
    );
  }
}
