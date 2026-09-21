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

class EmailActivationScreen extends ConsumerStatefulWidget {
  final String email;

  const EmailActivationScreen({super.key, required this.email});

  @override
  ConsumerState<EmailActivationScreen> createState() => _EmailActivationScreenState();
}

class _EmailActivationScreenState extends ConsumerState<EmailActivationScreen> {
  final _codeController = TextEditingController();
  bool _isSubmitting = false;
  bool _isResending = false;
  String? _error;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _activate() async {
    final code = _codeController.text.trim();
    if (code.length != 6) {
      setState(() => _error = 'Le code doit contenir 6 chiffres.');
      return;
    }

    setState(() {
      _isSubmitting = true;
      _error = null;
    });

    try {
      await ref.read(authRepositoryProvider).activateAccount(email: widget.email, code: code);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Compte activé, vous pouvez maintenant vous connecter.')),
        );
        context.pushReplacement(AppRoutes.login);
      }
    } on AppException catch (e) {
      setState(() => _error = e.message);
    } catch (_) {
      setState(() => _error = 'Une erreur inattendue est survenue.');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _resend() async {
    setState(() => _isResending = true);
    try {
      await ref.read(authRepositoryProvider).resendActivationCode(email: widget.email);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Un nouveau code a été envoyé par e-mail.')),
        );
      }
    } on AppException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _isResending = false);
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Activez votre compte', style: AppTypography.titleLarge),
              const SizedBox(height: 8),
              Text.rich(
                TextSpan(
                  style: AppTypography.bodySecondary,
                  children: [
                    const TextSpan(text: 'Un code à 6 chiffres a été envoyé à '),
                    TextSpan(text: widget.email, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                    const TextSpan(text: '.'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              if (_error != null) ...[
                AhiyoyoErrorBanner(message: _error!),
                const SizedBox(height: 16),
              ],
              Text('Code d\'activation', style: AppTypography.bodySecondary),
              const SizedBox(height: 6),
              TextField(
                controller: _codeController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 22, letterSpacing: 8, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(counterText: '', hintText: '••••••'),
              ),
              const SizedBox(height: 16),
              AhiyoyoButton(
                text: 'Activer mon compte',
                isLoading: _isSubmitting,
                onPressed: _isSubmitting ? null : _activate,
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: _isResending ? null : _resend,
                  child: Text(
                    _isResending ? 'Envoi en cours...' : 'Renvoyer le code',
                    style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
