class BlogModel {
  final String id;
  final String title;
  final String excerpt;
  final String content;
  final String imageUrl;
  final String author;
  final String authorImageUrl;
  final String category;
  final DateTime publishedDate;
  final int readingTimeMinutes;
  final List<String> tags;
  final int viewCount;

  const BlogModel({
    required this.id,
    required this.title,
    required this.excerpt,
    required this.content,
    required this.imageUrl,
    required this.author,
    this.authorImageUrl = '',
    required this.category,
    required this.publishedDate,
    this.readingTimeMinutes = 5,
    this.tags = const [],
    this.viewCount = 0,
  });

  factory BlogModel.fromJson(Map<String, dynamic> json) {
    return BlogModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      excerpt: json['excerpt'] as String? ?? '',
      content: json['content'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
      author: json['author'] as String? ?? '',
      authorImageUrl: json['author_image_url'] as String? ?? '',
      category: json['category'] as String? ?? '',
      publishedDate: json['published_date'] != null
          ? DateTime.tryParse(json['published_date'].toString()) ??
                DateTime.now()
          : DateTime.now(),
      readingTimeMinutes: (json['reading_time_minutes'] as num?)?.toInt() ?? 5,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          [],
      viewCount: (json['view_count'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'excerpt': excerpt,
      'content': content,
      'image_url': imageUrl,
      'author': author,
      'author_image_url': authorImageUrl,
      'category': category,
      'published_date': publishedDate.toIso8601String(),
      'reading_time_minutes': readingTimeMinutes,
      'tags': tags,
      'view_count': viewCount,
    };
  }
}
