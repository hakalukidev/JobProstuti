import 'package:flutter/material.dart';
import '../app/theme.dart';

class CallButton extends StatelessWidget {
  const CallButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightGray),
        boxShadow: AppShadows.subtle,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.phone_in_talk_rounded, color: AppColors.primary, size: 24),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'যেকোনো প্রয়োজনে',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.mediumGray, fontSize: 10),
              ),
              Text(
                '০১৮৯৪-৪৪২৯৪৪',
                style: AppTextStyles.labelLarge.copyWith(color: AppColors.black, fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
