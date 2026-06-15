import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../app/theme.dart';
import '../../../widgets/common/custom_button.dart';
import '../../../widgets/common/responsive_layout.dart';

class HeroSection extends ConsumerStatefulWidget {
  const HeroSection({super.key});

  @override
  ConsumerState<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends ConsumerState<HeroSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideIn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slideIn = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);
    final isDesktop = ResponsiveLayout.isDesktop(context);

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: AppColors.heroGradient,
      ),
      child: Stack(
        children: [
          // Background pattern
          Positioned.fill(
            child: Opacity(
              opacity: 0.05,
              child: CustomPaint(
                painter: _DotPatternPainter(),
              ),
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : 40,
              vertical: isMobile ? 48 : 80,
            ),
            child: MaxWidthBox(
              child: FadeTransition(
                opacity: _fadeIn,
                child: SlideTransition(
                  position: _slideIn,
                  child: isDesktop
                      ? _DesktopHero(context: context)
                      : _MobileHero(context: context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MobileHero extends StatelessWidget {
  final BuildContext context;
  const _MobileHero({required this.context});

  @override
  Widget build(BuildContext ctx) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Pill badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(AppRadius.full),
            border: Border.all(color: Colors.white24),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF4ADE80),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'বাংলাদেশের #১ চাকরির প্রস্তুতি প্ল্যাটফর্ম',
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Headline
        Text(
          '৯ লাখ+ চাকরী প্রত্যাশী বিশ্বাস রেখেছে',
          style: AppTextStyles.displayMedium.copyWith(
            color: AppColors.white,
            fontSize: 26,
          ),
        ),
        const SizedBox(height: 4),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFF86EFAC), Color(0xFFBBF7D0)],
          ).createShader(bounds),
          child: Text(
            'Job Prostuti',
            style: AppTextStyles.displayMedium.copyWith(
              color: Colors.white,
              fontSize: 30,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'র উপর',
          style: AppTextStyles.displayMedium.copyWith(
            color: AppColors.white,
            fontSize: 26,
          ),
        ),
        const SizedBox(height: 16),

        Text(
          'BCS, Bank, Primary, NTRCA, Assistant Judge — সকল চাকরির পরীক্ষায় সেরা প্রস্তুতি নিন আমাদের সাথে।',
          style: AppTextStyles.bodyLarge.copyWith(
            color: Colors.white.withOpacity(0.85),
          ),
        ),
        const SizedBox(height: 28),

        Row(
          children: [
            Expanded(
              child: GradientButton(
                label: 'শুরু করুন →',
                gradient: const LinearGradient(
                  colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
                ),
                onPressed: () => context.go(AppRoutes.courses),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: () => context.go(AppRoutes.liveExams),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white38),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('লাইভ পরীক্ষা'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),

        // Trust badges
        _TrustBadges(),
      ],
    );
  }
}

class _DesktopHero extends StatelessWidget {
  final BuildContext context;
  const _DesktopHero({required this.context});

  @override
  Widget build(BuildContext ctx) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left content
        Expanded(
          flex: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  border: Border.all(color: Colors.white24),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF4ADE80),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'বাংলাদেশের #১ চাকরির প্রস্তুতি প্ল্যাটফর্ম',
                      style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              RichText(
                text: TextSpan(
                  style: AppTextStyles.displayLarge.copyWith(
                    fontSize: 42,
                    height: 1.25,
                  ),
                  children: [
                    const TextSpan(text: '৯ লাখ+ চাকরী প্রত্যাশী\nবিশ্বাস রেখেছে '),
                    WidgetSpan(
                      child: ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Color(0xFF86EFAC), Color(0xFFBBF7D0)],
                        ).createShader(bounds),
                        child: Text(
                          'Job Prostuti',
                          style: AppTextStyles.displayLarge.copyWith(
                            fontSize: 42,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const TextSpan(text: '\nর উপর'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'BCS, Bank, Primary, NTRCA, Assistant Judge — সকল চাকরির পরীক্ষায়\nসেরা প্রস্তুতি নিন আমাদের সাথে। লাইভ পরীক্ষা, মডেল টেস্ট, প্রশ্নব্যাংক সব এক জায়গায়।',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: Colors.white.withOpacity(0.85),
                  height: 1.7,
                ),
              ),
              const SizedBox(height: 36),
              Row(
                children: [
                  GradientButton(
                    label: 'কোর্সসমূহ দেখুন →',
                    width: 200,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
                    ),
                    onPressed: () => context.go(AppRoutes.courses),
                  ),
                  const SizedBox(width: 16),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.play_circle_outline, size: 20),
                    label: const Text('ভিডিও দেখুন'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white38),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 48),
              _TrustBadges(),
            ],
          ),
        ),
        const SizedBox(width: 60),
        // Right visual
        Expanded(
          flex: 4,
          child: _HeroVisual(),
        ),
      ],
    );
  }
}

class _TrustBadges extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Badge(icon: Icons.verified, label: 'বিশ্বস্ত'),
        const SizedBox(width: 24),
        _Badge(icon: Icons.security, label: 'নিরাপদ'),
        const SizedBox(width: 24),
        _Badge(icon: Icons.star, label: '৪.৯ রেটিং'),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Badge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: const Color(0xFF86EFAC), size: 16),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
        ),
      ],
    );
  }
}

class _HeroVisual extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 360,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white12),
      ),
      child: Stack(
        children: [
          // Mock exam card
          Positioned(
            top: 24,
            left: 24,
            right: 24,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppShadows.elevated,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'লাইভ পরীক্ষা চলছে',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '৪৭তম বিসিএস মডেল টেস্ট',
                    style: AppTextStyles.headlineSmall.copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '২৫ মিনিট বাকি',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.warning),
                  ),
                ],
              ),
            ),
          ),

          // Stats row
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: Row(
              children: [
                Expanded(
                  child: _MiniStat(value: '৯ লাখ+', label: 'শিক্ষার্থী'),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _MiniStat(value: '২০+', label: 'কোর্স'),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _MiniStat(value: '১ লাখ+', label: 'প্রশ্ন'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String value;
  final String label;
  const _MiniStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.headlineSmall.copyWith(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(color: Colors.white60, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

// Dot pattern background painter
class _DotPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1;

    const spacing = 30.0;
    const radius = 1.5;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_) => false;
}