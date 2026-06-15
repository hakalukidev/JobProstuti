class QuestionModel {
  final String id;
  final String question;
  final List<String> options;
  final int correctOptionIndex;
  final String? explanation;
  final String subject;
  final String? topic;
  final String difficulty; // 'easy', 'medium', 'hard'
  final String? imageUrl;
  final bool isBookmarked;
  final int year; // exam year
  final String? source; // e.g., "44th BCS"
  final DateTime createdAt;

  const QuestionModel({
    required this.id,
    required this.question,
    required this.options,
    required this.correctOptionIndex,
    this.explanation,
    required this.subject,
    this.topic,
    this.difficulty = 'medium',
    this.imageUrl,
    this.isBookmarked = false,
    this.year = 0,
    this.source,
    required this.createdAt,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id']?.toString() ?? '',
      question: json['question'] as String? ?? '',
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      correctOptionIndex: (json['correct_option_index'] as num?)?.toInt() ?? 0,
      explanation: json['explanation'] as String?,
      subject: json['subject'] as String? ?? '',
      topic: json['topic'] as String?,
      difficulty: json['difficulty'] as String? ?? 'medium',
      imageUrl: json['image_url'] as String?,
      isBookmarked: json['is_bookmarked'] as bool? ?? false,
      year: (json['year'] as num?)?.toInt() ?? 0,
      source: json['source'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  QuestionModel copyWith({bool? isBookmarked}) {
    return QuestionModel(
      id: id,
      question: question,
      options: options,
      correctOptionIndex: correctOptionIndex,
      explanation: explanation,
      subject: subject,
      topic: topic,
      difficulty: difficulty,
      imageUrl: imageUrl,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      year: year,
      source: source,
      createdAt: createdAt,
    );
  }
}

// User's answer during exam
class UserAnswer {
  final String questionId;
  final int? selectedOptionIndex;
  final bool isMarkedForReview;

  const UserAnswer({
    required this.questionId,
    this.selectedOptionIndex,
    this.isMarkedForReview = false,
  });

  bool get isAnswered => selectedOptionIndex != null;
}