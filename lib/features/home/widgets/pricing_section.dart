import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../app/theme.dart';
import '../../../repositories/user_repository.dart';
import '../../../widgets/common/custom_button.dart';
import '../../../widgets/common/responsive_layout.dart';

class PricingSection extends ConsumerWidget {
  const PricingSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packagesAsync = ref.watch(packagesProvider);
    final isMobile = ResponsiveLayout.isMobile(context);

    return Container(
      color: AppColors.white,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 48 : 80,
        horizontal: isMobile ? 20 : 40,
      ),
      child: MaxWidthBox(
        child: Column(
          children: [
            Text('মূল্য তালিকা', style: AppTextStyles.displaySmall, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              'আপনার বাজেট ও চাহিদা অনুযায়ী প্যাকেজ বেছে নিন',
              style: AppTextStyles.bodyLarge.copyWith(color: AppColors.mediumGray),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            packagesAsync.when(
              data: (packages) {
                return isMobile
                    ? ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: packages.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 20),
                  itemBuilder: (_, i) => _PricingCard(package: packages[i]),
                )
                    : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: packages
                      .map((p) => Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: packages.indexOf(p) < packages.length - 1 ? 20 : 0,
                      ),
                      child: _PricingCard(package: p),
                    ),
                  ))
                      .toList(),
                );
              },
              loading: () => const LoadingWidget(),
              error: (e, _) => AppErrorWidget(message: e.toString()),
            ),
          ],
        ),
      ),
    );
  }
}

class _PricingCard extends StatelessWidget {
  final dynamic package;
  const _PricingCard({required this.package});

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
              if (isPopular) const SizedBox(height: 16),
              Text(
                package.name ?? '',
                style: AppTextStyles.headlineMedium.copyWith(
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
                      fontSize: 32,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4, left: 4),
                    child: Text(
                      '/${package.durationDays} দিন',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: isPopular ? Colors.white60 : AppColors.mediumGray,
                      ),
                    ),
                  ),
                ],
              ),
              if (package.hasDiscount == true) ...[
                const SizedBox(height: 4),
                Text(
                  '৳${(package.price as double?)?.toInt() ?? 0} এর বদলে',
                  style: AppTextStyles.bodySmall.copyWith(
                    decoration: TextDecoration.lineThrough,
                    color: isPopular ? Colors.white54 : AppColors.mediumGray,
                  ),
                ),
              ],
              const SizedBox(height: 20),
              Divider(color: isPopular ? Colors.white24 : AppColors.lightGray),
              const SizedBox(height: 16),
              ...(package.features as List<dynamic>? ?? []).map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: isPopular ? Colors.white : AppColors.primary,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        f.toString(),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: isPopular ? Colors.white : AppColors.darkGray,
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
                  onPressed: () => context.go(AppRoutes.pricing),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                  ),
                  child: const Text('এখনই কিনুন'),
                )
                    : OutlinedButton(
                  onPressed: () => context.go(AppRoutes.pricing),
                  child: const Text('এখনই কিনুন'),
                ),
              ),
            ],
          ),
        ),
        if (isPopular)
          Positioned(
            top: -12,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  package.badgeText ?? 'সবচেয়ে জনপ্রিয়',
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