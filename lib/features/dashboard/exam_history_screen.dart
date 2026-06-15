import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/theme.dart';
import '../../core/utils/helpers.dart';
import '../../repositories/user_repository.dart';
import '../../widgets/common/custom_appbar.dart';
import '../../widgets/common/custom_button.dart';

class ExamHistoryScreen extends ConsumerWidget {
  const ExamHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(examHistoryProvider);

    return Scaffold(
      appBar: const AppBarWidget(title: 'পরীক্ষার ইতিহাস'),
      body: historyAsync.when(
        data: (results) {
          if (results.isEmpty) {
            return const EmptyStateWidget(
              title: 'এখনো কোনো পরীক্ষা দেননি',
              subtitle: 'লাইভ পরীক্ষা বা মডেল টেস্ট দিন',
              icon: Icons.quiz_outlined,
            );
          }
          return Column(
            children: [
              // Summary bar
              Container(
                padding: const EdgeInsets.all(16),
                color: AppColors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _SummaryChip(
                      label: 'মোট পরীক্ষা',
                      value: '${results.length}',
                      color: AppColors.primary,
                    ),
                    _SummaryChip(
                      label: 'গড় নম্বর',
                      value: '${(results.fold<double>(0, (sum, r) => sum + r.percentage) / results.length).toStringAsFixed(1)}%',
                      color: AppColors.warning,
                    ),
                    _SummaryChip(
                      label: 'সর্বোচ্চ',
                      value: '${results.map((r) => r.percentage).reduce((a, b) => a > b ? a : b).toStringAsFixed(1)}%',
                      color: AppColors.success,
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: results.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) => _ResultCard(result: results[i]),
                ),
              ),
            ],
          );
        },
        loading: () => ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: 6,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, __) => const SkeletonBox(height: 90, borderRadius: 12),
        ),
        error: (e, _) => AppErrorWidget(
          message: e.toString(),
          fullScreen: true,
          onRetry: () => ref.invalidate(examHistoryProvider),
        ),
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _SummaryChip({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.headlineLarge.copyWith(color: color, fontSize: 20)),
        Text(label, style: AppTextStyles.bodySmall),
      ],
    );
  }
}

class _ResultCard extends StatelessWidget {
  final dynamic result;
  const _ResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final pct = (result.percentage as double?) ?? 0;
    final grade = AppHelpers.getScoreGrade(pct);
    final color = AppHelpers.getGradeColor(pct);

    return GestureDetector(
      onTap: () => context.go('/exams/${result.examId}/result'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.lightGray),
          boxShadow: AppShadows.subtle,
        ),
        child: Row(
          children: [
            // Grade circle
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: color.withOpacity(0.3), width: 2),
              ),
              child: Center(
                child: Text(grade, style: AppTextStyles.headlineMedium.copyWith(color: color)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result.examTitle ?? '',
                    style: AppTextStyles.headlineSmall.copyWith(fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '${pct.toStringAsFixed(1)}%  ·  ',
                        style: AppTextStyles.bodySmall.copyWith(color: color, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '${result.correctAnswers}/${result.totalQuestions} সঠিক',
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    result.submittedAt != null
                        ? DateFormat('dd MMM yyyy').format(result.submittedAt)
                        : '',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.mediumGray),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${result.netMarks?.toStringAsFixed(1) ?? 0}',
                  style: AppTextStyles.headlineSmall.copyWith(color: color, fontSize: 18),
                ),
                Text('নেট মার্কস', style: AppTextStyles.bodySmall),
                const SizedBox(height: 4),
                const Icon(Icons.chevron_right, color: AppColors.mediumGray, size: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }
}