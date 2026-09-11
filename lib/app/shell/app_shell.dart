import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import '../router/app_routes.dart';
import '../theme/app_colors.dart';

/// Shell principal hébergeant la Bottom Navigation Bar pour les 5 onglets clés.
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
    if (location.startsWith(AppRoutes.notifications)) {
      return 3;
    }
    if (location.startsWith(AppRoutes.profile)) {
      return 4;
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
        context.go(AppRoutes.notifications);
        break;
      case 4:
        context.go(AppRoutes.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.border, width: 0.8)),
        ),
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) => _onItemTapped(index, context),
          backgroundColor: AppColors.background,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          selectedFontSize: 11.5,
          unselectedFontSize: 11.5,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.house, size: 20),
              activeIcon: Icon(LucideIcons.house, size: 20, color: AppColors.primary),
              label: 'Accueil',
            ),
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.package, size: 20),
              activeIcon: Icon(LucideIcons.package, size: 20, color: AppColors.primary),
              label: 'Mes colis',
            ),
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.truck, size: 20),
              activeIcon: Icon(LucideIcons.truck, size: 20, color: AppColors.primary),
              label: 'Commandes',
            ),
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.bell, size: 20),
              activeIcon: Icon(LucideIcons.bell, size: 20, color: AppColors.primary),
              label: 'Alertes',
            ),
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.user, size: 20),
              activeIcon: Icon(LucideIcons.user, size: 20, color: AppColors.primary),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}
