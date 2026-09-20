import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/providers/app_providers.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
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
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Annonces en cours (groupage maritime / aérien) façon stories
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _StoryCircle(
                      icon: LucideIcons.ship,
                      label: 'Groupage maritime',
                      onTap: () => context.push('/sea-groupage/current'),
                    ),
                    const SizedBox(width: 16),
                    _StoryCircle(
                      icon: LucideIcons.plane,
                      label: 'Groupage aérien',
                      onTap: () => context.push('/air-offers/current'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Cercle "story" (façon Instagram) mettant en avant une annonce de
/// groupage en cours, avec anneau dégradé aux couleurs Ahiyoyo.
class _StoryCircle extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _StoryCircle({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 76,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: SweepGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primaryDark,
                    AppColors.primary,
                  ],
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.background,
                ),
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.surface,
                  child: Icon(icon, color: AppColors.primary, size: 26),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: AppTypography.captionTertiary,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
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
