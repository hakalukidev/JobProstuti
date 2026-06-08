import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class FaqItem extends StatelessWidget {
  final String question;
  final String answer;
  const FaqItem({super.key, required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: Text(question, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark)),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(answer, style: const TextStyle(color: AppColors.textMuted, fontSize: 13, height: 1.5)),
          ),
        ],
      ),
    );
  }
}