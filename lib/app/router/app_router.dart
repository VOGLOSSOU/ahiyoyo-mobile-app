import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/orders/presentation/screens/orders_screen.dart';
import '../../features/parcels/presentation/screens/parcels_screen.dart';
import '../../features/settings/presentation/screens/profile_screen.dart';
import '../../features/tracking/presentation/screens/tracking_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../shell/app_shell.dart';
import 'app_routes.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

Future<bool> _hasCompletedOnboarding() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('ahiyoyo_cache_has_completed_onboarding');
    if (raw == null) return false;
    final decoded = jsonDecode(raw);
    return decoded['data'] == true;
  } catch (_) {
    return false;
  }
}

/// Configuration GoRouter respectant la règle d'or :
/// - Seuls les 5 onglets principaux sont dans le ShellRoute
/// - TOUTES les pages de détail / formulaires sont top-level avec `parentNavigatorKey: _rootNavigatorKey`
final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.home,
  redirect: (context, state) async {
    final isGoingToOnboarding = state.matchedLocation == AppRoutes.onboarding;
    final completed = await _hasCompletedOnboarding();

    if (!completed && !isGoingToOnboarding) {
      return AppRoutes.onboarding;
    }
    if (completed && isGoingToOnboarding) {
      return AppRoutes.home;
    }
    return null;
  },
  routes: [
    // ShellRoute pour les onglets principaux de la navigation basse
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.home,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: HomeScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.parcels,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ParcelsScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.orders,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: OrdersScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.notifications,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: NotificationsScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.profile,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ProfileScreen(),
          ),
        ),
      ],
    ),

    // --- Routes Top-Level (Hors ShellRoute) ---
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: AppRoutes.tracking,
      builder: (context, state) => const TrackingScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),
  ],
);

