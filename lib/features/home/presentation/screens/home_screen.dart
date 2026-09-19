import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/providers/app_providers.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/ahiyoyo_badge.dart';
import '../../../../core/widgets/ahiyoyo_button.dart';
import '../../../../core/widgets/ahiyoyo_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isAuthenticated = ref.watch(isAuthenticatedProvider);

    return Scaffold(
      appBar: AppBar(
        title: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.asset(
            'ressources/ahiyoyo-logo.jpg',
            width: 84,
            height: 32,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => const Text(
              'AHIYOYO',
              style: AppTypography.titleMedium,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.bell, size: 22),
            onPressed: () => context.push(AppRoutes.notifications),
          ),
          IconButton(
            icon: Icon(
              isAuthenticated ? LucideIcons.user_round : LucideIcons.user,
              size: 22,
            ),
            onPressed: () {
              if (isAuthenticated) {
                context.go(AppRoutes.profile);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Connexion bientôt disponible')),
                );
              }
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bandeau de bienvenue / CGU info
            AhiyoyoCard(
              backgroundColor: AppColors.surface,
              borderColor: AppColors.border,
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  const Icon(LucideIcons.info, color: AppColors.primary, size: 20),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Bienvenue sur Ahiyoyo V2. Enregistrez et suivez vos colis en toute simplicité.',
                      style: AppTypography.caption,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Bloc de suivi rapide
            const Text('Suivi de colis ou commande', style: AppTypography.titleSmall),
            const SizedBox(height: 8),
            AhiyoyoCard(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Entrez un N° de suivi (ex. AHI-123456)',
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        fillColor: Colors.transparent,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 42,
                    child: ElevatedButton(
                      onPressed: () => context.push(AppRoutes.tracking),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.onPrimary,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Row(
                        children: [
                          Icon(LucideIcons.search, size: 16),
                          SizedBox(width: 6),
                          Text('Suivre', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Accès rapides
            const Text('Actions rapides', style: AppTypography.titleSmall),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _QuickActionCard(
                    icon: LucideIcons.package_plus,
                    title: 'Nouvelle expédition',
                    subtitle: 'Bateau ou avion',
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _QuickActionCard(
                    icon: LucideIcons.file_text,
                    title: 'Demande de devis',
                    subtitle: 'Achat & Sourcing',
                    onTap: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Offre groupage en cours (Mise en avant)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Groupage maritime en cours', style: AppTypography.titleSmall),
                const AhiyoyoBadge(label: 'Actif', variant: AhiyoyoBadgeVariant.success),
              ],
            ),
            const SizedBox(height: 10),
            AhiyoyoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(LucideIcons.ship, color: AppColors.primary, size: 20),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Chine (Guangzhou) ➔ Cotonou (Bénin)',
                          style: AppTypography.titleSmall,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
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
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Tarif actuel au CBM', style: AppTypography.captionTertiary),
                          const SizedBox(height: 2),
                          Text('265 000 FCFA', style: AppTypography.titleSmall.copyWith(color: AppColors.primary)),
                        ],
                      ),
                      SizedBox(
                        width: 140,
                        height: 38,
                        child: AhiyoyoButton(
                          text: 'Participer',
                          height: 38,
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AhiyoyoCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryMuted,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: AppColors.primary),
          ),
          const SizedBox(height: 12),
          Text(title, style: AppTypography.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 2),
          Text(subtitle, style: AppTypography.captionTertiary, maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
