import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class SectionBadge extends StatelessWidget {
  final String title;
  const SectionBadge({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.blue, width: 1.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(color: AppColors.blue, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(title, style: const TextStyle(color: AppColors.blue, fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}