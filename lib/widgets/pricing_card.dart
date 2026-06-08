import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class PricingCard extends StatelessWidget {
  final String title;
  final String price;
  final bool isPopular;
  const PricingCard({super.key, required this.title, required this.price, this.isPopular = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isPopular ? AppColors.blue.withValues(alpha: 0.15) : Colors.white.withValues(alpha: 0.06),
        border: Border.all(color: isPopular ? AppColors.blue : Colors.white.withValues(alpha: 0.15)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          if (isPopular) const Text('⭐ জনপ্রিয়', style: TextStyle(color: AppColors.gold, fontSize: 11)),
          const SizedBox(height: 12),
          Text(price, style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildFeature('সকল লাইভ / আর্কাইভড কোর্স'),
          _buildFeature('বিষয়ভিত্তিক মডেল টেস্ট'),
          _buildFeature('বিষয়ভিত্তিক অনুশীলন'),
          _buildFeature('প্রশ্নব্যাংক / জব সলিউশন'),
          _buildFeature('সার্চ অপশন'),
          _buildFeature('প্রিয় প্রশ্ন মার্ক অপশন'),
        ],
      ),
    );
  }

  Widget _buildFeature(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check, color: AppColors.success, size: 14),
          const SizedBox(width: 6),
          Expanded(child: Text(text, style: const TextStyle(color: Colors.white70, fontSize: 11))),
        ],
      ),
    );
  }
}