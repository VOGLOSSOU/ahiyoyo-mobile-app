import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/widgets/ahiyoyo_button.dart';
import '../../../../core/widgets/ahiyoyo_error_banner.dart';
import '../controllers/auth_controller.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  final String email;
  final int ttlSeconds;

  const ResetPasswordScreen({super.key, required this.email, required this.ttlSeconds});

  @override
  ConsumerState<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _newPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _error;
  late int _remainingSeconds = widget.ttlSeconds;
  Timer? _countdown;

  @override
  void initState() {
    super.initState();
    _countdown = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_remainingSeconds <= 0) {
        timer.cancel();
        return;
      }
      setState(() => _remainingSeconds--);
    });
  }

  @override
  void dispose() {
    _countdown?.cancel();
    _codeController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  String get _countdownLabel {
    final minutes = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Future<void> _submit() async {
    if (_isLoading) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await ref.read(authRepositoryProvider).resetPassword(
            email: widget.email,
            code: _codeController.text.trim(),
            nouveauMotDePasse: _newPasswordController.text,
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mot de passe mis à jour. Connectez-vous.')),
        );
        context.go(AppRoutes.login);
      }
    } on AppException catch (e) {
      setState(() => _error = e.message);
    } catch (_) {
      setState(() => _error = 'Une erreur inattendue est survenue.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.chevron_left),
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
                const Text('Réinitialiser le mot de passe', style: AppTypography.titleLarge),
                const SizedBox(height: 8),
                Text.rich(
                  TextSpan(
                    style: AppTypography.bodySecondary,
                    children: [
                      const TextSpan(text: 'Code envoyé à '),
                      TextSpan(text: widget.email, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _remainingSeconds > 0 ? 'Code valable encore $_countdownLabel' : 'Le code a probablement expiré.',
                  style: AppTypography.captionTertiary,
                ),
                const SizedBox(height: 24),
                if (_error != null) ...[
                  AhiyoyoErrorBanner(message: _error!),
                  const SizedBox(height: 16),
                ],
                Text('Code reçu par email', style: AppTypography.bodySecondary),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _codeController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: const InputDecoration(counterText: '', hintText: '••••••'),
                  validator: (v) => (v == null || v.trim().length != 6) ? 'Code à 6 chiffres requis' : null,
                ),
                const SizedBox(height: 16),
                Text('Nouveau mot de passe', style: AppTypography.bodySecondary),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: '••••••••',
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: (v) => (v == null || v.length < 8) ? 'Au moins 8 caractères' : null,
                ),
                const SizedBox(height: 20),
                AhiyoyoButton(
                  text: 'Mettre à jour le mot de passe',
                  isLoading: _isLoading,
                  onPressed: _isLoading ? null : _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
