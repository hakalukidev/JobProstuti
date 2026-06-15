import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../app/theme.dart';
import '../../core/services/api_service.dart';
import '../../models/question_model.dart';
import '../../widgets/common/custom_appbar.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/responsive_layout.dart';

final _questionPageProvider = StateProvider<int>((ref) => 1);
final _selectedSubjectProvider = StateProvider<String?>((ref) => null);
final _searchQueryProvider = StateProvider<String>((ref) => '');

final questionsListProvider = FutureProvider.autoDispose<List<QuestionModel>>((ref) async {
  final api = ref.read(apiServiceProvider);
  final page = ref.watch(_questionPageProvider);
  final subject = ref.watch(_selectedSubjectProvider);
  final search = ref.watch(_searchQueryProvider);

  final data = await api.getQuestions(
    page: page,
    subjectId: subject,
    search: search.isEmpty ? null : search,
  );
  return (data['data'] as List<dynamic>? ?? [])
      .map((e) => QuestionModel.fromJson(e as Map<String, dynamic>))
      .toList();
});

class QuestionBankScreen extends ConsumerStatefulWidget {
  const QuestionBankScreen({super.key});

  @override
  ConsumerState<QuestionBankScreen> createState() => _QuestionBankScreenState();
}

class _QuestionBankScreenState extends ConsumerState<QuestionBankScreen> {
  final _searchCtrl = TextEditingController();

  static const _subjects = [
    'সব বিষয়', 'বাংলা', 'ইংরেজি', 'গণিত', 'সাধারণ জ্ঞান',
    'বাংলাদেশ বিষয়াবলি', 'আন্তর্জাতিক বিষয়াবলি', 'বিজ্ঞান',
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final questionsAsync = ref.watch(questionsListProvider);
    final selectedSubject = ref.watch(_selectedSubjectProvider);
    final isMobile = ResponsiveLayout.isMobile(context);

    return Scaffold(
      appBar: const AppBarWidget(title: 'প্রশ্নব্যাংক'),
      body: Column(
        children: [
          // Filter bar
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Column(
              children: [
                TextField(
                  controller: _searchCtrl,
                  onChanged: (v) => ref.read(_searchQueryProvider.notifier).state = v,
                  decoration: InputDecoration(
                    hintText: 'প্রশ্ন খুঁজুন...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: AppColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    suffixIcon: _searchCtrl.text.isNotEmpty
                        ? IconButton(
                      onPressed: () {
                        _searchCtrl.clear();
                        ref.read(_searchQueryProvider.notifier).state = '';
                      },
                      icon: const Icon(Icons.clear),
                    )
                        : null,
                  ),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _subjects.map((sub) {
                      final isAll = sub == 'সব বিষয়';
                      final isSelected = isAll ? selectedSubject == null : selectedSubject == sub;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(sub),
                          selected: isSelected,
                          onSelected: (_) {
                            ref.read(_selectedSubjectProvider.notifier).state = isAll ? null : sub;
                          },
                          selectedColor: AppColors.primary,
                          labelStyle: TextStyle(color: isSelected ? Colors.white : AppColors.darkGray, fontSize: 12),
                          backgroundColor: AppColors.background,
                          side: BorderSide(color: isSelected ? AppColors.primary : AppColors.lightGray),
                          showCheckmark: false,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          const Divider(height: 1),

          // Questions list
          Expanded(
            child: questionsAsync.when(
              data: (questions) {
                if (questions.isEmpty) {
                  return const EmptyStateWidget(
                    title: 'কোনো প্রশ্ন পাওয়া যায়নি',
                    icon: Icons.search_off,
                  );
                }
                return ListView.separated(
                  padding: EdgeInsets.all(isMobile ? 14 : 20),
                  itemCount: questions.length + 1,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) {
                    if (i == questions.length) {
                      return _PaginationRow();
                    }
                    return _QuestionCard(question: questions[i], index: i);
                  },
                );
              },
              loading: () => ListView.separated(
                padding: const EdgeInsets.all(14),
                itemCount: 8,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, __) => const SkeletonBox(height: 100, borderRadius: 12),
              ),
              error: (e, _) => AppErrorWidget(
                message: e.toString(),
                onRetry: () => ref.invalidate(questionsListProvider),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestionCard extends ConsumerStatefulWidget {
  final QuestionModel question;
  final int index;
  const _QuestionCard({required this.question, required this.index});

  @override
  ConsumerState<_QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends ConsumerState<_QuestionCard> {
  bool _showAnswer = false;
  int? _selectedOption;

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
            // Header
            Row(
              children: [
                AppBadge(label: q.subject, backgroundColor: AppColors.primarySurface, textColor: AppColors.primary),
                const SizedBox(width: 8),
                if (q.topic != null) AppBadge(label: q.topic!, backgroundColor: AppColors.accentLight, textColor: AppColors.accent),
                const Spacer(),
                if (q.source != null)
                  Text(q.source!, style: AppTextStyles.bodySmall.copyWith(color: AppColors.mediumGray)),
                const SizedBox(width: 8),
                // Bookmark button
                GestureDetector(
                  onTap: () async {
                    final api = ref.read(apiServiceProvider);
                    if (q.isBookmarked) {
                      await api.removeBookmark(q.id);
                    } else {
                      await api.addBookmark(q.id);
                    }
                  },
                  child: Icon(
                    q.isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
                    color: q.isBookmarked ? AppColors.warning : AppColors.mediumGray,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Question number + text
            Text(
              '${widget.index + 1}. ${q.question}',
              style: AppTextStyles.bodyLarge.copyWith(height: 1.7),
            ),

            const SizedBox(height: 12),

            // Options
            ...List.generate(q.options.length, (i) {
              final label = ['ক', 'খ', 'গ', 'ঘ'][i];
              final isSelected = _selectedOption == i;
              final isCorrect = _showAnswer && i == q.correctOptionIndex;
              final isWrong = _showAnswer && isSelected && i != q.correctOptionIndex;

              Color bg = AppColors.background;
              Color border = AppColors.lightGray;
              Color textColor = AppColors.darkGray;

              if (isCorrect) { bg = AppColors.success.withOpacity(0.1); border = AppColors.success; textColor = AppColors.success; }
              if (isWrong) { bg = AppColors.error.withOpacity(0.1); border = AppColors.error; textColor = AppColors.error; }
              if (isSelected && !_showAnswer) { bg = AppColors.primarySurface; border = AppColors.primary; textColor = AppColors.primary; }

              return GestureDetector(
                onTap: !_showAnswer ? () => setState(() => _selectedOption = i) : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    border: Border.all(color: border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          color: isCorrect ? AppColors.success : (isWrong ? AppColors.error : (isSelected ? AppColors.primary : AppColors.lightGray)),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(label, style: TextStyle(color: (isCorrect || isWrong || isSelected) ? Colors.white : AppColors.mediumGray, fontSize: 12, fontWeight: FontWeight.w700)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(child: Text(q.options[i], style: AppTextStyles.bodySmall.copyWith(color: textColor))),
                      if (isCorrect) const Icon(Icons.check_circle, color: AppColors.success, size: 18),
                      if (isWrong) const Icon(Icons.cancel, color: AppColors.error, size: 18),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 10),

            // Actions row
            Row(
              children: [
                TextButton.icon(
                  onPressed: () => setState(() => _showAnswer = !_showAnswer),
                  icon: Icon(_showAnswer ? Icons.visibility_off : Icons.visibility, size: 16),
                  label: Text(_showAnswer ? 'উত্তর লুকান' : 'উত্তর দেখুন', style: AppTextStyles.bodySmall),
                  style: TextButton.styleFrom(foregroundColor: AppColors.primary),
                ),
                if (_showAnswer && q.explanation != null) ...[
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (_) => Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('ব্যাখ্যা', style: AppTextStyles.headlineLarge),
                              const SizedBox(height: 12),
                              Text(q.explanation!, style: AppTextStyles.bodyMedium.copyWith(height: 1.7)),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.info_outline, size: 16),
                    label: Text('ব্যাখ্যা', style: AppTextStyles.bodySmall),
                    style: TextButton.styleFrom(foregroundColor: AppColors.info),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PaginationRow extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = ref.watch(_questionPageProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (page > 1)
            OutlinedButton.icon(
              onPressed: () => ref.read(_questionPageProvider.notifier).state = page - 1,
              icon: const Icon(Icons.arrow_back, size: 16),
              label: const Text('আগে'),
            ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Text('পৃষ্ঠা $page', style: AppTextStyles.labelLarge.copyWith(fontSize: 12)),
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: () => ref.read(_questionPageProvider.notifier).state = page + 1,
            icon: const Icon(Icons.arrow_forward, size: 16),
            label: const Text('পরে'),
          ),
        ],
      ),
    );
  }
}