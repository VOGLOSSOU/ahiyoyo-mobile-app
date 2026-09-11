import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/ahiyoyo_badge.dart';
import '../../../../core/widgets/ahiyoyo_card.dart';

class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.arrow_left),
          onPressed: () => context.pop(),
        ),
        title: const Text('Suivi en direct', style: AppTypography.titleMedium),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AhiyoyoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('AHI-849204', style: AppTypography.titleLarge.copyWith(fontSize: 20, color: AppColors.primary)),
                    const AhiyoyoBadge(label: 'En mer', variant: AhiyoyoBadgeVariant.submitted),
                  ],
                ),
                const SizedBox(height: 6),
                const Text('Trajet : Guangzhou (Chine) ➔ Port de Cotonou (Bénin)', style: AppTypography.bodySecondary),
                const SizedBox(height: 16),
                const Divider(color: AppColors.border),
                const SizedBox(height: 16),
                const Text('Historique d\'acheminement', style: AppTypography.titleSmall),
                const SizedBox(height: 14),

                // Frise chronologique
                _TimelineStep(
                  title: 'En cours de traversée maritime',
                  subtitle: 'Navire en route vers l\'Afrique de l\'Ouest',
                  date: '08/09/2026 à 10:15',
                  isCompleted: true,
                  isCurrent: true,
                ),
                _TimelineStep(
                  title: 'Conteneur chargé et scellé',
                  subtitle: 'Port de départ de Nansha',
                  date: '02/09/2026 à 16:30',
                  isCompleted: true,
                  isCurrent: false,
                ),
                _TimelineStep(
                  title: 'Réceptionné à l\'entrepôt',
                  subtitle: 'Guangzhou - Mesures confirmées (1.2 CBM)',
                  date: '28/08/2026 à 09:00',
                  isCompleted: true,
                  isCurrent: false,
                ),
                _TimelineStep(
                  title: 'Enregistrement de l\'expédition',
                  subtitle: 'Enregistré par le client via l\'application',
                  date: '25/08/2026 à 14:22',
                  isCompleted: true,
                  isCurrent: false,
                  isLast: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineStep extends StatelessWidget {
  final String title;
  final String subtitle;
  final String date;
  final bool isCompleted;
  final bool isCurrent;
  final bool isLast;

  const _TimelineStep({
    required this.title,
    required this.subtitle,
    required this.date,
    required this.isCompleted,
    required this.isCurrent,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCurrent
                    ? AppColors.primary
                    : isCompleted
                        ? AppColors.statusSuccess
                        : AppColors.border,
              ),
              child: isCompleted
                  ? const Icon(LucideIcons.check, size: 10, color: Colors.black)
                  : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 48,
                color: isCompleted ? AppColors.border : AppColors.borderDark,
              ),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.titleSmall.copyWith(
                  color: isCurrent ? AppColors.primary : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(subtitle, style: AppTypography.caption),
              const SizedBox(height: 2),
              Text(date, style: AppTypography.captionTertiary),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }
}
