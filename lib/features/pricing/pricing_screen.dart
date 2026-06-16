import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../widgets/common/custom_appbar.dart';
import '../../widgets/common/responsive_layout.dart';

class PricingScreen extends ConsumerStatefulWidget {
  const PricingScreen({super.key});

  @override
  ConsumerState<PricingScreen> createState() => _PricingScreenState();
}

class _PricingScreenState extends ConsumerState<PricingScreen> {
  PageController? _pageController;
  int _currentPage = 0;
  late Timer _timer;
  bool _isPaused = false;

  final List<_PlanData> _plans = [
    _PlanData(
      name: 'সাপ্তাহিক',
      price: '৳৪৯',
      duration: '৭ দিন',
      originalPrice: '৳৯৯',
      discount: '৫০%',
      features: [
        '৭ দিনের ফুল অ্যাপ অ্যাক্সেস',
        'বিসিএস, ব্যাংক, প্রাইমারি প্রস্তুতি',
        'শিক্ষক নিবন্ধন (NTRCA)',
        'গুরুত্বপূর্ণ নোট ও গাইড',
      ],
      isPopular: false,
    ),
    _PlanData(
      name: 'মাসিক',
      price: '৳১৪৯',
      duration: '৩০ দিন',
      features: [
        '৩০ দিনের ফুল অ্যাপ অ্যাক্সেস',
        'বিসিএস, ব্যাংক, প্রাইমারি প্রস্তুতি',
        'শিক্ষক নিবন্ধন (NTRCA)',
        'গুরুত্বপূর্ণ নোট ও গাইড',
        'মডেল টেস্ট',
      ],
      isPopular: false,
    ),
    _PlanData(
      name: '৩ মাস',
      price: '৳২৯৯',
      duration: '৯০ দিন',
      originalPrice: '৳৪৪৭',
      discount: '৩৩%',
      features: [
        '৯০ দিনের ফুল অ্যাপ অ্যাক্সেস',
        'বিসিএস, ব্যাংক, প্রাইমারি প্রস্তুতি',
        'শিক্ষক নিবন্ধন (NTRCA)',
        'গুরুত্বপূর্ণ নোট ও গাইড',
        'মডেল টেস্ট ও কুইজ',
      ],
      isPopular: false,
    ),
    _PlanData(
      name: '৬ মাস',
      price: '৳৪৯৯',
      duration: '১৮০ দিন',
      originalPrice: '৳৮৯৪',
      discount: '৪৪%',
      features: [
        '১৮০ দিনের ফুল অ্যাপ অ্যাক্সেস',
        'বিসিএস, ব্যাংক, প্রাইমারি প্রস্তুতি',
        'শিক্ষক নিবন্ধন (NTRCA)',
        'গুরুত্বপূর্ণ নোট ও গাইড',
        'মডেল টেস্ট ও কুইজ',
        'লাইভ এক্সাম',
      ],
      isPopular: false,
    ),
    _PlanData(
      name: 'বার্ষিক',
      price: '৳৭১৯',
      duration: '৩৬৫ দিন',
      originalPrice: '৳১৭৮৮',
      discount: '৬০%',
      features: [
        '৩৬৫ দিনের ফুল অ্যাপ অ্যাক্সেস',
        'সমস্ত কোর্সে আনলিমিটেড অ্যাক্সেস',
        'সকল মডেল টেস্ট ও লাইভ এক্সাম',
        'গুরুত্বপূর্ণ নোট ও গাইড',
        'প্রাথমিক সাপোর্ট',
        'সর্বোচ্চ সাশ্রয়',
      ],
      isPopular: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  double _viewportFraction(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1100) return 0.333;
    if (width >= 700) return 0.5;
    return 0.85;
  }

  void _ensureController(BuildContext context) {
    final fraction = _viewportFraction(context);
    if (_pageController == null || _pageController!.viewportFraction != fraction) {
      _pageController?.dispose();
      _pageController = PageController(viewportFraction: fraction, initialPage: _currentPage);
    }
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (_isPaused) return;
      if (_pageController == null) return;
      final next = _currentPage < _plans.length - 1 ? _currentPage + 1 : 0;
      setState(() => _currentPage = next);
      _pageController?.animateToPage(
        next,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  void _goToPage(int index) {
    setState(() => _isPaused = true);
    _pageController?.animateToPage(index,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOutCubic);
    Future.delayed(const Duration(seconds: 8), () {
      if (mounted) setState(() => _isPaused = false);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _ensureController(context);
    final isMobile = ResponsiveLayout.isMobile(context);

    return Scaffold(
      appBar: const AppBarWidget(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 40),
            _buildSlider(isMobile),
            const SizedBox(height: 24),
            _buildDots(),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 20),
      decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
      child: MaxWidthBox(
        child: Column(
          children: [
            Text(
              'প্যাকেজ',
              style: AppTextStyles.displayLarge.copyWith(fontSize: 40),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'সুলভ মূল্য, সব সময়',
              style: AppTextStyles.headlineLarge.copyWith(color: Colors.white, fontSize: 24),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'সুলভ মূল্যে সেরা প্রস্তুতি নিশ্চিতে সাজানো আমাদের সব প্রিমিয়াম প্যাকেজ',
              style: AppTextStyles.bodyLarge.copyWith(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider(bool isMobile) {
    return Center(
      child: MaxWidthBox(
        maxWidth: isMobile ? double.infinity : 960,
        child: SizedBox(
          height: isMobile ? 520 : 480,
          child: PageView.builder(
            controller: _pageController!,
            onPageChanged: (page) => setState(() => _currentPage = page),
            itemCount: _plans.length,
            itemBuilder: (_, index) {
              return GestureDetector(
                onTap: () => _goToPage(index),
                child: AnimatedScale(
                  scale: _currentPage == index ? 1.0 : (isMobile ? 0.95 : 0.92),
                  duration: const Duration(milliseconds: 300),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 8 : 12,
                      vertical: 12,
                    ),
                    child: _PlanCard(plan: _plans[index]),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_plans.length, (i) {
        final isActive = _currentPage == i;
        return GestureDetector(
          onTap: () => _goToPage(i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            height: 10,
            width: isActive ? 24 : 10,
            decoration: BoxDecoration(
              color: isActive ? AppColors.primary : AppColors.lightGray,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        );
      }),
    );
  }
}

class _PlanData {
  final String name;
  final String price;
  final String duration;
  final String? originalPrice;
  final String? discount;
  final List<String> features;
  final bool isPopular;

  const _PlanData({
    required this.name,
    required this.price,
    required this.duration,
    this.originalPrice,
    this.discount,
    required this.features,
    this.isPopular = false,
  });
}

class _PlanCard extends StatelessWidget {
  final _PlanData plan;
  const _PlanCard({required this.plan});

  @override
  Widget build(BuildContext context) {
    final isPopular = plan.isPopular;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isPopular ? AppColors.primary : AppColors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isPopular ? AppColors.primary : AppColors.lightGray,
              width: isPopular ? 2 : 1,
            ),
            boxShadow: isPopular
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.25),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : AppShadows.card,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (isPopular) const SizedBox(height: 16),
              Text(
                plan.name,
                style: AppTextStyles.headlineLarge.copyWith(
                  color: isPopular ? Colors.white : AppColors.black,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    plan.price,
                    style: AppTextStyles.statNumber.copyWith(
                      color: isPopular ? Colors.white : AppColors.primary,
                      fontSize: 32,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6, left: 6),
                    child: Text(
                      '/${plan.duration}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: isPopular ? Colors.white70 : AppColors.mediumGray,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              if (plan.originalPrice != null && plan.discount != null) ...[
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      plan.originalPrice!,
                      style: AppTextStyles.bodySmall.copyWith(
                        decoration: TextDecoration.lineThrough,
                        color: isPopular ? Colors.white54 : AppColors.mediumGray,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: isPopular ? Colors.white.withValues(alpha: 0.2) : AppColors.accentLight,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '${plan.discount} ছাড়',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: isPopular ? Colors.white : AppColors.accent,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 16),
              ...plan.features.map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: isPopular ? Colors.white : AppColors.primary, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        f,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: isPopular ? Colors.white : AppColors.darkGray,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: isPopular
                    ? ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primary,
                        ),
                        child: const Text('এখনই কিনুন'),
                      )
                    : OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: isPopular ? Colors.white : AppColors.primary,
                          side: BorderSide(
                            color: isPopular ? Colors.white.withValues(alpha: 0.5) : AppColors.primary,
                          ),
                        ),
                        child: const Text('এখনই কিনুন'),
                      ),
              ),
            ],
          ),
        ),
        if (isPopular)
          Positioned(
            top: -14,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  'সবচেয়ে জনপ্রিয়',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}