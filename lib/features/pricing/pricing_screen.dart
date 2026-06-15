import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../repositories/user_repository.dart';
import '../../widgets/common/custom_appbar.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/responsive_layout.dart';

class PricingScreen extends ConsumerWidget {
  const PricingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packagesAsync = ref.watch(packagesProvider);
    final isMobile = ResponsiveLayout.isMobile(context);

    return Scaffold(
      appBar: const AppBarWidget(title: 'মূল্য তালিকা'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
              decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
              child: Column(
                children: [
                  Text('মূল্য তালিকা', style: AppTextStyles.displaySmall.copyWith(color: Colors.white), textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  Text(
                    'আপনার বাজেট ও চাহিদা অনুযায়ী প্যাকেজ বেছে নিন',
                    style: AppTextStyles.bodyLarge.copyWith(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.all(isMobile ? 16 : 32),
              child: MaxWidthBox(
                child: Column(
                  children: [
                    packagesAsync.when(
                      data: (packages) => isMobile
                          ? ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: packages.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 20),
                        itemBuilder: (_, i) => _PricingDetailCard(package: packages[i]),
                      )
                          : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: packages
                            .map((p) => Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: packages.indexOf(p) < packages.length - 1 ? 20 : 0,
                            ),
                            child: _PricingDetailCard(package: p),
                          ),
                        ))
                            .toList(),
                      ),
                      loading: () => const LoadingWidget(),
                      error: (e, _) => AppErrorWidget(message: e.toString()),
                    ),

                    const SizedBox(height: 48),

                    // FAQ about pricing
                    Text('মূল্য সংক্রান্ত প্রশ্ন', style: AppTextStyles.displaySmall, textAlign: TextAlign.center),
                    const SizedBox(height: 24),
                    ...[
                      ('কীভাবে পেমেন্ট করব?', 'bKash, Nagad, ক্রেডিট/ডেবিট কার্ড সহ সকল মাধ্যমে পেমেন্ট করতে পারবেন।'),
                      ('টাকা ফেরত পাওয়া যাবে?', '৭ দিনের মধ্যে সমস্যা হলে সম্পূর্ণ টাকা ফেরত দেওয়া হবে।'),
                      ('প্যাকেজ কি আপগ্রেড করা যাবে?', 'হ্যাঁ, যেকোনো সময় উচ্চতর প্যাকেজে আপগ্রেড করতে পারবেন।'),
                      ('একাধিক ডিভাইসে ব্যবহার করা যাবে?', 'হ্যাঁ, একই অ্যাকাউন্ট দিয়ে যেকোনো ডিভাইসে ব্যবহার করা যাবে।'),
                    ].map((faq) => _PricingFaqItem(question: faq.$1, answer: faq.$2)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PricingDetailCard extends StatelessWidget {
  final dynamic package;
  const _PricingDetailCard({required this.package});

  @override
  Widget build(BuildContext context) {
    final isPopular = package.isPopular as bool? ?? false;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isPopular ? AppColors.primary : AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(
              color: isPopular ? AppColors.primary : AppColors.lightGray,
              width: isPopular ? 2 : 1,
            ),
            boxShadow: isPopular ? AppShadows.elevated : AppShadows.subtle,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isPopular) const SizedBox(height: 20),
              Text(
                package.name ?? '',
                style: AppTextStyles.headlineLarge.copyWith(
                  color: isPopular ? Colors.white : AppColors.black,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                package.description ?? '',
                style: AppTextStyles.bodySmall.copyWith(
                  color: isPopular ? Colors.white70 : AppColors.mediumGray,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '৳${(package.effectivePrice as double?)?.toInt() ?? 0}',
                    style: AppTextStyles.statNumber.copyWith(
                      color: isPopular ? Colors.white : AppColors.primary,
                      fontSize: 36,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6, left: 6),
                    child: Text(
                      '/${package.durationDays} দিন',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isPopular ? Colors.white60 : AppColors.mediumGray,
                      ),
                    ),
                  ),
                ],
              ),
              if (package.hasDiscount == true) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '৳${(package.price as double?)?.toInt() ?? 0}',
                      style: AppTextStyles.bodySmall.copyWith(
                        decoration: TextDecoration.lineThrough,
                        color: isPopular ? Colors.white54 : AppColors.mediumGray,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: isPopular ? Colors.white.withOpacity(0.2) : AppColors.accentLight,
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                      child: Text(
                        '${package.discountPercent}% ছাড়',
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
              const SizedBox(height: 20),
              Divider(color: isPopular ? Colors.white24 : AppColors.lightGray),
              const SizedBox(height: 16),
              ...(package.features as List<dynamic>? ?? []).map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check_circle, color: isPopular ? Colors.white : AppColors.primary, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        f.toString(),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: isPopular ? Colors.white : AppColors.darkGray,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: isPopular
                    ? ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    elevation: 0,
                  ),
                  child: const Text('এখনই কিনুন'),
                )
                    : OutlinedButton(
                  onPressed: () {},
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
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  boxShadow: [BoxShadow(color: AppColors.accent.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 3))],
                ),
                child: Text(
                  package.badgeText ?? 'সবচেয়ে জনপ্রিয়',
                  style: AppTextStyles.bodySmall.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _PricingFaqItem extends StatefulWidget {
  final String question;
  final String answer;
  const _PricingFaqItem({required this.question, required this.answer});

  @override
  State<_PricingFaqItem> createState() => _PricingFaqItemState();
}

class _PricingFaqItemState extends State<_PricingFaqItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: _expanded ? AppColors.primary.withOpacity(0.3) : AppColors.lightGray),
      ),
      child: InkWell(
        onTap: () => setState(() => _expanded = !_expanded),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.question,
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: _expanded ? AppColors.primary : AppColors.black,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Icon(
                    _expanded ? Icons.remove : Icons.add,
                    color: _expanded ? AppColors.primary : AppColors.mediumGray,
                    size: 20,
                  ),
                ],
              ),
              if (_expanded) ...[
                const SizedBox(height: 10),
                Text(
                  widget.answer,
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.mediumGray, height: 1.6),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}