import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../models/question_model.dart';
import '../../repositories/exam_repository.dart';
import '../../widgets/common/custom_button.dart';

// State
class ExamAttemptState {
  final List<QuestionModel> questions;
  final Map<String, UserAnswer> answers;
  final int currentIndex;
  final int remainingSeconds;
  final bool isSubmitting;
  final bool submitted;

  const ExamAttemptState({
    this.questions = const [],
    this.answers = const {},
    this.currentIndex = 0,
    this.remainingSeconds = 0,
    this.isSubmitting = false,
    this.submitted = false,
  });

  ExamAttemptState copyWith({
    List<QuestionModel>? questions,
    Map<String, UserAnswer>? answers,
    int? currentIndex,
    int? remainingSeconds,
    bool? isSubmitting,
    bool? submitted,
  }) => ExamAttemptState(
    questions: questions ?? this.questions,
    answers: answers ?? this.answers,
    currentIndex: currentIndex ?? this.currentIndex,
    remainingSeconds: remainingSeconds ?? this.remainingSeconds,
    isSubmitting: isSubmitting ?? this.isSubmitting,
    submitted: submitted ?? this.submitted,
  );

  int get answeredCount => answers.values.where((a) => a.isAnswered).length;
  int get markedCount =>
      answers.values.where((a) => a.isMarkedForReview).length;
  QuestionModel? get currentQuestion =>
      questions.isEmpty ? null : questions[currentIndex];
}

class ExamAttemptNotifier extends StateNotifier<ExamAttemptState> {
  final ExamRepository _repo;
  final String examId;
  Timer? _timer;
  int _startSeconds = 0;
  DateTime? _startedAt;

  ExamAttemptNotifier(this._repo, this.examId)
    : super(const ExamAttemptState()) {
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final questions = await _repo.getExamQuestions(examId);
    final exam = await _repo.getExamDetail(examId);
    final seconds = exam.timeLimitMinutes * 60;
    _startSeconds = seconds;
    _startedAt = DateTime.now();

    state = state.copyWith(
      questions: questions,
      remainingSeconds: seconds,
      answers: {for (final q in questions) q.id: UserAnswer(questionId: q.id)},
    );

    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.remainingSeconds <= 0) {
        _timer?.cancel();
        _submitExam();
        return;
      }
      state = state.copyWith(remainingSeconds: state.remainingSeconds - 1);
    });
  }

  void selectAnswer(String questionId, int optionIndex) {
    final updated = Map<String, UserAnswer>.from(state.answers);
    final current = updated[questionId] ?? UserAnswer(questionId: questionId);
    updated[questionId] = UserAnswer(
      questionId: questionId,
      selectedOptionIndex: current.selectedOptionIndex == optionIndex
          ? null
          : optionIndex,
      isMarkedForReview: current.isMarkedForReview,
    );
    state = state.copyWith(answers: updated);
  }

  void toggleMarkForReview(String questionId) {
    final updated = Map<String, UserAnswer>.from(state.answers);
    final current = updated[questionId] ?? UserAnswer(questionId: questionId);
    updated[questionId] = UserAnswer(
      questionId: questionId,
      selectedOptionIndex: current.selectedOptionIndex,
      isMarkedForReview: !current.isMarkedForReview,
    );
    state = state.copyWith(answers: updated);
  }

  void goToQuestion(int index) {
    state = state.copyWith(currentIndex: index);
  }

  void nextQuestion() {
    if (state.currentIndex < state.questions.length - 1) {
      state = state.copyWith(currentIndex: state.currentIndex + 1);
    }
  }

  void prevQuestion() {
    if (state.currentIndex > 0) {
      state = state.copyWith(currentIndex: state.currentIndex - 1);
    }
  }

  Future<void> _submitExam() async {
    if (state.isSubmitting || state.submitted) return;
    _timer?.cancel();
    state = state.copyWith(isSubmitting: true);

    try {
      final timeTaken = _startedAt != null
          ? DateTime.now().difference(_startedAt!).inSeconds
          : _startSeconds;

      await _repo.submitExam(
        examId: examId,
        answers: state.answers.values.toList(),
        timeTakenSeconds: timeTaken,
      );
      state = state.copyWith(submitted: true, isSubmitting: false);
    } catch (e) {
      state = state.copyWith(isSubmitting: false);
      rethrow;
    }
  }

  Future<void> submit() => _submitExam();

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final examAttemptProvider =
    StateNotifierProvider.family<ExamAttemptNotifier, ExamAttemptState, String>(
      (ref, examId) =>
          ExamAttemptNotifier(ref.read(examRepositoryProvider), examId),
    );

class ExamAttemptScreen extends ConsumerStatefulWidget {
  final String examId;
  const ExamAttemptScreen({super.key, required this.examId});

  @override
  ConsumerState<ExamAttemptScreen> createState() => _ExamAttemptScreenState();
}

class _ExamAttemptScreenState extends ConsumerState<ExamAttemptScreen> {
  bool _showPanel = false;

  @override
  Widget build(BuildContext context) {
    final examState = ref.watch(examAttemptProvider(widget.examId));
    final notifier = ref.read(examAttemptProvider(widget.examId).notifier);

    if (examState.submitted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.go('/exams/${widget.examId}/result');
      });
    }

    if (examState.questions.isEmpty) {
      return const Scaffold(body: LoadingWidget(fullScreen: true));
    }

    final question = examState.currentQuestion!;
    final userAnswer = examState.answers[question.id];
    final mins = examState.remainingSeconds ~/ 60;
    final secs = examState.remainingSeconds % 60;
    final isLowTime = examState.remainingSeconds < 300;

    return PopScope(
      canPop: false,
      onPopInvoked: (_) => _confirmExit(context, notifier),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              // Timer
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isLowTime
                      ? AppColors.error.withOpacity(0.1)
                      : AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.timer,
                      size: 16,
                      color: isLowTime ? AppColors.error : AppColors.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}',
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: isLowTime ? AppColors.error : AppColors.primary,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                '${examState.currentIndex + 1}/${examState.questions.length}',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.mediumGray,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () => setState(() => _showPanel = !_showPanel),
              icon: Icon(
                _showPanel ? Icons.grid_view : Icons.grid_view_outlined,
              ),
              tooltip: 'প্রশ্ন প্যানেল',
            ),
            TextButton(
              onPressed: () => _confirmSubmit(context, notifier),
              child: Text(
                'জমা দিন',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        body: Row(
          children: [
            // Main question area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Question header
                    Row(
                      children: [
                        AppBadge(label: 'প্রশ্ন ${examState.currentIndex + 1}'),
                        if (question.source != null) ...[
                          const SizedBox(width: 8),
                          AppBadge(
                            label: question.source!,
                            backgroundColor: AppColors.accentLight,
                            textColor: AppColors.accent,
                          ),
                        ],
                        const Spacer(),
                        IconButton(
                          onPressed: () =>
                              notifier.toggleMarkForReview(question.id),
                          icon: Icon(
                            userAnswer?.isMarkedForReview == true
                                ? Icons.bookmark
                                : Icons.bookmark_outline,
                            color: userAnswer?.isMarkedForReview == true
                                ? AppColors.warning
                                : AppColors.mediumGray,
                          ),
                          tooltip: 'পরে দেখব',
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Question text
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        border: Border.all(color: AppColors.lightGray),
                      ),
                      child: Text(
                        question.question,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontSize: 16,
                          height: 1.8,
                        ),
                      ),
                    ),

                    if (question.imageUrl != null) ...[
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        child: Image.network(
                          question.imageUrl!,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),

                    // Options
                    ...List.generate(question.options.length, (i) {
                      final isSelected = userAnswer?.selectedOptionIndex == i;
                      final optLabel = ['ক', 'খ', 'গ', 'ঘ'][i];
                      return GestureDetector(
                        onTap: () => notifier.selectAnswer(question.id, i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primarySurface
                                : AppColors.white,
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.lightGray,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.background,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    optLabel,
                                    style: AppTextStyles.headlineSmall.copyWith(
                                      fontSize: 13,
                                      color: isSelected
                                          ? Colors.white
                                          : AppColors.darkGray,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  question.options[i],
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.darkGray,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),

                    const SizedBox(height: 24),

                    // Navigation
                    Row(
                      children: [
                        if (examState.currentIndex > 0)
                          SecondaryButton(
                            label: '← আগের প্রশ্ন',
                            onPressed: notifier.prevQuestion,
                            height: 44,
                          ),
                        const Spacer(),
                        if (examState.currentIndex <
                            examState.questions.length - 1)
                          PrimaryButton(
                            label: 'পরের প্রশ্ন →',
                            onPressed: notifier.nextQuestion,
                            height: 44,
                          )
                        else
                          GradientButton(
                            label: 'পরীক্ষা জমা দিন',
                            onPressed: () => _confirmSubmit(context, notifier),
                            isLoading: examState.isSubmitting,
                            height: 44,
                          ),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),

            // Side panel (desktop)
            if (_showPanel && MediaQuery.of(context).size.width >= 600)
              _QuestionPanel(
                examState: examState,
                onSelect: notifier.goToQuestion,
              ),
          ],
        ),

        // Bottom question panel toggle (mobile)
        bottomSheet: _showPanel && MediaQuery.of(context).size.width < 600
            ? Container(
                height: 220,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  boxShadow: AppShadows.elevated,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.lightGray,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: _QuestionPanel(
                        examState: examState,
                        onSelect: (i) {
                          notifier.goToQuestion(i);
                          setState(() => _showPanel = false);
                        },
                      ),
                    ),
                  ],
                ),
              )
            : null,
      ),
    );
  }

  void _confirmSubmit(BuildContext context, ExamAttemptNotifier notifier) {
    final state = ref.read(examAttemptProvider(widget.examId));
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('পরীক্ষা জমা দিন'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('মোট প্রশ্ন: ${state.questions.length}'),
            Text('উত্তর দেওয়া: ${state.answeredCount}'),
            Text('বাকি: ${state.questions.length - state.answeredCount}'),
            const SizedBox(height: 12),
            const Text('আপনি কি নিশ্চিতভাবে জমা দিতে চান?'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('না'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await notifier.submit();
              if (mounted) context.go('/exams/${widget.examId}/result');
            },
            child: const Text('হ্যাঁ, জমা দিন'),
          ),
        ],
      ),
    );
  }

  void _confirmExit(BuildContext context, ExamAttemptNotifier notifier) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('পরীক্ষা ছেড়ে যাবেন?'),
        content: const Text('এখন বের হলে পরীক্ষার অগ্রগতি হারিয়ে যাবে।'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('না'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/exams');
            },
            child: const Text('হ্যাঁ, বের হই'),
          ),
        ],
      ),
    );
  }
}

class _QuestionPanel extends StatelessWidget {
  final ExamAttemptState examState;
  final ValueChanged<int> onSelect;

  const _QuestionPanel({required this.examState, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      color: AppColors.white,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'প্রশ্ন নেভিগেশন',
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          // Legend
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _Legend(color: AppColors.primary, label: 'বর্তমান'),
              _Legend(color: AppColors.success, label: 'উত্তর দেওয়া'),
              _Legend(color: AppColors.warning, label: 'চিহ্নিত'),
              _Legend(color: AppColors.lightGray, label: 'বাকি'),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
              ),
              itemCount: examState.questions.length,
              itemBuilder: (_, i) {
                final q = examState.questions[i];
                final ans = examState.answers[q.id];
                final isCurrent = i == examState.currentIndex;
                final isAnswered = ans?.isAnswered == true;
                final isMarked = ans?.isMarkedForReview == true;

                Color bg = AppColors.lightGray;
                if (isCurrent)
                  bg = AppColors.primary;
                else if (isMarked)
                  bg = AppColors.warning;
                else if (isAnswered)
                  bg = AppColors.success;

                return GestureDetector(
                  onTap: () => onSelect(i),
                  child: Container(
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Text(
                        '${i + 1}',
                        style: TextStyle(
                          color: (isCurrent || isAnswered || isMarked)
                              ? Colors.white
                              : AppColors.mediumGray,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(),
          Text(
            'উত্তর দেওয়া: ${examState.answeredCount}/${examState.questions.length}',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 10)),
      ],
    );
  }
}
