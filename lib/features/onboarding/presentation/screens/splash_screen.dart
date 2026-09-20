import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/providers/app_providers.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _opacityAnimation;

  bool _navigated = false;

  /// Durée minimale d'affichage du splash, à chaque lancement (première fois
  /// comme suivantes), le temps que le logo fasse son animation de
  /// va-et-vient et que les visuels de l'onboarding soient préchargés.
  static const Duration _minSplashDuration = Duration(seconds: 6);

  static const List<String> _onboardingImagePaths = [
    'ressources/au-port.png',
    'ressources/groupage.png',
    'ressources/sourcing.png',
  ];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    // Effet "pull / push" : le logo grossit et rétrécit en boucle.
    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Amorce la restauration de session (lecture du stockage sécurisé puis
    // GET /api/me) pendant l'animation, pour éviter un flash "non connecté"
    // à l'arrivée sur la home si l'utilisateur a déjà une session valide.
    ref.read(authControllerProvider);

    // addPostFrameCallback garantit que le GoRouter et MediaQuery sont
    // attachés au context avant de préchager des images ou de naviguer.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialize();
    });
  }

  Future<void> _initialize() async {
    final hasCompleted = await _hasCompletedOnboarding();
    _navigate(hasCompleted);
  }

  Future<bool> _hasCompletedOnboarding() async {
    final cache = ref.read(localCacheProvider);
    // LocalCacheService.get() renvoie déjà la valeur déballée de `data`
    // (ex. `true` pour save('...', true)).
    final result = await cache.get('has_completed_onboarding');
    final hasCompleted = result == true;

    // On attend à la fois la durée minimale du splash ET le préchargement
    // des images de l'onboarding (~2-3 Mo chacune), pour ne jamais afficher
    // l'onboarding avec des images qui "pop-in".
    await Future.wait([
      Future<void>.delayed(_minSplashDuration),
      _precacheOnboardingImages(),
    ]);

    return hasCompleted;
  }

  Future<void> _precacheOnboardingImages() async {
    if (!mounted) return;
    try {
      await Future.wait(
        _onboardingImagePaths.map(
          (path) => precacheImage(AssetImage(path), context),
        ),
      ).timeout(const Duration(seconds: 5), onTimeout: () => <void>[]);
    } catch (_) {
      // Une image manquante, corrompue ou trop lente à décoder ne doit
      // jamais bloquer indéfiniment le lancement de l'application.
    }
  }

  void _navigate(bool hasCompleted) {
    if (!mounted || _navigated) return;
    _navigated = true;
    // Stoppe le repeat pour éviter les fuites de timers entre tests.
    _controller.stop();
    try {
      context.go(hasCompleted ? AppRoutes.home : AppRoutes.onboarding);
    } catch (e) {
      debugPrint('[SplashScreen] navigation failed: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Fond doré de marque en plein écran : le logo partage exactement
      // cette même teinte en arrière-plan, il se fond donc dans la page
      // sans cadre ni ombre visible.
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Opacity(
                    opacity: _opacityAnimation.value,
                    child: Image.asset(
                      'ressources/ahiyoyo-logo.jpg',
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 200,
                          height: 200,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'ahiyoyo',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 26,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
