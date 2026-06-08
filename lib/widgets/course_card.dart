import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class CourseCard extends StatelessWidget {
  final String icon;
  final String title;
  final String duration;
  final String description;
  const CourseCard({super.key, required this.icon, required this.title, required this.duration, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            decoration: const BoxDecoration(gradient: LinearGradient(colors: [AppColors.navy, AppColors.blue]), borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
            child: Center(child: Text(icon, style: const TextStyle(fontSize: 40))),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark))),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: AppColors.lightBg, borderRadius: BorderRadius.circular(4)),
                      child: Text(duration, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: AppColors.blue)),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(description, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                const SizedBox(height: 8),
                const Text('বিস্তারিত পড়ুন →', style: TextStyle(color: AppColors.blue, fontSize: 11, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}