import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class PhoneMockup extends StatelessWidget {
  const PhoneMockup({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 260,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 30, offset: Offset(0, 10))],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('জব প্রস্তুতি', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text('🔔', style: TextStyle(fontSize: 16)),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: AppColors.blue, borderRadius: BorderRadius.circular(8)),
                child: const Text('জব প্রস্তুতি | ৪৫ তম পরীক্ষা', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(8)),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('বাংলাদেশ বিষয়াবলী - ১০', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                        Text('প্রশ্ন ৩০ টি · ৭ মিনিট', style: TextStyle(color: AppColors.textMuted, fontSize: 10)),
                      ],
                    ),
                    Text('⏱ 00:58:44', style: TextStyle(color: AppColors.blue, fontSize: 11, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}