class CourseModel {
  final String id;
  final String title;
  final String shortDescription;
  final String fullDescription;
  final String imageUrl;
  final String category;
  final String instructor;
  final String instructorImageUrl;
  final double price;
  final double? discountPrice;
  final int enrollmentCount;
  final int totalLessons;
  final int totalVideos;
  final int totalQuestions;
  final Duration duration;
  final double rating;
  final int reviewCount;
  final bool isFree;
  final bool isLive;
  final List<SyllabusSection> syllabus;
  final List<String> features;
  final String? examSchedule;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isEnrolled;
  final int? progressPercent;
  final DateTime createdAt;
  final List<String> tags;

  const CourseModel({
    required this.id,
    required this.title,
    required this.shortDescription,
    this.fullDescription = '',
    required this.imageUrl,
    required this.category,
    this.instructor = '',
    this.instructorImageUrl = '',
    required this.price,
    this.discountPrice,
    this.enrollmentCount = 0,
    this.totalLessons = 0,
    this.totalVideos = 0,
    this.totalQuestions = 0,
    this.duration = Duration.zero,
    this.rating = 0,
    this.reviewCount = 0,
    this.isFree = false,
    this.isLive = false,
    this.syllabus = const [],
    this.features = const [],
    this.examSchedule,
    this.startDate,
    this.endDate,
    this.isEnrolled = false,
    this.progressPercent,
    required this.createdAt,
    this.tags = const [],
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      shortDescription: json['short_description'] as String? ?? '',
      fullDescription: json['full_description'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
      category: json['category'] as String? ?? '',
      instructor: json['instructor'] as String? ?? '',
      instructorImageUrl: json['instructor_image_url'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      discountPrice: (json['discount_price'] as num?)?.toDouble(),
      enrollmentCount: (json['enrollment_count'] as num?)?.toInt() ?? 0,
      totalLessons: (json['total_lessons'] as num?)?.toInt() ?? 0,
      totalVideos: (json['total_videos'] as num?)?.toInt() ?? 0,
      totalQuestions: (json['total_questions'] as num?)?.toInt() ?? 0,
      duration: Duration(
        minutes: (json['duration_minutes'] as num?)?.toInt() ?? 0,
      ),
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      reviewCount: (json['review_count'] as num?)?.toInt() ?? 0,
      isFree: json['is_free'] as bool? ?? false,
      isLive: json['is_live'] as bool? ?? false,
      syllabus: (json['syllabus'] as List<dynamic>?)
          ?.map((e) => SyllabusSection.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      features: (json['features'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      examSchedule: json['exam_schedule'] as String?,
      startDate: json['start_date'] != null
          ? DateTime.tryParse(json['start_date'].toString())
          : null,
      endDate: json['end_date'] != null
          ? DateTime.tryParse(json['end_date'].toString())
          : null,
      isEnrolled: json['is_enrolled'] as bool? ?? false,
      progressPercent: (json['progress_percent'] as num?)?.toInt(),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      tags: (json['tags'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
    );
  }

  double get effectivePrice => discountPrice ?? price;
  bool get hasDiscount => discountPrice != null && discountPrice! < price;
  int get discountPercent => hasDiscount
      ? ((price - discountPrice!) / price * 100).round()
      : 0;
}

class SyllabusSection {
  final String title;
  final List<String> topics;

  const SyllabusSection({required this.title, required this.topics});

  factory SyllabusSection.fromJson(Map<String, dynamic> json) {
    return SyllabusSection(
      title: json['title'] as String? ?? '',
      topics: (json['topics'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
    );
  }
}