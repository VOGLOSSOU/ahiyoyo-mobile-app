import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/ahiyoyo_button.dart';
import '../../../../core/widgets/ahiyoyo_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Profil', style: AppTypography.titleMedium),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Carte Utilisateur
          AhiyoyoCard(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.primaryMuted,
                  child: const Icon(LucideIcons.user, color: AppColors.primary, size: 28),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nathan VOGLOSSOU', style: AppTypography.titleMedium),
                      SizedBox(height: 2),
                      Text('nathan@example.com', style: AppTypography.caption),
                      SizedBox(height: 2),
                      Text('+229 97 00 00 00', style: AppTypography.captionTertiary),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Carte de Parrainage ("Gagner de l'argent")
          AhiyoyoCard(
            backgroundColor: AppColors.surfaceElevated,
            borderColor: AppColors.primary.withValues(alpha: 0.4),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(LucideIcons.gift, color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    const Text('Parrainage • Gagner de l\'argent', style: AppTypography.titleSmall),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Partagez votre code personnel avec vos proches et gagnez des commissions sur leurs expéditions.',
                  style: AppTypography.bodySecondary,
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'AHI-84291',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          color: AppColors.primary,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(LucideIcons.copy, size: 18, color: AppColors.primary),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Code de parrainage copié !')),
                          );
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Options
          _SettingsTile(
            icon: LucideIcons.map_pin,
            title: 'Tarifs & Adresses des entrepôts',
            onTap: () => context.push(AppRoutes.tariffs),
          ),
          _SettingsTile(
            icon: LucideIcons.calculator,
            title: 'Calculateur de fret',
            onTap: () {},
          ),
          _SettingsTile(
            icon: LucideIcons.shield_check,
            title: 'Sécurité & Mot de passe',
            onTap: () {},
          ),
          _SettingsTile(
            icon: LucideIcons.file_text,
            title: 'Conditions Générales d\'Utilisation',
            onTap: () {},
          ),
          const SizedBox(height: 24),

          AhiyoyoButton(
            text: 'Déconnexion',
            variant: AhiyoyoButtonVariant.destructive,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: AhiyoyoCard(
        onTap: onTap,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.textSecondary),
            const SizedBox(width: 14),
            Expanded(child: Text(title, style: AppTypography.bodyMedium)),
            const Icon(LucideIcons.chevron_right, size: 18, color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }
}
