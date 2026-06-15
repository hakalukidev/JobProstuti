class UserModel {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? avatarUrl;
  final String role;
  final DateTime createdAt;
  final List<String> enrolledCourseIds;
  final int totalExamsAttempted;
  final double averageScore;
  final bool isPremium;
  final String? premiumExpiresAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatarUrl,
    this.role = 'user',
    required this.createdAt,
    this.enrolledCourseIds = const [],
    this.totalExamsAttempted = 0,
    this.averageScore = 0,
    this.isPremium = false,
    this.premiumExpiresAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      role: json['role'] as String? ?? 'user',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      enrolledCourseIds: (json['enrolled_course_ids'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      totalExamsAttempted: (json['total_exams_attempted'] as num?)?.toInt() ?? 0,
      averageScore: (json['average_score'] as num?)?.toDouble() ?? 0,
      isPremium: json['is_premium'] as bool? ?? false,
      premiumExpiresAt: json['premium_expires_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'avatar_url': avatarUrl,
    'role': role,
    'created_at': createdAt.toIso8601String(),
    'enrolled_course_ids': enrolledCourseIds,
    'total_exams_attempted': totalExamsAttempted,
    'average_score': averageScore,
    'is_premium': isPremium,
    'premium_expires_at': premiumExpiresAt,
  };

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
    String? role,
    DateTime? createdAt,
    List<String>? enrolledCourseIds,
    int? totalExamsAttempted,
    double? averageScore,
    bool? isPremium,
    String? premiumExpiresAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      enrolledCourseIds: enrolledCourseIds ?? this.enrolledCourseIds,
      totalExamsAttempted: totalExamsAttempted ?? this.totalExamsAttempted,
      averageScore: averageScore ?? this.averageScore,
      isPremium: isPremium ?? this.isPremium,
      premiumExpiresAt: premiumExpiresAt ?? this.premiumExpiresAt,
    );
  }
}