import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../../widgets/common/responsive_layout.dart';

class FeaturesSection extends ConsumerWidget {
  const FeaturesSection({super.key});

  static const _features = [
    _FeatureData(
      icon: Icons.live_tv,
      title: 'লাইভ পরীক্ষা',
      description:
          'রিয়েল-টাইম পরীক্ষায় অংশ নিন এবং সাথে সাথে ফলাফল জানুন। দেশের সেরা শিক্ষার্থীদের সাথে প্রতিযোগিতা করুন।',
      color: Color(0xFF3B82F6),
      bgColor: Color(0xFFEFF6FF),
    ),
    _FeatureData(
      icon: Icons.category_outlined,
      title: 'কোর্স ক্যাটাগরি',
      description:
          'BCS, Bank, Primary, NTRCA সহ সকল ক্যাটাগরির কোর্স এক জায়গায়। নিজের প্রয়োজন অনুযায়ী বেছে নিন।',
      color: Color(0xFF8B5CF6),
      bgColor: Color(0xFFF5F3FF),
    ),
    _FeatureData(
      icon: Icons.calendar_today_outlined,
      title: 'পরীক্ষার রুটিন',
      description:
          'আগামী লাইভ পরীক্ষার সময়সূচী আগেভাগে জানুন। নোটিফিকেশন পেয়ে প্রস্তুত থাকুন।',
      color: Color(0xFF10B981),
      bgColor: Color(0xFFECFDF5),
    ),
    _FeatureData(
      icon: Icons.bar_chart,
      title: 'পারফরম্যান্স বিশ্লেষণ',
      description:
          'আপনার দুর্বল দিক চিহ্নিত করুন। বিস্তারিত চার্ট ও বিশ্লেষণ দেখে উন্নতি করুন।',
      color: Color(0xFFF59E0B),
      bgColor: Color(0xFFFFFBEB),
    ),
    _FeatureData(
      icon: Icons.quiz_outlined,
      title: 'মডেল টেস্ট',
      description:
          'নিজের ইচ্ছামতো বিষয়, সময় ও নম্বর নির্ধারণ করে মডেল টেস্ট দিন। বারবার অনুশীলন করুন।',
      color: Color(0xFFEF4444),
      bgColor: Color(0xFFFEF2F2),
    ),
    _FeatureData(
      icon: Icons.offline_bolt_outlined,
      title: 'অফলাইন সাপোর্ট',
      description:
          'ইন্টারনেট ছাড়াও প্রশ্নব্যাংক এবং সেভ করা উপকরণ পড়তে পারবেন।',
      color: Color(0xFF06B6D4),
      bgColor: Color(0xFFECFEFF),
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = ResponsiveLayout.isMobile(context);

    return Container(
      color: AppColors.white,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 48 : 80,
        horizontal: isMobile ? 20 : 40,
      ),
      child: MaxWidthBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'আমাদের সুবিধাসমূহ',
              style: AppTextStyles.displaySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'কেন লক্ষ লক্ষ শিক্ষার্থী Job Prostuti বেছে নিয়েছে',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.mediumGray,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            LayoutBuilder(
              builder: (context, constraints) {
                final isBounded = constraints.maxHeight.isFinite;

                final grid = GridView.builder(
                  padding: EdgeInsets.zero,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isMobile
                        ? 1
                        : (ResponsiveLayout.isDesktop(context) ? 3 : 2),
                    crossAxisSpacing: 24,
                    mainAxisSpacing: 24,
                    childAspectRatio: isMobile ? 3.5 : 1.6,
                  ),
                  itemCount: _features.length,
                  itemBuilder: (_, i) => _FeatureCard(feature: _features[i]),
                );

                if (isBounded) {
                  return Flexible(child: grid);
                }

                // Unbounded (e.g. inside SingleChildScrollView) — shrink wrap
                return GridView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isMobile
                        ? 1
                        : (ResponsiveLayout.isDesktop(context) ? 3 : 2),
                    crossAxisSpacing: 24,
                    mainAxisSpacing: 24,
                    childAspectRatio: isMobile ? 3.5 : 1.6,
                  ),
                  itemCount: _features.length,
                  itemBuilder: (_, i) => _FeatureCard(feature: _features[i]),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureData {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final Color bgColor;

  const _FeatureData({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.bgColor,
  });
}

class _FeatureCard extends StatefulWidget {
  final _FeatureData feature;
  const _FeatureCard({required this.feature});

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _hovered ? widget.feature.bgColor : AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: _hovered
                ? widget.feature.color.withOpacity(0.3)
                : AppColors.lightGray,
          ),
          boxShadow: _hovered ? AppShadows.card : AppShadows.subtle,
        ),
        child: isMobile
            ? Row(
                children: [
                  _Icon(feature: widget.feature),
                  const SizedBox(width: 16),
                  Expanded(child: _Content(feature: widget.feature)),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Icon(feature: widget.feature),
                  const SizedBox(height: 16),
                  _Content(feature: widget.feature),
                ],
              ),
      ),
    );
  }
}

class _Icon extends StatelessWidget {
  final _FeatureData feature;
  const _Icon({required this.feature});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: feature.bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: feature.color.withOpacity(0.2)),
      ),
      child: Icon(feature.icon, color: feature.color, size: 26),
    );
  }
}

class _Content extends StatelessWidget {
  final _FeatureData feature;
  const _Content({required this.feature});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(feature.title, style: AppTextStyles.headlineSmall),
        const SizedBox(height: 6),
        Text(
          feature.description,
          style: AppTextStyles.bodySmall,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
