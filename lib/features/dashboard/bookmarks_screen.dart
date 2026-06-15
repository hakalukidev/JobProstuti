import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../core/services/api_service.dart';
import '../../models/question_model.dart';
import '../../widgets/common/custom_appbar.dart';
import '../../widgets/common/custom_button.dart';

final bookmarksListProvider = FutureProvider.autoDispose<List<QuestionModel>>((ref) async {
  final api = ref.read(apiServiceProvider);
  final data = await api.getBookmarks();
  return (data['data'] as List<dynamic>? ?? [])
      .map((e) => QuestionModel.fromJson(e as Map<String, dynamic>))
      .toList();
});

class BookmarksScreen extends ConsumerWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarksAsync = ref.watch(bookmarksListProvider);

    return Scaffold(
      appBar: const AppBarWidget(title: 'বুকমার্ক'),
      body: bookmarksAsync.when(
        data: (questions) {
          if (questions.isEmpty) {
            return const EmptyStateWidget(
              title: 'কোনো বুকমার্ক নেই',
              subtitle: 'প্রশ্নব্যাংক থেকে প্রশ্ন বুকমার্ক করুন',
              icon: Icons.bookmark_outline,
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: questions.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) => _BookmarkCard(
              question: questions[i],
              onRemove: () async {
                await ref.read(apiServiceProvider).removeBookmark(questions[i].id);
                ref.invalidate(bookmarksListProvider);
              },
            ),
          );
        },
        loading: () => ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: 5,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, __) => const SkeletonBox(height: 110, borderRadius: 12),
        ),
        error: (e, _) => AppErrorWidget(message: e.toString(), fullScreen: true),
      ),
    );
  }
}

class _BookmarkCard extends StatefulWidget {
  final QuestionModel question;
  final VoidCallback onRemove;
  const _BookmarkCard({required this.question, required this.onRemove});

  @override
  State<_BookmarkCard> createState() => _BookmarkCardState();
}

class _BookmarkCardState extends State<_BookmarkCard> {
  bool _showAnswer = false;

  @override
  Widget build(BuildContext context) {
    final q = widget.question;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.lightGray),
        boxShadow: AppShadows.subtle,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AppBadge(label: q.subject),
                const Spacer(),
                if (q.source != null) Text(q.source!, style: AppTextStyles.bodySmall.copyWith(color: AppColors.mediumGray)),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: widget.onRemove,
                  child: const Icon(Icons.bookmark, color: AppColors.warning, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(q.question, style: AppTextStyles.bodyLarge.copyWith(height: 1.7)),
            const SizedBox(height: 12),
            // Options (read-only, collapsed by default)
            if (_showAnswer)
              ...List.generate(q.options.length, (i) {
                final isCorrect = i == q.correctOptionIndex;
                return Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isCorrect ? AppColors.success.withOpacity(0.1) : AppColors.background,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    border: Border.all(color: isCorrect ? AppColors.success : AppColors.lightGray),
                  ),
                  child: Row(
                    children: [
                      Text(['ক', 'খ', 'গ', 'ঘ'][i], style: AppTextStyles.bodySmall.copyWith(color: isCorrect ? AppColors.success : AppColors.mediumGray, fontWeight: FontWeight.w700)),
                      const SizedBox(width: 10),
                      Expanded(child: Text(q.options[i], style: AppTextStyles.bodySmall.copyWith(color: isCorrect ? AppColors.success : AppColors.darkGray, fontWeight: isCorrect ? FontWeight.w600 : FontWeight.normal))),
                      if (isCorrect) const Icon(Icons.check_circle, color: AppColors.success, size: 16),
                    ],
                  ),
                );
              }),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () => setState(() => _showAnswer = !_showAnswer),
              icon: Icon(_showAnswer ? Icons.visibility_off : Icons.visibility, size: 15),
              label: Text(_showAnswer ? 'উত্তর লুকান' : 'উত্তর দেখুন', style: AppTextStyles.bodySmall),
              style: TextButton.styleFrom(foregroundColor: AppColors.primary, padding: EdgeInsets.zero, minimumSize: Size.zero),
            ),
          ],
        ),
      ),
    );
  }
}