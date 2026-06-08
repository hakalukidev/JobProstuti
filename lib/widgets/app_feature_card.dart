import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class AppFeatureCard extends StatelessWidget {
  final String icon;
  final String title;
  final String description;
  const AppFeatureCard({super.key, required this.icon, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(color: AppColors.lightBg, borderRadius: BorderRadius.circular(28)),
            child: Center(child: Text(icon, style: const TextStyle(fontSize: 24))),
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark), textAlign: TextAlign.center),
          const SizedBox(height: 6),
          Text(description, style: const TextStyle(color: AppColors.textMuted, fontSize: 11, height: 1.4), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}