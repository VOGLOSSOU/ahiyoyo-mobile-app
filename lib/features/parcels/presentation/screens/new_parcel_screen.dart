import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/widgets/ahiyoyo_button.dart';
import '../../../../core/widgets/ahiyoyo_card.dart';
import '../../../../core/widgets/ahiyoyo_error_banner.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../domain/colis_route_line.dart';
import '../../domain/created_parcel.dart';
import '../providers/parcels_providers.dart';

const List<String> _carrierOptions = ['DHL', 'UPS', 'FedEx', 'Aramex', 'SF Express', 'AUTRES'];

/// Chemins d'erreur (voir docs-from-api/03_ENREGISTREMENT_COLIS_MOBILE.md,
/// section 18) rattachés directement à un champ visible du formulaire.
const Set<String> _inlineErrorPaths = {
  'volume.value',
  'owner.firstName',
  'owner.lastName',
  'owner.address',
  'owner.phoneNumber',
  'otherCarrierName',
  'carrierTrackingNumber',
};
const int _maxFileSizeBytes = 10 * 1024 * 1024;

double? _parseLocaleNumber(String input) {
  final cleaned = input.trim().replaceAll(',', '.');
  if (cleaned.isEmpty) return null;
  return double.tryParse(cleaned);
}

class _ArticleEntry {
  final String localId = UniqueKey().toString();
  final descriptionController = TextEditingController();
  final quantityController = TextEditingController(text: '1');
  final unitPriceController = TextEditingController();
  final purchaseLinkController = TextEditingController();
  XFile? image;

  void dispose() {
    descriptionController.dispose();
    quantityController.dispose();
    unitPriceController.dispose();
    purchaseLinkController.dispose();
  }
}

/// Formulaire d'enregistrement d'un colis — parcours classique (choix d'un
/// corridor et d'une ligne tarifaire). Contrat :
/// docs-from-api/03_ENREGISTREMENT_COLIS_MOBILE.md
class NewParcelScreen extends ConsumerStatefulWidget {
  const NewParcelScreen({super.key});

  @override
  ConsumerState<NewParcelScreen> createState() => _NewParcelScreenState();
}

class _NewParcelScreenState extends ConsumerState<NewParcelScreen> {
  final _formKey = GlobalKey<FormState>();
  final _imagePicker = ImagePicker();

  RouteDepart? _depart;
  RouteDestination? _destination;
  ColisRouteLine? _selectedLine;

  final _quantityController = TextEditingController();

  String _ownerType = 'self';
  final _ownerFirstName = TextEditingController();
  final _ownerLastName = TextEditingController();
  final _ownerAddress = TextEditingController();
  final _ownerPhone = TextEditingController();

  String? _carrierName;
  final _otherCarrierName = TextEditingController();
  final _carrierTracking = TextEditingController();

  bool _useArticlesFile = false;
  final List<_ArticleEntry> _articles = [_ArticleEntry()];
  XFile? _articlesFile;

  bool _isSubmitting = false;
  String? _globalError;
  Map<String, dynamic> _fieldErrors = {};

  @override
  void dispose() {
    _quantityController.dispose();
    _ownerFirstName.dispose();
    _ownerLastName.dispose();
    _ownerAddress.dispose();
    _ownerPhone.dispose();
    _otherCarrierName.dispose();
    _carrierTracking.dispose();
    for (final article in _articles) {
      article.dispose();
    }
    super.dispose();
  }

  List<RouteDestination> _availableDestinations(ColisRoutesData data) {
    if (_depart == null) return [];
    final matching = data.lignes.where((l) => l.paysDepart == _depart!.pays && l.villeDepart == _depart!.ville);
    final seen = <String>{};
    final result = <RouteDestination>[];
    for (final l in matching) {
      final key = '${l.paysDestination}|${l.villeDestination}';
      if (seen.add(key)) {
        result.add(RouteDestination(pays: l.paysDestination, ville: l.villeDestination));
      }
    }
    return result;
  }

  List<ColisRouteLine> _availableLines(ColisRoutesData data) {
    if (_depart == null || _destination == null) return [];
    return data.lignes
        .where((l) =>
            l.paysDepart == _depart!.pays &&
            l.villeDepart == _depart!.ville &&
            l.paysDestination == _destination!.pays &&
            l.villeDestination == _destination!.ville)
        .toList();
  }

  void _onDepartChanged(RouteDepart? value) {
    setState(() {
      _depart = value;
      _destination = null;
      _selectedLine = null;
      _carrierTracking.clear();
    });
  }

  void _onDestinationChanged(RouteDestination? value) {
    setState(() {
      _destination = value;
      _selectedLine = null;
      _carrierTracking.clear();
    });
  }

  void _onLineChanged(ColisRouteLine? value) {
    setState(() {
      _selectedLine = value;
      _carrierTracking.clear();
    });
  }

  Future<void> _pickArticleImage(_ArticleEntry article) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(LucideIcons.camera, color: AppColors.primary),
              title: const Text('Prendre une photo', style: AppTypography.bodyMedium),
              onTap: () => Navigator.of(sheetContext).pop(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(LucideIcons.image, color: AppColors.primary),
              title: const Text('Choisir depuis la galerie', style: AppTypography.bodyMedium),
              onTap: () => Navigator.of(sheetContext).pop(ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;

    final picked = await _imagePicker.pickImage(source: source, imageQuality: 85);
    if (picked == null) return;

    final length = await picked.length();
    if (length > _maxFileSizeBytes) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image trop volumineuse (max 10 Mo).')),
        );
      }
      return;
    }

    setState(() => article.image = picked);
  }

  Future<void> _pickArticlesFile() async {
    final file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'xls', 'xlsx', 'doc', 'docx'],
    );
    if (file == null) return;

    final size = await file.length();
    if (size != null && size > _maxFileSizeBytes) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Fichier trop volumineux (max 10 Mo).')),
        );
      }
      return;
    }

    setState(() => _articlesFile = file.xFile);
  }

  void _addArticle() {
    setState(() => _articles.add(_ArticleEntry()));
  }

  void _removeArticle(_ArticleEntry article) {
    setState(() {
      article.dispose();
      _articles.remove(article);
      if (_articles.isEmpty) _articles.add(_ArticleEntry());
    });
  }

  Map<String, dynamic> _buildPayload() {
    final line = _selectedLine!;
    final rule = parcelModeRules[line.modeColis] ?? const ShippingModeRule(unit: 'Kg', quantityLabel: '', minValue: 0);
    final quantity = _parseLocaleNumber(_quantityController.text) ?? 0;

    final payload = <String, dynamic>{
      'ligneTarifaireId': line.id,
      'originCountry': line.paysDepart,
      'originCity': line.villeDepart,
      'destinationCountry': line.paysDestination,
      'destinationCity': line.villeDestination,
      'shippingMode': line.modeColis,
      'volume': {'value': quantity, 'unit': rule.unit},
      'ownerType': _ownerType,
    };

    if (_ownerType == 'other') {
      payload['owner'] = {
        'firstName': _ownerFirstName.text.trim(),
        'lastName': _ownerLastName.text.trim(),
        'address': _ownerAddress.text.trim(),
        'phoneNumber': _ownerPhone.text.trim(),
      };
    }

    if (_carrierName != null) {
      payload['carrierName'] = _carrierName;
      if (_carrierName == 'AUTRES') {
        payload['otherCarrierName'] = _otherCarrierName.text.trim();
      }
    }
    if (_carrierTracking.text.trim().isNotEmpty) {
      payload['carrierTrackingNumber'] = _carrierTracking.text.trim();
    }

    if (!_useArticlesFile) {
      payload['articles'] = _articles
          .where((a) => a.descriptionController.text.trim().isNotEmpty)
          .map((a) {
            final qty = int.tryParse(a.quantityController.text.trim()) ?? 1;
            final unitPrice = _parseLocaleNumber(a.unitPriceController.text) ?? 0;
            final totalPrice = qty * unitPrice;
            return {
              'id': a.localId,
              'description': a.descriptionController.text.trim(),
              'quantity': qty,
              'unitPrice': unitPrice,
              'totalPrice': totalPrice,
              if (a.purchaseLinkController.text.trim().isNotEmpty) 'purchaseLink': a.purchaseLinkController.text.trim(),
            };
          })
          .toList();
    }

    return payload;
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;
    setState(() {
      _globalError = null;
      _fieldErrors = {};
    });

    if (_selectedLine == null) {
      setState(() => _globalError = 'Choisissez un départ, une destination puis un service.');
      return;
    }
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (_ownerType == 'other') {
      if (_ownerFirstName.text.trim().isEmpty ||
          _ownerLastName.text.trim().isEmpty ||
          _ownerAddress.text.trim().isEmpty ||
          _ownerPhone.text.trim().length < 6) {
        setState(() => _globalError = 'Toutes les informations du destinataire sont requises.');
        return;
      }
    }

    if (_carrierName == 'AUTRES' && _otherCarrierName.text.trim().isEmpty) {
      setState(() => _globalError = 'Précisez le nom du transporteur.');
      return;
    }

    if (_selectedLine!.codeTrackingObligatoire && _carrierTracking.text.trim().isEmpty) {
      setState(() => _globalError = 'Le numéro de suivi transporteur est obligatoire pour ce service.');
      return;
    }

    if (_useArticlesFile) {
      if (_articlesFile == null) {
        setState(() => _globalError = 'Ajoutez un fichier listant vos articles.');
        return;
      }
    } else if (_articles.every((a) => a.descriptionController.text.trim().isEmpty)) {
      setState(() => _globalError = 'Ajoutez au moins un article.');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final payload = _buildPayload();
      final images = <String, XFile>{};
      if (!_useArticlesFile) {
        for (final article in _articles) {
          if (article.image != null) images[article.localId] = article.image!;
        }
      }

      final created = await ref.read(parcelsRepositoryProvider).createParcel(
            payload: payload,
            articleImages: images,
            articlesFile: _useArticlesFile ? _articlesFile : null,
          );

      if (mounted) await _showSuccess(created);
    } on AppException catch (e) {
      setState(() {
        _fieldErrors = e.details ?? {};
        // Les erreurs déjà rattachées à un champ visible (voir _fieldErrors
        // usages ci-dessous) n'ont pas besoin d'être répétées dans la
        // bannière globale ; le reste (corridor, mode...) y est regroupé
        // pour ne jamais rester silencieux.
        final unhandled = _fieldErrors.entries.where((entry) => !_inlineErrorPaths.contains(entry.key)).map((entry) => entry.value.toString());
        _globalError = _fieldErrors.isEmpty ? e.message : (unhandled.isEmpty ? null : unhandled.join('\n'));
      });
    } catch (_) {
      setState(() => _globalError = 'Une erreur inattendue est survenue. Vérifiez votre connexion et réessayez.');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _showSuccess(CreatedParcel created) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(LucideIcons.circle_check, color: AppColors.statusSuccess),
            SizedBox(width: 10),
            Text('Colis enregistré', style: AppTypography.titleMedium),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Statut initial : En attente de confirmation.', style: AppTypography.bodySecondary),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      created.trackingNumber,
                      style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(LucideIcons.copy, size: 18, color: AppColors.primary),
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: created.trackingNumber));
                      if (dialogContext.mounted) {
                        ScaffoldMessenger.of(dialogContext).showSnackBar(
                          const SnackBar(content: Text('Numéro de suivi copié.')),
                        );
                      }
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Fermer', style: TextStyle(color: AppColors.textSecondary)),
          ),
          AhiyoyoButton(
            text: 'Suivre ce colis',
            width: 160,
            height: 40,
            onPressed: () {
              Navigator.of(dialogContext).pop();
              if (mounted) {
                context.pushReplacement(AppRoutes.tracking, extra: created.trackingNumber);
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = ref.watch(isAuthenticatedProvider);
    final routesAsync = ref.watch(colisRoutesProvider);

    if (!isAuthenticated) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(LucideIcons.chevron_left),
            onPressed: () => context.pop(),
          ),
          title: const Text('Enregistrer un colis', style: AppTypography.titleMedium),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(LucideIcons.lock, size: 48, color: AppColors.textTertiary),
                const SizedBox(height: 16),
                const Text('Connexion requise', style: AppTypography.titleMedium),
                const SizedBox(height: 6),
                const Text(
                  'Vous devez être connecté pour enregistrer un colis.',
                  style: AppTypography.bodySecondary,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                AhiyoyoButton(
                  text: 'Se connecter',
                  onPressed: () => context.push(AppRoutes.login),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.chevron_left),
          onPressed: () => context.pop(),
        ),
        title: const Text('Enregistrer un colis', style: AppTypography.titleMedium),
      ),
      body: routesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(LucideIcons.circle_alert, size: 48, color: AppColors.textTertiary),
                const SizedBox(height: 12),
                Text(
                  error is AppException ? error.message : 'Impossible de charger les corridors disponibles.',
                  style: AppTypography.bodySecondary,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () => ref.invalidate(colisRoutesProvider),
                  style: OutlinedButton.styleFrom(foregroundColor: AppColors.primary, side: const BorderSide(color: AppColors.primary)),
                  child: const Text('Réessayer'),
                ),
              ],
            ),
          ),
        ),
        data: (routes) => _buildForm(routes),
      ),
    );
  }

  Widget _buildForm(ColisRoutesData routes) {
    final destinations = _availableDestinations(routes);
    final lines = _availableLines(routes);
    final rule = _selectedLine != null ? parcelModeRules[_selectedLine!.modeColis] : null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_globalError != null) ...[
              AhiyoyoErrorBanner(message: _globalError!),
              const SizedBox(height: 16),
            ],

            const Text('Trajet', style: AppTypography.titleSmall),
            const SizedBox(height: 10),
            AhiyoyoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FieldLabel('Départ'),
                  DropdownButtonFormField<RouteDepart>(
                    initialValue: _depart,
                    isExpanded: true,
                    decoration: const InputDecoration(hintText: 'Choisissez un pays de départ'),
                    items: [
                      for (final d in routes.departs)
                        DropdownMenuItem(value: d, child: Text('${d.pays} — ${d.ville}')),
                    ],
                    onChanged: _onDepartChanged,
                  ),
                  const SizedBox(height: 14),
                  _FieldLabel('Destination'),
                  DropdownButtonFormField<RouteDestination>(
                    initialValue: _destination,
                    isExpanded: true,
                    decoration: const InputDecoration(hintText: 'Choisissez une destination'),
                    items: [
                      for (final d in destinations)
                        DropdownMenuItem(value: d, child: Text('${d.pays} — ${d.ville}')),
                    ],
                    onChanged: destinations.isEmpty ? null : _onDestinationChanged,
                  ),
                  if (_destination != null) ...[
                    const SizedBox(height: 14),
                    _FieldLabel('Service'),
                    DropdownButtonFormField<ColisRouteLine>(
                      initialValue: _selectedLine,
                      isExpanded: true,
                      decoration: const InputDecoration(hintText: 'Choisissez un service'),
                      items: [
                        for (final l in lines)
                          DropdownMenuItem(
                            value: l,
                            child: Text(
                              l.categorie != null ? '${l.displayLabel} • ${l.categorie}' : l.displayLabel,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                      onChanged: lines.isEmpty ? null : _onLineChanged,
                    ),
                  ],
                  if (_selectedLine != null) ...[
                    const SizedBox(height: 14),
                    const Divider(color: AppColors.border),
                    const SizedBox(height: 10),
                    if (_selectedLine!.instructionsClient != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(LucideIcons.info, size: 16, color: AppColors.primary),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(_selectedLine!.instructionsClient!, style: AppTypography.caption),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                    if (_selectedLine!.adressePhysique != null)
                      Text('Entrepôt : ${_selectedLine!.adressePhysique}', style: AppTypography.captionTertiary),
                    if (_selectedLine!.contactNom != null || _selectedLine!.contactTelephone != null)
                      Text(
                        'Contact : ${[_selectedLine!.contactNom, _selectedLine!.contactTelephone].where((e) => e != null).join(' - ')}',
                        style: AppTypography.captionTertiary,
                      ),
                  ],
                ],
              ),
            ),

            if (rule != null) ...[
              const SizedBox(height: 20),
              Text(rule.quantityLabel, style: AppTypography.titleSmall),
              const SizedBox(height: 10),
              TextFormField(
                controller: _quantityController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  hintText: rule.unit == 'CBM' ? 'ex. 0,5' : 'ex. 10',
                  errorText: _fieldErrors['volume.value'] as String?,
                ),
                validator: (v) {
                  final value = _parseLocaleNumber(v ?? '');
                  if (value == null) return 'Valeur requise';
                  if (value < rule.minValue) return 'Minimum ${rule.minValue} ${rule.unit}';
                  return null;
                },
              ),
            ],

            const SizedBox(height: 20),
            const Text('Propriétaire du colis', style: AppTypography.titleSmall),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _OwnerTypeChip(
                    label: 'Moi-même',
                    selected: _ownerType == 'self',
                    onTap: () => setState(() => _ownerType = 'self'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _OwnerTypeChip(
                    label: 'Une autre personne',
                    selected: _ownerType == 'other',
                    onTap: () => setState(() => _ownerType = 'other'),
                  ),
                ),
              ],
            ),
            if (_ownerType == 'other') ...[
              const SizedBox(height: 14),
              AhiyoyoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FieldLabel('Prénom'),
                    TextFormField(
                      controller: _ownerFirstName,
                      decoration: InputDecoration(errorText: _fieldErrors['owner.firstName'] as String?),
                    ),
                    const SizedBox(height: 12),
                    _FieldLabel('Nom'),
                    TextFormField(
                      controller: _ownerLastName,
                      decoration: InputDecoration(errorText: _fieldErrors['owner.lastName'] as String?),
                    ),
                    const SizedBox(height: 12),
                    _FieldLabel('Adresse'),
                    TextFormField(
                      controller: _ownerAddress,
                      decoration: InputDecoration(errorText: _fieldErrors['owner.address'] as String?),
                    ),
                    const SizedBox(height: 12),
                    _FieldLabel('Téléphone'),
                    TextFormField(
                      controller: _ownerPhone,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(errorText: _fieldErrors['owner.phoneNumber'] as String?),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 20),
            const Text('Transporteur (facultatif)', style: AppTypography.titleSmall),
            const SizedBox(height: 10),
            AhiyoyoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: _carrierName,
                    isExpanded: true,
                    decoration: const InputDecoration(hintText: 'Sélectionner un transporteur'),
                    items: [
                      for (final c in _carrierOptions) DropdownMenuItem(value: c, child: Text(c == 'AUTRES' ? 'Autre' : c)),
                    ],
                    onChanged: (value) => setState(() => _carrierName = value),
                  ),
                  if (_carrierName == 'AUTRES') ...[
                    const SizedBox(height: 12),
                    _FieldLabel('Précisez le nom du transporteur'),
                    TextFormField(
                      controller: _otherCarrierName,
                      decoration: InputDecoration(errorText: _fieldErrors['otherCarrierName'] as String?),
                    ),
                  ],
                  const SizedBox(height: 12),
                  _FieldLabel(
                    _selectedLine?.codeTrackingObligatoire == true
                        ? 'Numéro de suivi transporteur (obligatoire pour ce service)'
                        : 'Numéro de suivi transporteur (facultatif)',
                  ),
                  TextFormField(
                    controller: _carrierTracking,
                    decoration: InputDecoration(errorText: _fieldErrors['carrierTrackingNumber'] as String?),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Articles', style: AppTypography.titleSmall),
                TextButton(
                  onPressed: () => setState(() => _useArticlesFile = !_useArticlesFile),
                  child: Text(
                    _useArticlesFile ? 'Saisir manuellement' : 'Envoyer un fichier à la place',
                    style: const TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (_useArticlesFile)
              AhiyoyoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Envoyez un unique fichier (PDF, Excel ou Word) listant tous vos articles.',
                      style: AppTypography.captionTertiary,
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: _pickArticlesFile,
                      icon: const Icon(LucideIcons.file_up, size: 16),
                      label: Text(_articlesFile?.name ?? 'Choisir un fichier'),
                      style: OutlinedButton.styleFrom(foregroundColor: AppColors.primary, side: const BorderSide(color: AppColors.border)),
                    ),
                  ],
                ),
              )
            else ...[
              for (final article in _articles) ...[
                _ArticleCard(
                  article: article,
                  onPickImage: () => _pickArticleImage(article),
                  onRemove: _articles.length > 1 ? () => _removeArticle(article) : null,
                  onChanged: () => setState(() {}),
                ),
                const SizedBox(height: 10),
              ],
              OutlinedButton.icon(
                onPressed: _addArticle,
                icon: const Icon(LucideIcons.plus, size: 16),
                label: const Text('Ajouter un article'),
                style: OutlinedButton.styleFrom(foregroundColor: AppColors.primary, side: const BorderSide(color: AppColors.border)),
              ),
            ],

            const SizedBox(height: 28),
            AhiyoyoButton(
              text: 'Enregistrer le colis',
              isLoading: _isSubmitting,
              onPressed: _isSubmitting ? null : _submit,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text, style: AppTypography.bodySecondary),
    );
  }
}

class _OwnerTypeChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _OwnerTypeChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primary : AppColors.surface,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: selected ? null : Border.all(color: AppColors.border),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: selected ? AppColors.onPrimary : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _ArticleCard extends StatelessWidget {
  final _ArticleEntry article;
  final VoidCallback onPickImage;
  final VoidCallback? onRemove;
  final VoidCallback onChanged;

  const _ArticleCard({required this.article, required this.onPickImage, required this.onRemove, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final quantity = int.tryParse(article.quantityController.text.trim()) ?? 0;
    final unitPrice = _parseLocaleNumber(article.unitPriceController.text) ?? 0;
    final total = quantity * unitPrice;

    return AhiyoyoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: onPickImage,
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: article.image != null
                      ? const Icon(LucideIcons.image, color: AppColors.primary, size: 20)
                      : const Icon(LucideIcons.camera, color: AppColors.textTertiary, size: 20),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: article.descriptionController,
                  decoration: const InputDecoration(hintText: 'Description de l\'article'),
                  onChanged: (_) => onChanged(),
                ),
              ),
              if (onRemove != null)
                IconButton(
                  icon: const Icon(LucideIcons.trash, size: 18, color: AppColors.statusError),
                  onPressed: onRemove,
                ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: article.quantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: 'Quantité'),
                  onChanged: (_) => onChanged(),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: article.unitPriceController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(hintText: 'Prix unitaire'),
                  onChanged: (_) => onChanged(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('Total : ${total.toStringAsFixed(0)} FCFA', style: AppTypography.captionTertiary),
          const SizedBox(height: 10),
          TextFormField(
            controller: article.purchaseLinkController,
            decoration: const InputDecoration(hintText: 'Lien du produit (facultatif)'),
          ),
        ],
      ),
    );
  }
}
