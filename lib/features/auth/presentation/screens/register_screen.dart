import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/widgets/ahiyoyo_button.dart';
import '../../../../core/widgets/ahiyoyo_error_banner.dart';
import '../controllers/auth_controller.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _codePaysController = TextEditingController(text: '229');
  final _numeroController = TextEditingController();
  final _referralController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _acceptedTerms = false;
  String? _globalError;
  Map<String, dynamic>? _fieldErrors;

  Timer? _referralDebounce;
  int _referralRequestId = 0;
  bool _isCheckingReferral = false;
  String? _referralParrainName;
  String? _referralError;

  @override
  void dispose() {
    _referralDebounce?.cancel();
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _codePaysController.dispose();
    _numeroController.dispose();
    _referralController.dispose();
    super.dispose();
  }

  void _onReferralChanged(String value) {
    _referralDebounce?.cancel();
    final code = value.trim();
    setState(() {
      _referralParrainName = null;
      _referralError = null;
    });
    if (code.isEmpty) {
      setState(() => _isCheckingReferral = false);
      return;
    }
    setState(() => _isCheckingReferral = true);
    final requestId = ++_referralRequestId;
    _referralDebounce = Timer(const Duration(milliseconds: 450), () async {
      final result = await ref.read(authRepositoryProvider).verifyReferralCode(code.toUpperCase());
      if (!mounted || requestId != _referralRequestId) return;
      setState(() {
        _isCheckingReferral = false;
        if (result.valid) {
          _referralParrainName = result.parrainNomPublic;
        } else {
          _referralError = result.message ?? 'Code de parrainage invalide';
        }
      });
    });
  }

  bool get _isReferralBlocking {
    final code = _referralController.text.trim();
    if (code.isEmpty) return false;
    return _isCheckingReferral || _referralParrainName == null;
  }

  void _onGoogleTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Inscription Google bientôt disponible')),
    );
  }

  Future<void> _openLegalLink(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _submit() async {
    if (_isLoading) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (!_acceptedTerms) {
      setState(() => _globalError = 'Vous devez accepter les CGU et la Politique de confidentialité.');
      return;
    }
    if (_isReferralBlocking) {
      setState(() => _globalError = 'Vérifiez le code de parrainage avant de continuer.');
      return;
    }

    setState(() {
      _isLoading = true;
      _globalError = null;
      _fieldErrors = null;
    });

    try {
      await ref.read(authRepositoryProvider).register(
            nom: _nomController.text.trim(),
            prenom: _prenomController.text.trim(),
            email: _emailController.text.trim(),
            motDePasse: _passwordController.text,
            numero: _numeroController.text.trim(),
            codePays: _codePaysController.text.trim(),
            codeParrainage: _referralController.text.trim().isEmpty
                ? null
                : _referralController.text.trim().toUpperCase(),
          );
      if (mounted) {
        context.pushReplacement(AppRoutes.emailActivation, extra: _emailController.text.trim());
      }
    } on AppException catch (e) {
      setState(() {
        _fieldErrors = e.details;
        _globalError = e.details == null ? e.message : null;
      });
    } catch (_) {
      setState(() => _globalError = 'Une erreur inattendue est survenue.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
                const Text('Créer un compte', style: AppTypography.titleLarge),
                const SizedBox(height: 6),
                const Text(
                  'Rejoignez Ahiyoyo pour expédier, suivre et acheter à l\'international.',
                  style: AppTypography.bodySecondary,
                ),
                const SizedBox(height: 24),
                AhiyoyoButton(
                  text: 'Continuer avec Google',
                  variant: AhiyoyoButtonVariant.secondary,
                  onPressed: _onGoogleTap,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Expanded(child: Divider(color: AppColors.border)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text('ou par email', style: AppTypography.captionTertiary),
                    ),
                    const Expanded(child: Divider(color: AppColors.border)),
                  ],
                ),
                const SizedBox(height: 20),
                if (_globalError != null) ...[
                  AhiyoyoErrorBanner(message: _globalError!),
                  const SizedBox(height: 16),
                ],
                Row(
                  children: [
                    Expanded(
                      child: _LabeledField(
                        label: 'Prénom',
                        controller: _prenomController,
                        errorText: _fieldErrors?['prenom'] as String?,
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Requis' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _LabeledField(
                        label: 'Nom',
                        controller: _nomController,
                        errorText: _fieldErrors?['nom'] as String?,
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Requis' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _LabeledField(
                  label: 'Email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  errorText: _fieldErrors?['email'] as String?,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Email requis';
                    if (!v.contains('@')) return 'Email invalide';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _LabeledField(
                  label: 'Mot de passe',
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  errorText: _fieldErrors?['mot_de_passe'] as String?,
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  validator: (v) {
                    if (v == null || v.length < 8) return 'Au moins 8 caractères';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    SizedBox(
                      width: 80,
                      child: _LabeledField(
                        label: 'Indicatif',
                        controller: _codePaysController,
                        keyboardType: TextInputType.number,
                        hintText: '229',
                        errorText: _fieldErrors?['code_pays'] as String?,
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Requis' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _LabeledField(
                        label: 'Numéro de téléphone',
                        controller: _numeroController,
                        keyboardType: TextInputType.phone,
                        hintText: '97000000',
                        errorText: _fieldErrors?['numero'] as String?,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Requis';
                          if (v.trim().length < 6) return 'Numéro invalide';
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _LabeledField(
                  label: 'Code de parrainage (facultatif)',
                  controller: _referralController,
                  onChanged: _onReferralChanged,
                  suffixIcon: _isCheckingReferral
                      ? const Padding(
                          padding: EdgeInsets.all(14),
                          child: SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                          ),
                        )
                      : null,
                ),
                if (_referralParrainName != null) ...[
                  const SizedBox(height: 6),
                  Text('✓ Parrain : $_referralParrainName', style: const TextStyle(color: AppColors.statusSuccess, fontSize: 12)),
                ],
                if (_referralError != null) ...[
                  const SizedBox(height: 6),
                  Text(_referralError!, style: const TextStyle(color: AppColors.statusError, fontSize: 12)),
                ],
                const SizedBox(height: 20),
                InkWell(
                  onTap: () => setState(() => _acceptedTerms = !_acceptedTerms),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: _acceptedTerms,
                        activeColor: AppColors.primary,
                        onChanged: (value) => setState(() => _acceptedTerms = value ?? false),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text.rich(
                            TextSpan(
                              style: AppTypography.bodySecondary,
                              children: [
                                const TextSpan(text: 'J\'ai lu et j\'accepte les '),
                                TextSpan(
                                  text: 'CGU',
                                  style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => _openLegalLink('https://ahiyoyo.com/cgu'),
                                ),
                                const TextSpan(text: ' et la '),
                                TextSpan(
                                  text: 'Politique de confidentialité',
                                  style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => _openLegalLink('https://ahiyoyo.com/confidentialite'),
                                ),
                                const TextSpan(text: '.'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                AhiyoyoButton(
                  text: 'Créer mon compte',
                  isLoading: _isLoading,
                  onPressed: (_isLoading || !_acceptedTerms || _isReferralBlocking) ? null : _submit,
                ),
                const SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: () => context.pop(),
                    child: const Text.rich(
                      TextSpan(
                        text: 'Déjà un compte ? ',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                        children: [
                          TextSpan(
                            text: 'Se connecter',
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

class _LabeledField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? hintText;
  final String? errorText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const _LabeledField({
    required this.label,
    required this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.hintText,
    this.errorText,
    this.suffixIcon,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.bodySecondary),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          onChanged: onChanged,
          decoration: InputDecoration(hintText: hintText, errorText: errorText, suffixIcon: suffixIcon),
          validator: validator,
        ),
      ],
    );
  }
}
