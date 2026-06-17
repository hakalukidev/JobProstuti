import 'package:flutter/material.dart';
import '../app/theme.dart';

class PricingCard extends StatelessWidget {
  final String title;
  final String price;
  final String? strikePrice;
  final String description;
  final bool isPopular;
  final Widget? badge;

  const PricingCard({
    super.key,
    required this.title,
    required this.price,
    this.strikePrice,
    required this.description,
    this.isPopular = false,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isPopular ? AppColors.primary : AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isPopular ? AppColors.primary : AppColors.lightGray, width: 2),
        boxShadow: isPopular ? AppShadows.elevated : AppShadows.subtle,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (badge != null) badge!,
          const SizedBox(height: 16),
          Text(
            title,
            style: AppTextStyles.headlineLarge.copyWith(
              color: isPopular ? Colors.white : AppColors.black,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: AppTextStyles.statNumber.copyWith(
                  color: isPopular ? Colors.white : AppColors.primary,
                  fontSize: 40,
                ),
              ),
              if (strikePrice != null) ...[
                const SizedBox(width: 12),
                Text(
                  strikePrice!,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: isPopular ? Colors.white70 : AppColors.mediumGray,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: AppTextStyles.bodyMedium.copyWith(
              color: isPopular ? Colors.white.withOpacity(0.8) : AppColors.mediumGray,
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: isPopular ? Colors.white : AppColors.primary,
                foregroundColor: isPopular ? AppColors.primary : Colors.white,
              ),
              child: const Text('কিনুন'),
            ),
          ),
        ],
      ),
    );
  }
}
