import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/widgets/ahiyoyo_button.dart';
import '../../../../core/widgets/ahiyoyo_error_banner.dart';
import '../controllers/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _globalError;
  bool _showActivationActions = false;
  Map<String, dynamic>? _fieldErrors;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isLoading) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _isLoading = true;
      _globalError = null;
      _fieldErrors = null;
      _showActivationActions = false;
    });

    try {
      final session = await ref.read(authRepositoryProvider).login(
            email: _emailController.text.trim(),
            motDePasse: _passwordController.text,
          );
      await ref.read(authControllerProvider.notifier).onAuthenticated(session);
      if (mounted) context.go(AppRoutes.home);
    } on AppException catch (e) {
      setState(() {
        _fieldErrors = e.details;
        _globalError = e.details == null ? e.message : null;
        _showActivationActions = e.statusCode == 403;
      });
    } catch (_) {
      setState(() => _globalError = 'Une erreur inattendue est survenue.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resendActivationCode() async {
    try {
      await ref.read(authRepositoryProvider).resendActivationCode(email: _emailController.text.trim());
    } catch (_) {
      return;
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Code renvoyé par e-mail.')),
    );
  }

  void _onGoogleTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Connexion Google bientôt disponible')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Connexion', style: AppTypography.titleLarge),
                const SizedBox(height: 6),
                const Text(
                  'Accédez à vos colis, devis et commandes Ahiyoyo.',
                  style: AppTypography.bodySecondary,
                ),
                const SizedBox(height: 24),
                if (_globalError != null) ...[
                  AhiyoyoErrorBanner(message: _globalError!),
                  const SizedBox(height: 16),
                ],
                if (_showActivationActions) ...[
                  Row(
                    children: [
                      Expanded(
                        child: AhiyoyoButton(
                          text: 'Saisir le code',
                          variant: AhiyoyoButtonVariant.outline,
                          height: 40,
                          onPressed: () => context.push(
                            AppRoutes.emailActivation,
                            extra: _emailController.text.trim(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: AhiyoyoButton(
                          text: 'Renvoyer le code',
                          variant: AhiyoyoButtonVariant.secondary,
                          height: 40,
                          onPressed: _resendActivationCode,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
                Text('Email', style: AppTypography.bodySecondary),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  decoration: InputDecoration(
                    hintText: 'vous@exemple.com',
                    errorText: _fieldErrors?['email'] as String?,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return 'Email requis';
                    if (!value.contains('@')) return 'Email invalide';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Text('Mot de passe', style: AppTypography.bodySecondary),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: '••••••••',
                    errorText: _fieldErrors?['mot_de_passe'] as String?,
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.length < 6) return 'Mot de passe trop court';
                    return null;
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => context.push(
                      AppRoutes.forgotPassword,
                      extra: _emailController.text.trim(),
                    ),
                    child: const Text('Mot de passe oublié ?', style: TextStyle(color: AppColors.primary, fontSize: 13)),
                  ),
                ),
                const SizedBox(height: 8),
                AhiyoyoButton(
                  text: 'Se connecter',
                  isLoading: _isLoading,
                  onPressed: _isLoading ? null : _submit,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Expanded(child: Divider(color: AppColors.border)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text('ou', style: AppTypography.captionTertiary),
                    ),
                    const Expanded(child: Divider(color: AppColors.border)),
                  ],
                ),
                const SizedBox(height: 16),
                AhiyoyoButton(
                  text: 'Continuer avec Google',
                  variant: AhiyoyoButtonVariant.secondary,
                  onPressed: _onGoogleTap,
                ),
                const SizedBox(height: 24),
                Center(
                  child: TextButton(
                    onPressed: () => context.push(AppRoutes.register),
                    child: const Text.rich(
                      TextSpan(
                        text: 'Pas encore de compte ? ',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                        children: [
                          TextSpan(
                            text: 'Créer un compte',
                            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
