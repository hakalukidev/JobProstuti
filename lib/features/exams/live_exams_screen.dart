import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/routes.dart';
import '../../app/theme.dart';
import '../../models/exam_model.dart';
import '../../repositories/exam_repository.dart';
import '../../widgets/common/custom_appbar.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/responsive_layout.dart';

class LiveExamsScreen extends ConsumerWidget {
  const LiveExamsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final examsAsync = ref.watch(liveExamsProvider);
    final isMobile = ResponsiveLayout.isMobile(context);

    return Scaffold(
      appBar: const AppBarWidget(title: 'লাইভ পরীক্ষা'),
      body: Column(
        children: [
          // Header banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
            child: Column(
              children: [
                Text(
                  'লাইভ পরীক্ষা',
                  style: AppTextStyles.displaySmall.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  'রিয়েল-টাইম পরীক্ষায় অংশ নিন এবং র‍্যাংক জানুন',
                  style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Model test CTA
          Padding(
            padding: const EdgeInsets.all(16),
            child: OutlinedButton.icon(
              onPressed: () => context.go(AppRoutes.modelTest),
              icon: const Icon(Icons.add),
              label: const Text('নিজস্ব মডেল টেস্ট তৈরি করুন'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ),
          const Divider(height: 1),

          Expanded(
            child: examsAsync.when(
              data: (exams) {
                if (exams.isEmpty) {
                  return const EmptyStateWidget(
                    title: 'কোনো লাইভ পরীক্ষা নেই',
                    subtitle: 'নতুন পরীক্ষার জন্য অপেক্ষা করুন',
                    icon: Icons.event_available,
                  );
                }
                return ListView.separated(
                  padding: EdgeInsets.all(isMobile ? 16 : 24),
                  itemCount: exams.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (_, i) => _ExamCard(exam: exams[i]),
                );
              },
              loading: () => ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: 5,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (_, __) => const SkeletonBox(height: 120, borderRadius: 16),
              ),
              error: (e, _) => AppErrorWidget(
                message: e.toString(),
                onRetry: () => ref.invalidate(liveExamsProvider),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go(AppRoutes.questionBank),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.quiz, color: Colors.white),
        label: Text('প্রশ্নব্যাংক', style: AppTextStyles.labelLarge),
      ),
    );
  }
}

class _ExamCard extends StatelessWidget {
  final ExamModel exam;
  const _ExamCard({required this.exam});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isUpcoming = exam.scheduledAt != null && exam.scheduledAt!.isAfter(now);
    final isLive = exam.isRunning;

    return GestureDetector(
      onTap: () => context.go('/exams/${exam.id}'),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: isLive ? AppColors.error.withOpacity(0.4) : AppColors.lightGray,
            width: isLive ? 1.5 : 1,
          ),
          boxShadow: AppShadows.subtle,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(exam.title, style: AppTextStyles.headlineSmall),
                ),
                _StatusBadge(exam: exam),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 16,
              runSpacing: 6,
              children: [
                _InfoItem(Icons.quiz_outlined, '${exam.totalQuestions} প্রশ্ন'),
                _InfoItem(Icons.timer_outlined, '${exam.timeLimitMinutes} মিনিট'),
                _InfoItem(Icons.star_outlined, '${exam.totalMarks.toInt()} নম্বর'),
                if (exam.category != null)
                  _InfoItem(Icons.category_outlined, exam.category!),
              ],
            ),
            if (exam.scheduledAt != null) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 14, color: AppColors.mediumGray),
                  const SizedBox(width: 6),
                  Text(
                    DateFormat('dd MMM yyyy, hh:mm a').format(exam.scheduledAt!),
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ],
            const SizedBox(height: 14),
            Row(
              children: [
                _InfoItem(Icons.people_outline, '${exam.attemptCount} জন অংশ নিয়েছে'),
                const Spacer(),
                if (exam.hasAttempted)
                  AppBadge(
                    label: 'সম্পন্ন',
                    backgroundColor: AppColors.success.withOpacity(0.1),
                    textColor: AppColors.success,
                  )
                else
                  PrimaryButton(
                    label: isLive ? 'এখনই দিন →' : (isUpcoming ? 'রিমাইন্ডার সেট' : 'শুরু করুন'),
                    onPressed: () {
                      if (isLive || !isUpcoming) {
                        context.go('/exams/${exam.id}/attempt');
                      }
                    },
                    height: 36,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final ExamModel exam;
  const _StatusBadge({required this.exam});

  @override
  Widget build(BuildContext context) {
    if (exam.isRunning) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 7,
              height: 7,
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Text('লাইভ', style: AppTextStyles.bodySmall.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
          ],
        ),
      );
    }
    if (exam.hasEnded) {
      return AppBadge(label: 'শেষ হয়েছে', backgroundColor: AppColors.lightGray, textColor: AppColors.mediumGray);
    }
    return AppBadge(label: 'আসছে', backgroundColor: AppColors.accentLight, textColor: AppColors.accent);
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoItem(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.mediumGray),
        const SizedBox(width: 4),
        Text(label, style: AppTextStyles.bodySmall),
      ],
    );
  }
}