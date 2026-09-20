import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/ahiyoyo_card.dart';

/// Adresses des entrepôts et barèmes tarifaires (données de démonstration
/// en attendant le branchement API du Lot 2).
class TariffsScreen extends StatelessWidget {
  const TariffsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.arrow_left),
          onPressed: () => context.pop(),
        ),
        title: const Text('Adresses & Tarifs', style: AppTypography.titleMedium),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Adresses de nos entrepôts', style: AppTypography.titleSmall),
          const SizedBox(height: 10),
          AhiyoyoCard(
            child: Column(
              children: [
                _AddressRow(
                  icon: LucideIcons.warehouse,
                  city: 'Guangzhou, Chine',
                  address: '12 Baiyun Road, Baiyun District, Guangzhou 510000',
                ),
                Divider(color: AppColors.border, height: 28),
                _AddressRow(
                  icon: LucideIcons.warehouse,
                  city: 'Cotonou, Bénin',
                  address: 'Zone portuaire, Boulevard de la Marina, Cotonou',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('Tarifs Maritime (dégressif)', style: AppTypography.titleSmall),
          const SizedBox(height: 10),
          AhiyoyoCard(
            child: Column(
              children: [
                _TariffRow(range: '0,5 à 1 CBM', price: '285 000 FCFA / CBM'),
                Divider(color: AppColors.border, height: 24),
                _TariffRow(range: '1 à 3 CBM', price: '265 000 FCFA / CBM'),
                Divider(color: AppColors.border, height: 24),
                _TariffRow(range: '3 CBM et plus', price: '240 000 FCFA / CBM', highlighted: true),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('Tarifs Aérien', style: AppTypography.titleSmall),
          const SizedBox(height: 10),
          AhiyoyoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Tarif au kilo', style: AppTypography.bodySecondary),
                    Text(
                      '4 500 FCFA / KG',
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Poids arrondi au kilogramme supérieur.',
                  style: AppTypography.captionTertiary,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _AddressRow extends StatelessWidget {
  final IconData icon;
  final String city;
  final String address;

  const _AddressRow({required this.icon, required this.city, required this.address});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryMuted,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: AppColors.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(city, style: AppTypography.titleSmall),
              const SizedBox(height: 4),
              Text(address, style: AppTypography.bodySecondary),
            ],
          ),
        ),
      ],
    );
  }
}

class _TariffRow extends StatelessWidget {
  final String range;
  final String price;
  final bool highlighted;

  const _TariffRow({required this.range, required this.price, this.highlighted = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(range, style: AppTypography.bodySecondary),
        Text(
          price,
          style: AppTypography.bodyMedium.copyWith(
            color: highlighted ? AppColors.primary : AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
