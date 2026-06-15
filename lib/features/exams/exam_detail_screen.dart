import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../repositories/exam_repository.dart';
import '../../widgets/common/custom_button.dart';

class ExamDetailScreen extends ConsumerWidget {
  final String examId;
  const ExamDetailScreen({super.key, required this.examId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final examAsync = ref.watch(examDetailProvider(examId));

    return Scaffold(
      appBar: AppBar(title: const Text('পরীক্ষার বিবরণ')),
      body: examAsync.when(
        data: (exam) => SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(exam.title, style: AppTextStyles.headlineLarge.copyWith(color: Colors.white)),
                    const SizedBox(height: 8),
                    if (exam.description.isNotEmpty)
                      Text(exam.description, style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70)),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 16,
                      runSpacing: 10,
                      children: [
                        _WhiteStat(Icons.quiz, '${exam.totalQuestions} প্রশ্ন'),
                        _WhiteStat(Icons.timer, '${exam.timeLimitMinutes} মিনিট'),
                        _WhiteStat(Icons.star, '${exam.totalMarks.toInt()} নম্বর'),
                        _WhiteStat(Icons.remove_circle_outline, '-${exam.negativeMarks} নেগেটিভ'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Rules
              Text('পরীক্ষার নিয়মাবলী', style: AppTextStyles.headlineLarge),
              const SizedBox(height: 14),
              ...[
                'প্রতিটি সঠিক উত্তরের জন্য ${exam.totalMarks / exam.totalQuestions} নম্বর পাবেন।',
                'প্রতিটি ভুল উত্তরের জন্য ${exam.negativeMarks} নম্বর কাটা যাবে।',
                'উত্তর না দিলে কোনো নম্বর কাটা যাবে না।',
                'পরীক্ষা শুরু হলে ব্রাউজার বা অ্যাপ বন্ধ করা যাবে না।',
                'প্রশ্নে "পরে দেখব" চিহ্ন দিয়ে রাখতে পারবেন।',
                'নির্ধারিত সময় শেষে স্বয়ংক্রিয়ভাবে জমা হয়ে যাবে।',
              ].map((rule) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Icon(Icons.info_outline, size: 16, color: AppColors.primary),
                    ),
                    const SizedBox(width: 10),
                    Expanded(child: Text(rule, style: AppTextStyles.bodyMedium)),
                  ],
                ),
              )),

              const SizedBox(height: 32),
              GradientButton(
                label: 'পরীক্ষা শুরু করুন →',
                width: double.infinity,
                onPressed: () => context.go('/exams/$examId/attempt'),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  'পরীক্ষা শুরু করার পর ব্যাক করা যাবে না',
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.warning),
                ),
              ),
            ],
          ),
        ),
        loading: () => const LoadingWidget(fullScreen: true),
        error: (e, _) => AppErrorWidget(message: e.toString(), fullScreen: true),
      ),
    );
  }
}

class _WhiteStat extends StatelessWidget {
  final IconData icon;
  final String label;
  const _WhiteStat(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white70, size: 16),
        const SizedBox(width: 6),
        Text(label, style: AppTextStyles.bodySmall.copyWith(color: Colors.white)),
      ],
    );
  }
}