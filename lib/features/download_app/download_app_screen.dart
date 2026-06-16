import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../widgets/common/custom_appbar.dart';
import '../../widgets/common/responsive_layout.dart';
import '../../widgets/phone_mockup.dart';

class DownloadAppScreen extends StatelessWidget {
  const DownloadAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);

    return Scaffold(
      appBar: const AppBarWidget(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHero(context, isMobile),
            SizedBox(height: isMobile ? 32 : 48),
            _buildPhoneSection(isMobile),
            SizedBox(height: isMobile ? 48 : 64),
            _buildFeatures(isMobile),
            SizedBox(height: isMobile ? 48 : 64),
            _buildDownloadSection(context, isMobile),
            SizedBox(height: isMobile ? 48 : 64),
          ],
        ),
      ),
    );
  }

  Widget _buildHero(BuildContext context, bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 40,
        vertical: isMobile ? 48 : 80,
      ),
      decoration: const BoxDecoration(gradient: AppColors.heroGradient),
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.04,
              child: CustomPaint(painter: _DotPatternPainter()),
            ),
          ),
          MaxWidthBox(
            child: Column(
              children: [
                Text(
                  'ডাউনলোড অ্যাপ',
                  style: AppTextStyles.displayMedium.copyWith(
                    color: AppColors.white,
                    fontSize: isMobile ? 28 : 36,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: isMobile ? double.infinity : 600,
                  child: Text(
                    'যেকোনো সময়, যেকোনো জায়গায় আপনার প্রস্তুতিকে আরও শক্তিশালী করুন। মোবাইল অ্যাপ ডাউনলোড করে নিন।',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 32),
                _buildStoreButtons(context, isMobile),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneSection(bool isMobile) {
    return MaxWidthBox(
      child: Column(
        children: [
          Text(
            'অভিজ্ঞতা দেখুন',
            style: AppTextStyles.displaySmall.copyWith(
              fontSize: isMobile ? 20 : 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'স্মার্ট ফিচার দিয়ে তৈরি আপনার প্রস্তুতি আরও কার্যকর',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.mediumGray,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          PhoneMockup(isCentered: !isMobile),
        ],
      ),
    );
  }

  Widget _buildFeatures(bool isMobile) {
    const features = [
      _FeatureData(
        icon: Icons.wifi_off_rounded,
        label: 'অফলাইন সাপোর্ট',
        desc: 'ইন্টারনেট ছাড়াও পড়তে পারবেন',
        color: Color(0xFF3B82F6),
      ),
      _FeatureData(
        icon: Icons.live_tv_rounded,
        label: 'লাইভ এক্সাম',
        desc: 'রিয়েল টাইমে পরীক্ষা দিয়ে প্রস্তুতি যাচাই',
        color: Color(0xFFEF4444),
      ),
      _FeatureData(
        icon: Icons.quiz_rounded,
        label: 'মডেল টেস্ট',
        desc: 'বিষয়ভিত্তিক মডেল টেস্টের বিশাল সংগ্রহ',
        color: Color(0xFF8B5CF6),
      ),
      _FeatureData(
        icon: Icons.auto_graph_rounded,
        label: 'প্রগ্রেস ট্র্যাক',
        desc: 'আপনার অগ্রগতি বিস্তারিত পরিসংখ্যানে দেখুন',
        color: Color(0xFF1B8E3D),
      ),
      _FeatureData(
        icon: Icons.notifications_active_rounded,
        label: 'নোটিফিকেশন',
        desc: 'গুরুত্বপূর্ণ পরীক্ষার আপডেট পান সবার আগে',
        color: Color(0xFFF59E0B),
      ),
      _FeatureData(
        icon: Icons.bookmark_rounded,
        label: 'বুকমার্ক',
        desc: 'গুরুত্বপূর্ণ প্রশ্ন ও নোট সংরক্ষণ করে রাখুন',
        color: Color(0xFF06B6D4),
      ),
    ];

    return MaxWidthBox(
      child: Column(
        children: [
          Text(
            'অ্যাপের বিশেষ ফিচার',
            style: AppTextStyles.displaySmall.copyWith(
              fontSize: isMobile ? 20 : 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'প্রস্তুতির প্রতিটি ধাপে আমরা আছি আপনার পাশে',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.mediumGray,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile ? 1 : 3,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: isMobile ? 3.5 : 1.6,
            ),
            itemCount: features.length,
            itemBuilder: (_, i) => _buildFeatureCard(features[i], isMobile),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(_FeatureData feature, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightGray),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: feature.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(feature.icon, color: feature.color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  feature.label,
                  style: AppTextStyles.headlineSmall.copyWith(
                    fontSize: isMobile ? 14 : 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  feature.desc,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.mediumGray,
                    fontSize: isMobile ? 12 : 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadSection(BuildContext context, bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 40,
        vertical: isMobile ? 48 : 64,
      ),
      decoration: BoxDecoration(
        color: AppColors.primarySurface.withValues(alpha: 0.5),
      ),
      child: MaxWidthBox(
        child: Column(
          children: [
            Text(
              'এখনই ডাউনলোড করুন',
              style: AppTextStyles.displaySmall.copyWith(
                fontSize: isMobile ? 20 : 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'আপনার ডিভাইসের জন্য উপযুক্ত ভার্সন নির্বাচন করুন',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.mediumGray,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _buildStoreButtons(context, isMobile),
          ],
        ),
      ),
    );
  }

  Widget _buildStoreButtons(BuildContext context, bool isMobile) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children: [
        _StoreButton(
          icon: Icons.play_circle_filled_rounded,
          label: 'Google Play',
          subtitle: 'ডাউনলোড করুন',
          color: const Color(0xFF4CAF50),
          onTap: () {},
        ),
        _StoreButton(
          icon: Icons.apple_rounded,
          label: 'App Store',
          subtitle: 'শীঘ্রই আসছে',
          color: const Color(0xFF000000),
          onTap: () {},
          disabled: true,
        ),
      ],
    );
  }
}

class _StoreButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;
  final bool disabled;

  const _StoreButton({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        decoration: BoxDecoration(
          color: disabled ? color.withValues(alpha: 0.6) : color,
          borderRadius: BorderRadius.circular(14),
          boxShadow: disabled
              ? null
              : [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureData {
  final IconData icon;
  final String label;
  final String desc;
  final Color color;

  const _FeatureData({
    required this.icon,
    required this.label,
    required this.desc,
    required this.color,
  });
}

class _DotPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.5;
    const spacing = 25.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1.5, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
