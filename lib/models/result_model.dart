class ResultModel {
  final String id;
  final String examId;
  final String examTitle;
  final String userId;
  final int totalQuestions;
  final int attemptedQuestions;
  final int correctAnswers;
  final int wrongAnswers;
  final int skippedAnswers;
  final double totalMarks;
  final double obtainedMarks;
  final double negativeMarks;
  final double netMarks;
  final double percentage;
  final int rank;
  final int totalParticipants;
  final int timeTakenSeconds;
  final DateTime submittedAt;
  final List<QuestionResult> questionResults;

  const ResultModel({
    required this.id,
    required this.examId,
    required this.examTitle,
    required this.userId,
    required this.totalQuestions,
    required this.attemptedQuestions,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.skippedAnswers,
    required this.totalMarks,
    required this.obtainedMarks,
    required this.negativeMarks,
    required this.netMarks,
    required this.percentage,
    this.rank = 0,
    this.totalParticipants = 0,
    required this.timeTakenSeconds,
    required this.submittedAt,
    this.questionResults = const [],
  });

  factory ResultModel.fromJson(Map<String, dynamic> json) {
    return ResultModel(
      id: json['id']?.toString() ?? '',
      examId: json['exam_id']?.toString() ?? '',
      examTitle: json['exam_title'] as String? ?? '',
      userId: json['user_id']?.toString() ?? '',
      totalQuestions: (json['total_questions'] as num?)?.toInt() ?? 0,
      attemptedQuestions: (json['attempted_questions'] as num?)?.toInt() ?? 0,
      correctAnswers: (json['correct_answers'] as num?)?.toInt() ?? 0,
      wrongAnswers: (json['wrong_answers'] as num?)?.toInt() ?? 0,
      skippedAnswers: (json['skipped_answers'] as num?)?.toInt() ?? 0,
      totalMarks: (json['total_marks'] as num?)?.toDouble() ?? 0,
      obtainedMarks: (json['obtained_marks'] as num?)?.toDouble() ?? 0,
      negativeMarks: (json['negative_marks'] as num?)?.toDouble() ?? 0,
      netMarks: (json['net_marks'] as num?)?.toDouble() ?? 0,
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0,
      rank: (json['rank'] as num?)?.toInt() ?? 0,
      totalParticipants: (json['total_participants'] as num?)?.toInt() ?? 0,
      timeTakenSeconds: (json['time_taken_seconds'] as num?)?.toInt() ?? 0,
      submittedAt: json['submitted_at'] != null
          ? DateTime.tryParse(json['submitted_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      questionResults: (json['question_results'] as List<dynamic>?)
          ?.map((e) => QuestionResult.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  String get grade {
    if (percentage >= 90) return 'A+';
    if (percentage >= 80) return 'A';
    if (percentage >= 70) return 'B+';
    if (percentage >= 60) return 'B';
    if (percentage >= 50) return 'C';
    return 'F';
  }

  Duration get timeTaken => Duration(seconds: timeTakenSeconds);
}

class QuestionResult {
  final String questionId;
  final int? selectedOptionIndex;
  final int correctOptionIndex;
  final bool isCorrect;
  final bool isSkipped;
  final double marks;

  const QuestionResult({
    required this.questionId,
    this.selectedOptionIndex,
    required this.correctOptionIndex,
    required this.isCorrect,
    required this.isSkipped,
    required this.marks,
  });

  factory QuestionResult.fromJson(Map<String, dynamic> json) {
    return QuestionResult(
      questionId: json['question_id']?.toString() ?? '',
      selectedOptionIndex: (json['selected_option_index'] as num?)?.toInt(),
      correctOptionIndex: (json['correct_option_index'] as num?)?.toInt() ?? 0,
      isCorrect: json['is_correct'] as bool? ?? false,
      isSkipped: json['is_skipped'] as bool? ?? false,
      marks: (json['marks'] as num?)?.toDouble() ?? 0,
    );
  }
}