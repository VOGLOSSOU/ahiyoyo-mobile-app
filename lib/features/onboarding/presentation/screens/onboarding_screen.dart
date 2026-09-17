import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/providers/app_providers.dart';
import '../../../../core/widgets/ahiyoyo_button.dart';

class OnboardingItem {
  final String imagePath;
  final String title;
  final String description;

  const OnboardingItem({
    required this.imagePath,
    required this.title,
    required this.description,
  });
}

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<OnboardingItem> _items = const [
    OnboardingItem(
      imagePath: 'ressources/au-port.png',
      title: 'Tout le commerce international depuis votre téléphone.',
      description:
          'Expédiez, suivez et recevez vos colis depuis l’Afrique vers le monde entier, en quelques tapes.',
    ),
    OnboardingItem(
      imagePath: 'ressources/groupage.png',
      title: 'Des tarifs qui baissent avec la taille du conteneur.',
      description:
          'Profitez de nos groupages collectifs (maritime et aérien) pour payer moins par CBM ou KG partagé.',
    ),
    OnboardingItem(
      imagePath: 'ressources/sourcing.png',
      title: 'De la source Chine au suivi réel de votre colis.',
      description:
          'Trouvez des fournisseurs, faites vos achats et suivez chaque étape jusqu’au retrait en entrepôt.',
    ),
  ];

  Future<void> _finishOnboarding() async {
    final cache = ref.read(localCacheProvider);
    await cache.save('has_completed_onboarding', true);
    if (mounted) {
      context.go(AppRoutes.home);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _items.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context, index) {
              final item = _items[index];
              return Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    item.imagePath,
                    fit: BoxFit.cover,
                    excludeFromSemantics: true,
                    errorBuilder: (context, error, stackTrace) =>
                        const ColoredBox(color: AppColors.surface),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0x66000000),
                          Color(0x10000000),
                          Color(0x99000000),
                          Color(0xF2000000),
                        ],
                        stops: [0, 0.32, 0.62, 1],
                      ),
                    ),
                  ),
                  SafeArea(
                    minimum: const EdgeInsets.only(top: 16, bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 80, 24, 136),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 560),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 40,
                                  height: 4,
                                  margin: const EdgeInsets.only(bottom: 20),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                Text(
                                  item.title,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        MediaQuery.sizeOf(context).width < 360
                                        ? 28
                                        : 34,
                                    fontWeight: FontWeight.w800,
                                    height: 1.12,
                                    letterSpacing: -0.8,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  item.description,
                                  style: const TextStyle(
                                    color: Color(0xFFE5E5E5),
                                    fontSize: 16,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          SafeArea(
            minimum: const EdgeInsets.symmetric(vertical: 16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.asset(
                          'ressources/ahiyoyo-logo.jpg',
                          width: 80,
                          height: 32,
                          fit: BoxFit.cover,
                          semanticLabel: 'Ahiyoyo',
                          errorBuilder: (context, error, stackTrace) =>
                              const Text(
                                'Ahiyoyo',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                        ),
                      ),
                      TextButton(
                        onPressed: _finishOnboarding,
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0x40000000),
                          minimumSize: const Size(80, 44),
                        ),
                        child: const Text('Passer'),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 560),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Semantics(
                            label:
                                'Page ${_currentIndex + 1} sur ${_items.length}',
                            child: Row(
                              children: List.generate(
                                _items.length,
                                (index) => AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  margin: const EdgeInsets.only(right: 8),
                                  width: _currentIndex == index ? 32 : 8,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: _currentIndex == index
                                        ? AppColors.primary
                                        : const Color(0x66FFFFFF),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          AhiyoyoButton(
                            text: _currentIndex == _items.length - 1
                                ? 'Commencer'
                                : 'Suivant',
                            onPressed: () {
                              if (_currentIndex < _items.length - 1) {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 350),
                                  curve: Curves.easeInOut,
                                );
                              } else {
                                _finishOnboarding();
                              }
                            },
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
