import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

/// Carte conteneur standard de l'application Ahiyoyo.
/// Respecte le design web : fond neutral-800 (#262626), bordure neutral-700 (#404040),
/// coins arrondis (16px), sans ombre lourde mais avec contraste marqué.
class AhiyoyoCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderRadius;

  const AhiyoyoCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
    this.backgroundColor,
    this.borderColor,
    this.borderRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBg = backgroundColor ?? AppColors.surface;
    final effectiveBorder = borderColor ?? AppColors.border;

    Widget content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: effectiveBg,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: effectiveBorder, width: 1),
      ),
      child: child,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          splashColor: AppColors.primary.withValues(alpha: 0.1),
          highlightColor: AppColors.surfaceHover,
          child: content,
        ),
      );
    }

    return content;
  }
}
