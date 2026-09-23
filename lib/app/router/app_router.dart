import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/domain/user.dart';
import '../../features/auth/presentation/screens/change_password_screen.dart';
import '../../features/auth/presentation/screens/edit_profile_screen.dart';
import '../../features/auth/presentation/screens/email_activation_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/reset_password_screen.dart';
import '../../features/groupage/presentation/screens/air_offer_detail_screen.dart';
import '../../features/groupage/presentation/screens/sea_groupage_detail_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/legal/domain/cgu_content.dart';
import '../../features/legal/domain/privacy_policy_content.dart';
import '../../features/legal/presentation/screens/legal_document_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/orders/presentation/screens/orders_screen.dart';
import '../../features/parcels/presentation/screens/new_parcel_screen.dart';
import '../../features/parcels/presentation/screens/parcels_screen.dart';
import '../../features/settings/presentation/screens/profile_screen.dart';
import '../../features/tariffs/presentation/screens/tariffs_screen.dart';
import '../../features/tracking/presentation/screens/tracking_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/onboarding/presentation/screens/splash_screen.dart';
import '../shell/app_shell.dart';
import 'app_routes.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

/// Configuration GoRouter respectant la règle d'or :
/// - Seuls les 4 onglets de la navbar (Accueil, Colis, Commandes, Profil)
///   sont dans le ShellRoute. Le bouton central "+" n'est pas un onglet :
///   il ouvre une feuille modale d'actions rapides.
/// - TOUTES les pages de détail / formulaires sont top-level avec `parentNavigatorKey: _rootNavigatorKey`
final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.splash,
  routes: [
    // --- Route Splash Screen (Démarrage) ---
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),

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
      builder: (context, state) => TrackingScreen(initialQuery: state.extra as String?),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: AppRoutes.notifications,
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: AppRoutes.seaGroupageDetail,
      builder: (context, state) => SeaGroupageDetailScreen(id: state.pathParameters['id']!),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: AppRoutes.airOfferDetail,
      builder: (context, state) => AirOfferDetailScreen(id: state.pathParameters['id']!),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: AppRoutes.tariffs,
      builder: (context, state) => const TariffsScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: AppRoutes.newParcel,
      builder: (context, state) => const NewParcelScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),

    // --- Authentification ---
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: AppRoutes.register,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: AppRoutes.emailActivation,
      builder: (context, state) => EmailActivationScreen(email: state.extra as String),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: AppRoutes.forgotPassword,
      builder: (context, state) {
        final email = state.extra is String ? state.extra as String : null;
        return ForgotPasswordScreen(initialEmail: (email?.isEmpty ?? true) ? null : email);
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: AppRoutes.resetPassword,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return ResetPasswordScreen(email: extra['email'] as String, ttlSeconds: extra['ttlSeconds'] as int);
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: AppRoutes.changePassword,
      builder: (context, state) => const ChangePasswordScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: AppRoutes.editProfile,
      builder: (context, state) => EditProfileScreen(user: state.extra as User),
    ),

    // --- Pages légales ---
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: AppRoutes.cgu,
      builder: (context, state) => LegalDocumentScreen(document: cguDocument),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: AppRoutes.privacyPolicy,
      builder: (context, state) => LegalDocumentScreen(document: privacyPolicyDocument),
    ),
  ],
);


