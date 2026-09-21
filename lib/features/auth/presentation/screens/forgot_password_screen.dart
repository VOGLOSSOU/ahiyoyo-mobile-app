import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/widgets/ahiyoyo_button.dart';
import '../../../../core/widgets/ahiyoyo_error_banner.dart';
import '../controllers/auth_controller.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  final String? initialEmail;

  const ForgotPasswordScreen({super.key, this.initialEmail});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  late final TextEditingController _emailController =
      TextEditingController(text: widget.initialEmail);
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      setState(() => _error = 'Entrez un email valide.');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final ttlSeconds = await ref.read(authRepositoryProvider).forgotPassword(email: email);
      if (mounted) {
        context.pushReplacement(
          AppRoutes.resetPassword,
          extra: {'email': email, 'ttlSeconds': ttlSeconds},
        );
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Mot de passe oublié', style: AppTypography.titleLarge),
              const SizedBox(height: 8),
              const Text(
                'Indiquez votre email : nous vous enverrons un code de réinitialisation.',
                style: AppTypography.bodySecondary,
              ),
              const SizedBox(height: 24),
              if (_error != null) ...[
                AhiyoyoErrorBanner(message: _error!),
                const SizedBox(height: 16),
              ],
              Text('Email', style: AppTypography.bodySecondary),
              const SizedBox(height: 6),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(hintText: 'vous@exemple.com'),
              ),
              const SizedBox(height: 20),
              AhiyoyoButton(
                text: 'Envoyer le code',
                isLoading: _isLoading,
                onPressed: _isLoading ? null : _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
