class ApiConstants {
  // Base URL from --dart-define
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.jobprostuti.com',
  );

  static const String apiVersion = '/api/v1';
  static String get apiBase => '$baseUrl$apiVersion';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Retry
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);

  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String googleAuth = '/auth/google';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';

  // Course endpoints
  static const String courses = '/courses';
  static String courseDetail(String id) => '/courses/$id';
  static String courseQuestions(String id) => '/courses/$id/questions';
  static const String enroll = '/enroll';
  static String courseProgress(String id) => '/courses/$id/progress';

  // Exam endpoints
  static const String liveExams = '/exams/live';
  static const String modelTests = '/exams/model-tests';
  static String examDetail(String id) => '/exams/$id';
  static String examQuestions(String id) => '/exams/$id/questions';
  static String submitExam(String id) => '/exams/$id/submit';
  static String examResult(String id) => '/exams/$id/result';

  // Question bank
  static const String questions = '/questions';
  static const String questionTopics = '/questions/topics';
  static const String questionSubjects = '/questions/subjects';

  // User / Dashboard
  static const String userDashboard = '/user/dashboard';
  static const String userProfile = '/user/profile';
  static const String updateProfile = '/user/profile';
  static const String examHistory = '/user/exam-history';
  static const String bookmarks = '/user/bookmarks';
  static String addBookmark(String questionId) => '/user/bookmarks/$questionId';
  static String removeBookmark(String questionId) => '/user/bookmarks/$questionId';
  static const String notifications = '/user/notifications';

  // Resources
  static const String resources = '/resources';
  static const String guidelines = '/resources/guidelines';

  // Statistics
  static const String statistics = '/statistics';

  // Pricing
  static const String packages = '/packages';

  // FAQ
  static const String faq = '/faq';

  // Features
  static const String features = '/features';

  // Pagination defaults
  static const int defaultPageSize = 20;
  static const int questionPageSize = 50;
}