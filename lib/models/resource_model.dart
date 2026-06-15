class ResourceModel {
  final String id;
  final String title;
  final String description;
  final String type; // 'pdf', 'video', 'guideline'
  final String fileUrl;
  final String? imageUrl;
  final String subject;
  final int downloadCount;
  final bool isFree;
  final int fileSizeKb;
  final DateTime createdAt;
  final List<String> tags;
  final String? hitMapUrl;

  const ResourceModel({
    required this.id,
    required this.title,
    this.description = '',
    required this.type,
    required this.fileUrl,
    this.imageUrl,
    required this.subject,
    this.downloadCount = 0,
    this.isFree = true,
    this.fileSizeKb = 0,
    required this.createdAt,
    this.tags = const [],
    this.hitMapUrl,
  });

  factory ResourceModel.fromJson(Map<String, dynamic> json) {
    return ResourceModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      type: json['type'] as String? ?? 'pdf',
      fileUrl: json['file_url'] as String? ?? '',
      imageUrl: json['image_url'] as String?,
      subject: json['subject'] as String? ?? '',
      downloadCount: (json['download_count'] as num?)?.toInt() ?? 0,
      isFree: json['is_free'] as bool? ?? true,
      fileSizeKb: (json['file_size_kb'] as num?)?.toInt() ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      tags: (json['tags'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      hitMapUrl: json['hit_map_url'] as String?,
    );
  }

  String get fileSizeFormatted {
    if (fileSizeKb >= 1024) {
      return '${(fileSizeKb / 1024).toStringAsFixed(1)} MB';
    }
    return '$fileSizeKb KB';
  }
}

class StatisticsModel {
  final int totalUsers;
  final int liveCourses;
  final int totalQuestions;
  final int totalTopics;
  final int totalDownloads;
  final int totalExamAttempts;

  const StatisticsModel({
    required this.totalUsers,
    required this.liveCourses,
    required this.totalQuestions,
    required this.totalTopics,
    required this.totalDownloads,
    required this.totalExamAttempts,
  });

  factory StatisticsModel.fromJson(Map<String, dynamic> json) {
    return StatisticsModel(
      totalUsers: (json['total_users'] as num?)?.toInt() ?? 900000,
      liveCourses: (json['live_courses'] as num?)?.toInt() ?? 20,
      totalQuestions: (json['total_questions'] as num?)?.toInt() ?? 100000,
      totalTopics: (json['total_topics'] as num?)?.toInt() ?? 300,
      totalDownloads: (json['total_downloads'] as num?)?.toInt() ?? 900000,
      totalExamAttempts: (json['total_exam_attempts'] as num?)?.toInt() ?? 0,
    );
  }
}

class FaqModel {
  final String id;
  final String question;
  final String answer;
  final int order;

  const FaqModel({
    required this.id,
    required this.question,
    required this.answer,
    this.order = 0,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(
      id: json['id']?.toString() ?? '',
      question: json['question'] as String? ?? '',
      answer: json['answer'] as String? ?? '',
      order: (json['order'] as num?)?.toInt() ?? 0,
    );
  }
}

class PackageModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? discountPrice;
  final int durationDays;
  final List<String> features;
  final bool isPopular;
  final String? badgeText;

  const PackageModel({
    required this.id,
    required this.name,
    this.description = '',
    required this.price,
    this.discountPrice,
    required this.durationDays,
    this.features = const [],
    this.isPopular = false,
    this.badgeText,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    return PackageModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      discountPrice: (json['discount_price'] as num?)?.toDouble(),
      durationDays: (json['duration_days'] as num?)?.toInt() ?? 30,
      features: (json['features'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      isPopular: json['is_popular'] as bool? ?? false,
      badgeText: json['badge_text'] as String?,
    );
  }

  double get effectivePrice => discountPrice ?? price;
  bool get hasDiscount => discountPrice != null && discountPrice! < price;
  int get discountPercent => hasDiscount
      ? ((price - discountPrice!) / price * 100).round()
      : 0;
}