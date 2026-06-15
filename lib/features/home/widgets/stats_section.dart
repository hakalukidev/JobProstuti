import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../../repositories/user_repository.dart';
import '../../../widgets/common/custom_button.dart';
import '../../../widgets/common/responsive_layout.dart';

class StatsSection extends ConsumerStatefulWidget {
  const StatsSection({super.key});

  @override
  ConsumerState<StatsSection> createState() => _StatsSectionState();
}

class _StatsSectionState extends ConsumerState<StatsSection> {
  @override
  Widget build(BuildContext context) {
    final statsAsync = ref.watch(statisticsProvider);
    final isMobile = ResponsiveLayout.isMobile(context);

    return Container(
      color: AppColors.white,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 40 : 64,
        horizontal: isMobile ? 20 : 40,
      ),
      child: MaxWidthBox(
        child: Column(
          children: [
            Text(
              'আমাদের পরিসংখ্যান',
              style: AppTextStyles.displaySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'লক্ষ লক্ষ শিক্ষার্থীর আস্থার প্ল্যাটফর্ম',
              style: AppTextStyles.bodyLarge.copyWith(color: AppColors.mediumGray),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            statsAsync.when(
              data: (stats) => GridView.count(
                crossAxisCount: isMobile ? 2 : 5,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: isMobile ? 1.3 : 1.1,
                children: [
                  _AnimatedStatCard(
                    icon: Icons.people_alt_outlined,
                    value: '৯ লাখ+',
                    label: 'চাকরি প্রত্যাশী',
                    iconColor: AppColors.primary,
                  ),
                  _AnimatedStatCard(
                    icon: Icons.play_circle_outline,
                    value: '২০+',
                    label: 'লাইভ কোর্স',
                    iconColor: AppColors.accent,
                  ),
                  _AnimatedStatCard(
                    icon: Icons.quiz_outlined,
                    value: '১ লাখ+',
                    label: 'প্রশ্ন',
                    iconColor: AppColors.info,
                  ),
                  _AnimatedStatCard(
                    icon: Icons.topic_outlined,
                    value: '৩০০+',
                    label: 'টপিক',
                    iconColor: AppColors.success,
                  ),
                  _AnimatedStatCard(
                    icon: Icons.download_outlined,
                    value: '৯ লাখ+',
                    label: 'ডাউনলোড',
                    iconColor: AppColors.warning,
                  ),
                ],
              ),
              loading: () => GridView.count(
                crossAxisCount: isMobile ? 2 : 5,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: isMobile ? 1.3 : 1.1,
                children: List.generate(5, (_) => const StatCardSkeleton()),
              ),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedStatCard extends StatefulWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color iconColor;

  const _AnimatedStatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.iconColor,
  });

  @override
  State<_AnimatedStatCard> createState() => _AnimatedStatCardState();
}

class _AnimatedStatCardState extends State<_AnimatedStatCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.lightGray),
          boxShadow: AppShadows.subtle,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: widget.iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(widget.icon, color: widget.iconColor, size: 26),
            ),
            const SizedBox(height: 12),
            Text(
              widget.value,
              style: AppTextStyles.statNumber.copyWith(fontSize: 24),
            ),
            const SizedBox(height: 4),
            Text(
              widget.label,
              style: AppTextStyles.statLabel,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}