import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../app/theme/app_colors.dart';

enum AhiyoyoBadgeVariant {
  pending,
  submitted,
  processing,
  success,
  error,
  neutral,
}

/// Pastille de statut (Pill badge) avec fond teinté à faible opacité,
/// texte coloré et icône contextuelle fine (Lucide).
class AhiyoyoBadge extends StatelessWidget {
  final String label;
  final AhiyoyoBadgeVariant variant;
  final IconData? customIcon;

  const AhiyoyoBadge({
    super.key,
    required this.label,
    this.variant = AhiyoyoBadgeVariant.neutral,
    this.customIcon,
  });

  @override
  Widget build(BuildContext context) {
    Color textColor;
    Color bgColor;
    IconData defaultIcon;

    switch (variant) {
      case AhiyoyoBadgeVariant.pending:
        textColor = AppColors.statusPending;
        bgColor = AppColors.statusPendingBg;
        defaultIcon = LucideIcons.clock;
        break;
      case AhiyoyoBadgeVariant.submitted:
        textColor = AppColors.statusSubmitted;
        bgColor = AppColors.statusSubmittedBg;
        defaultIcon = LucideIcons.send;
        break;
      case AhiyoyoBadgeVariant.processing:
        textColor = AppColors.statusProcessing;
        bgColor = AppColors.statusProcessingBg;
        defaultIcon = LucideIcons.loader;
        break;
      case AhiyoyoBadgeVariant.success:
        textColor = AppColors.statusSuccess;
        bgColor = AppColors.statusSuccessBg;
        defaultIcon = LucideIcons.circle_check;
        break;
      case AhiyoyoBadgeVariant.error:
        textColor = AppColors.statusError;
        bgColor = AppColors.statusErrorBg;
        defaultIcon = LucideIcons.circle_alert;
        break;
      case AhiyoyoBadgeVariant.neutral:
        textColor = AppColors.statusNeutral;
        bgColor = AppColors.statusNeutralBg;
        defaultIcon = LucideIcons.file_text;
        break;
    }

    final IconData icon = customIcon ?? defaultIcon;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(999), // Pill shape
        border: Border.all(color: textColor.withValues(alpha: 0.3), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: textColor),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: textColor,
              letterSpacing: -0.1,
            ),
          ),
        ],
      ),
    );
  }
}
