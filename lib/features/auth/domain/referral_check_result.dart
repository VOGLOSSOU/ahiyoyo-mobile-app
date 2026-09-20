/// Résultat de la vérification préalable d'un code de parrainage
/// (`GET /api/parrainage/verifier`).
class ReferralCheckResult {
  final bool valid;
  final String? parrainNomPublic;
  final String? message;

  const ReferralCheckResult({
    required this.valid,
    this.parrainNomPublic,
    this.message,
  });
}
