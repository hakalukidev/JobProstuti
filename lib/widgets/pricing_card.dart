import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class PricingCard extends StatelessWidget {
  final String? title;
  final String? price;
  final String? strikePrice;
  final String? description;
  final bool? isPopular;
  final Widget? badge;

  const PricingCard({
    this.title,
    this.price,
    this.strikePrice,
    this.description,
    this.isPopular,
    this.badge,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool popular = isPopular ?? false;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: popular ? AppColors.primary : AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: popular ? AppColors.primary : AppColors.lightGray,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (badge != null) badge!,
          const SizedBox(height: 8),
          Text(
            title ?? '',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: popular ? Colors.white : AppColors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description ?? '',
            style: TextStyle(
              color: popular ? Colors.white70 : AppColors.mediumGray,
            ),
          ),
          const Spacer(),
          Text(
            price ?? '',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: popular ? Colors.white : AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
