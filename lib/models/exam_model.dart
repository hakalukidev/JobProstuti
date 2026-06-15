// exam_model.dart
class ExamModel {
  final String id;
  final String title;
  final String description;
  final String examType; // 'live', 'model_test', 'question_bank'
  final int totalQuestions;
  final int timeLimitMinutes;
  final double totalMarks;
  final double negativeMarks;
  final double passingMarks;
  final DateTime? scheduledAt;
  final DateTime? endsAt;
  final bool isLive;
  final bool hasStarted;
  final bool hasEnded;
  final String? courseId;
  final String? category;
  final String? subject;
  final int attemptCount;
  final bool hasAttempted;
  final String imageUrl;
  final DateTime createdAt;

  const ExamModel({
    required this.id,
    required this.title,
    this.description = '',
    required this.examType,
    required this.totalQuestions,
    required this.timeLimitMinutes,
    required this.totalMarks,
    this.negativeMarks = 0.25,
    this.passingMarks = 0,
    this.scheduledAt,
    this.endsAt,
    this.isLive = false,
    this.hasStarted = false,
    this.hasEnded = false,
    this.courseId,
    this.category,
    this.subject,
    this.attemptCount = 0,
    this.hasAttempted = false,
    this.imageUrl = '',
    required this.createdAt,
  });

  factory ExamModel.fromJson(Map<String, dynamic> json) {
    return ExamModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      examType: json['exam_type'] as String? ?? 'model_test',
      totalQuestions: (json['total_questions'] as num?)?.toInt() ?? 0,
      timeLimitMinutes: (json['time_limit_minutes'] as num?)?.toInt() ?? 60,
      totalMarks: (json['total_marks'] as num?)?.toDouble() ?? 0,
      negativeMarks: (json['negative_marks'] as num?)?.toDouble() ?? 0.25,
      passingMarks: (json['passing_marks'] as num?)?.toDouble() ?? 0,
      scheduledAt: json['scheduled_at'] != null
          ? DateTime.tryParse(json['scheduled_at'].toString())
          : null,
      endsAt: json['ends_at'] != null
          ? DateTime.tryParse(json['ends_at'].toString())
          : null,
      isLive: json['is_live'] as bool? ?? false,
      hasStarted: json['has_started'] as bool? ?? false,
      hasEnded: json['has_ended'] as bool? ?? false,
      courseId: json['course_id']?.toString(),
      category: json['category'] as String?,
      subject: json['subject'] as String?,
      attemptCount: (json['attempt_count'] as num?)?.toInt() ?? 0,
      hasAttempted: json['has_attempted'] as bool? ?? false,
      imageUrl: json['image_url'] as String? ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  bool get isUpcoming => scheduledAt != null && scheduledAt!.isAfter(DateTime.now());
  bool get isRunning => isLive && hasStarted && !hasEnded;
}