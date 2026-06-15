import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../app/theme.dart';
import '../../core/utils/helpers.dart';
import '../../repositories/exam_repository.dart';
import '../../widgets/common/custom_button.dart';

class ExamResultScreen extends ConsumerWidget {
  final String examId;
  final Map<String, dynamic>? resultData;

  const ExamResultScreen({super.key, required this.examId, this.resultData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: ref.read(examRepositoryProvider).getExamResult(examId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: LoadingWidget(
              fullScreen: true,
              message: 'ফলাফল লোড হচ্ছে...',
            ),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: AppErrorWidget(
              message: snapshot.error.toString(),
              fullScreen: true,
            ),
          );
        }

        final result = snapshot.data!;
        final grade = result.grade;
        final gradeColor = AppHelpers.getGradeColor(result.percentage);

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 60, 20, 32),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [gradeColor.withOpacity(0.8), gradeColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white38, width: 3),
                        ),
                        child: Center(
                          child: Text(
                            grade,
                            style: AppTextStyles.displayLarge.copyWith(
                              fontSize: 40,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        result.examTitle,
                        style: AppTextStyles.headlineLarge.copyWith(
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${result.percentage.toStringAsFixed(1)}% নম্বর পেয়েছেন',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                      if (result.rank > 0) ...[
                        const SizedBox(height: 6),
                        Text(
                          'র‍্যাংক: ${result.rank} / ${result.totalParticipants}',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Stats grid
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 2,
                        children: [
                          _ResultStat(
                            label: 'সঠিক উত্তর',
                            value: '${result.correctAnswers}',
                            color: AppColors.success,
                            icon: Icons.check_circle,
                          ),
                          _ResultStat(
                            label: 'ভুল উত্তর',
                            value: '${result.wrongAnswers}',
                            color: AppColors.error,
                            icon: Icons.cancel,
                          ),
                          _ResultStat(
                            label: 'উত্তর দেওয়া হয়নি',
                            value: '${result.skippedAnswers}',
                            color: AppColors.mediumGray,
                            icon: Icons.remove_circle,
                          ),
                          _ResultStat(
                            label: 'নেগেটিভ মার্কস',
                            value: '-${result.negativeMarks}',
                            color: AppColors.warning,
                            icon: Icons.remove,
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Score breakdown
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                          border: Border.all(color: AppColors.lightGray),
                        ),
                        child: Column(
                          children: [
                            _ScoreRow(
                              'মোট নম্বর',
                              '${result.totalMarks.toInt()}',
                            ),
                            _ScoreRow(
                              'প্রাপ্ত নম্বর',
                              '${result.obtainedMarks.toStringAsFixed(2)}',
                            ),
                            _ScoreRow(
                              'নেগেটিভ মার্কস',
                              '-${result.negativeMarks.toStringAsFixed(2)}',
                              color: AppColors.error,
                            ),
                            const Divider(),
                            _ScoreRow(
                              'নিট নম্বর',
                              result.netMarks.toStringAsFixed(2),
                              style: AppTextStyles.headlineSmall.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _ScoreRow(
                              'সময় লেগেছে',
                              AppHelpers.formatDuration(result.timeTaken),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Actions
                      PrimaryButton(
                        label: 'উত্তরপত্র দেখুন',
                        onPressed: () {},
                        width: double.infinity,
                        icon: const Icon(Icons.visibility, size: 18),
                      ),
                      const SizedBox(height: 12),
                      SecondaryButton(
                        label: 'আবার পরীক্ষা দিন',
                        onPressed: () => context.go('/exams/$examId'),
                        width: double.infinity,
                        height: 48,
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () => context.go(AppRoutes.home),
                        child: const Text('হোমে ফিরে যান'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ResultStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _ResultStat({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: AppTextStyles.headlineLarge.copyWith(color: color),
              ),
              Text(label, style: AppTextStyles.bodySmall),
            ],
          ),
        ],
      ),
    );
  }
}

class _ScoreRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  final TextStyle? style;

  const _ScoreRow(this.label, this.value, {this.color, this.style});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyMedium),
          Text(
            value,
            style:
                style ??
                AppTextStyles.bodyMedium.copyWith(
                  color: color ?? AppColors.black,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
