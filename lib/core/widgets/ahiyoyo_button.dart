import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';

enum AhiyoyoButtonVariant {
  primary,
  secondary,
  outline,
  destructive,
}

/// Bouton standard Ahiyoyo respectant la charte graphique :
/// - Primaire : doré #fdc354 avec texte noir gras et coins arrondis (12px)
/// - Secondaire : fond sombre surface avec bordure
/// - Outline : fond transparent et bordure fine
/// - Destructif : couleur d'erreur rouge
class AhiyoyoButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AhiyoyoButtonVariant variant;
  final bool isLoading;
  final Widget? icon;
  final double? width;
  final double height;

  const AhiyoyoButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = AhiyoyoButtonVariant.primary,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height = 48,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = onPressed != null && !isLoading;

    Color backgroundColor;
    Color foregroundColor;
    BorderSide borderSide = BorderSide.none;

    switch (variant) {
      case AhiyoyoButtonVariant.primary:
        backgroundColor = isEnabled ? AppColors.primary : AppColors.primary.withValues(alpha: 0.4);
        foregroundColor = AppColors.onPrimary;
        break;
      case AhiyoyoButtonVariant.secondary:
        backgroundColor = isEnabled ? AppColors.surface : AppColors.surface.withValues(alpha: 0.4);
        foregroundColor = AppColors.textPrimary;
        borderSide = const BorderSide(color: AppColors.border, width: 1);
        break;
      case AhiyoyoButtonVariant.outline:
        backgroundColor = Colors.transparent;
        foregroundColor = isEnabled ? AppColors.primary : AppColors.primary.withValues(alpha: 0.4);
        borderSide = BorderSide(color: foregroundColor, width: 1);
        break;
      case AhiyoyoButtonVariant.destructive:
        backgroundColor = isEnabled ? AppColors.statusErrorBg : AppColors.statusErrorBg.withValues(alpha: 0.4);
        foregroundColor = AppColors.statusError;
        borderSide = BorderSide(color: isEnabled ? AppColors.statusError : AppColors.statusError.withValues(alpha: 0.4), width: 1);
        break;
    }

    final TextStyle textStyle = variant == AhiyoyoButtonVariant.primary
        ? AppTypography.buttonPrimary.copyWith(color: foregroundColor)
        : AppTypography.buttonSecondary.copyWith(color: foregroundColor);

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: isEnabled ? onPressed : null,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: borderSide != BorderSide.none ? Border.fromBorderSide(borderSide) : null,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.center,
            child: isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) ...[
                        icon!,
                        const SizedBox(width: 8),
                      ],
                      Flexible(
                        child: Text(
                          text,
                          style: textStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
