import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/widgets/ahiyoyo_button.dart';
import '../../../../core/widgets/ahiyoyo_error_banner.dart';
import '../../domain/user.dart';
import '../controllers/auth_controller.dart';

/// Modification du prénom/nom — seules propriétés modifiables via
/// `PATCH /api/me/profile` d'après le contrat d'authentification.
class EditProfileScreen extends ConsumerStatefulWidget {
  final User user;

  const EditProfileScreen({super.key, required this.user});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _prenomController = TextEditingController(text: widget.user.prenom);
  late final TextEditingController _nomController = TextEditingController(text: widget.user.nom);

  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _prenomController.dispose();
    _nomController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isLoading) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await ref.read(authControllerProvider.notifier).updateProfile(
            prenom: _prenomController.text.trim(),
            nom: _nomController.text.trim(),
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil mis à jour.')),
        );
        context.pop();
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
        title: const Text('Modifier mon profil', style: AppTypography.titleMedium),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_error != null) ...[
                  AhiyoyoErrorBanner(message: _error!),
                  const SizedBox(height: 16),
                ],
                Text('Prénom', style: AppTypography.bodySecondary),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _prenomController,
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Requis' : null,
                ),
                const SizedBox(height: 16),
                Text('Nom', style: AppTypography.bodySecondary),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _nomController,
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Requis' : null,
                ),
                const SizedBox(height: 20),
                AhiyoyoButton(
                  text: 'Enregistrer',
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
