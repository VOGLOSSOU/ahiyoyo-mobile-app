import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import '../router/app_routes.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Shell principal hébergeant la navbar à 4 onglets + le bouton central "+"
/// (bouton d'actions rapides, pas un onglet de navigation).
class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith(AppRoutes.parcels)) {
      return 1;
    }
    if (location.startsWith(AppRoutes.orders)) {
      return 2;
    }
    if (location.startsWith(AppRoutes.profile)) {
      return 3;
    }
    return 0; // Home par défaut
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
        break;
      case 1:
        context.go(AppRoutes.parcels);
        break;
      case 2:
        context.go(AppRoutes.orders);
        break;
      case 3:
        context.go(AppRoutes.profile);
        break;
    }
  }

  void _showQuickActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              _QuickActionTile(
                icon: LucideIcons.package_plus,
                label: 'Enregistrer un colis',
                onTap: () => Navigator.of(sheetContext).pop(),
              ),
              const SizedBox(height: 8),
              _QuickActionTile(
                icon: LucideIcons.file_text,
                label: 'Demander un devis',
                onTap: () => Navigator.of(sheetContext).pop(),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);

    return Scaffold(
      body: child,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showQuickActions(context),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: 2,
        shape: const CircleBorder(),
        child: const Icon(LucideIcons.plus, size: 26),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: AppColors.background,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        padding: EdgeInsets.zero,
        child: SizedBox(
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: LucideIcons.house,
                label: 'Accueil',
                selected: selectedIndex == 0,
                onTap: () => _onItemTapped(0, context),
              ),
              _NavItem(
                icon: LucideIcons.package,
                label: 'Mes colis',
                selected: selectedIndex == 1,
                onTap: () => _onItemTapped(1, context),
              ),
              // Espace réservé à l'encoche du bouton central "+".
              const SizedBox(width: 48),
              _NavItem(
                icon: LucideIcons.truck,
                label: 'Commandes',
                selected: selectedIndex == 2,
                onTap: () => _onItemTapped(2, context),
              ),
              _NavItem(
                icon: LucideIcons.user,
                label: 'Profil',
                selected: selectedIndex == 3,
                onTap: () => _onItemTapped(3, context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = selected ? AppColors.primary : AppColors.textSecondary;
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(fontSize: 11, color: color, fontWeight: selected ? FontWeight.w600 : FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceElevated,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryMuted,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 20, color: AppColors.primary),
              ),
              const SizedBox(width: 14),
              Expanded(child: Text(label, style: AppTypography.bodyMedium)),
              const Icon(LucideIcons.chevron_right, size: 18, color: AppColors.textTertiary),
            ],
          ),
        ),
      ),
    );
  }
}
