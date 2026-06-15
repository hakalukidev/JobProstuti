import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

import '../constants/api_constants.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  const ApiException({
    required this.message,
    this.statusCode,
    this.data,
  });

  @override
  String toString() => 'ApiException: $message (status: $statusCode)';
}

class NetworkException extends ApiException {
  const NetworkException({required super.message});
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException() : super(message: 'অননুমোদিত অ্যাক্সেস। পুনরায় লগইন করুন।', statusCode: 401);
}

class ApiService {
  static const _tokenKey = 'auth_token';
  static const _refreshTokenKey = 'refresh_token';

  late final Dio _dio;
  final _storage = const FlutterSecureStorage();
  final _logger = Logger();

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.apiBase,
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
      sendTimeout: ApiConstants.sendTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Accept-Language': 'bn',
      },
    ));

    _dio.interceptors.addAll([
      _AuthInterceptor(_storage, _dio, _logger),
      _RetryInterceptor(_dio, _logger),
      LogInterceptor(
        request: false,
        requestHeader: false,
        responseBody: true,
        error: true,
        logPrint: (o) => _logger.d(o.toString()),
      ),
    ]);
  }

  // ============== AUTH ==============

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    return _execute(() => _dio.post(
      ApiConstants.login,
      data: {'email': email, 'password': password},
    ));
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    return _execute(() => _dio.post(
      ApiConstants.register,
      data: {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
      },
    ));
  }

  Future<Map<String, dynamic>> loginWithGoogle({
    required String idToken,
  }) async {
    return _execute(() => _dio.post(
      ApiConstants.googleAuth,
      data: {'id_token': idToken},
    ));
  }

  Future<void> logout() async {
    try {
      await _dio.post(ApiConstants.logout);
    } catch (_) {}
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }

  Future<void> forgotPassword(String email) async {
    await _execute(() => _dio.post(
      ApiConstants.forgotPassword,
      data: {'email': email},
    ));
  }

  // ============== COURSES ==============

  Future<Map<String, dynamic>> getCourses({
    int page = 1,
    int limit = ApiConstants.defaultPageSize,
    String? category,
    String? search,
  }) async {
    return _execute(() => _dio.get(
      ApiConstants.courses,
      queryParameters: {
        'page': page,
        'limit': limit,
        if (category != null) 'category': category,
        if (search != null) 'search': search,
      },
    ));
  }

  Future<Map<String, dynamic>> getCourseDetail(String id) async {
    return _execute(() => _dio.get(ApiConstants.courseDetail(id)));
  }

  Future<Map<String, dynamic>> enrollCourse(String courseId) async {
    return _execute(() => _dio.post(
      ApiConstants.enroll,
      data: {'course_id': courseId},
    ));
  }

  Future<Map<String, dynamic>> getCourseProgress(String courseId) async {
    return _execute(() => _dio.get(ApiConstants.courseProgress(courseId)));
  }

  // ============== EXAMS ==============

  Future<Map<String, dynamic>> getLiveExams({
    int page = 1,
    int limit = ApiConstants.defaultPageSize,
  }) async {
    return _execute(() => _dio.get(
      ApiConstants.liveExams,
      queryParameters: {'page': page, 'limit': limit},
    ));
  }

  Future<Map<String, dynamic>> getExamDetail(String id) async {
    return _execute(() => _dio.get(ApiConstants.examDetail(id)));
  }

  Future<Map<String, dynamic>> getExamQuestions(String id) async {
    return _execute(() => _dio.get(ApiConstants.examQuestions(id)));
  }

  Future<Map<String, dynamic>> submitExam({
    required String examId,
    required List<Map<String, dynamic>> answers,
    required int timeTakenSeconds,
  }) async {
    return _execute(() => _dio.post(
      ApiConstants.submitExam(examId),
      data: {
        'answers': answers,
        'time_taken_seconds': timeTakenSeconds,
      },
    ));
  }

  Future<Map<String, dynamic>> getExamResult(String id) async {
    return _execute(() => _dio.get(ApiConstants.examResult(id)));
  }

  Future<Map<String, dynamic>> createModelTest({
    required List<String> subjectIds,
    required int questionCount,
    required int timeLimitMinutes,
    required int marksPerQuestion,
    required double negativeMarks,
  }) async {
    return _execute(() => _dio.post(
      ApiConstants.modelTests,
      data: {
        'subject_ids': subjectIds,
        'question_count': questionCount,
        'time_limit_minutes': timeLimitMinutes,
        'marks_per_question': marksPerQuestion,
        'negative_marks': negativeMarks,
      },
    ));
  }

  // ============== QUESTIONS ==============

  Future<Map<String, dynamic>> getQuestions({
    int page = 1,
    int limit = ApiConstants.questionPageSize,
    String? subjectId,
    String? topicId,
    String? search,
    String? difficulty,
  }) async {
    return _execute(() => _dio.get(
      ApiConstants.questions,
      queryParameters: {
        'page': page,
        'limit': limit,
        if (subjectId != null) 'subject_id': subjectId,
        if (topicId != null) 'topic_id': topicId,
        if (search != null) 'search': search,
        if (difficulty != null) 'difficulty': difficulty,
      },
    ));
  }

  Future<Map<String, dynamic>> getQuestionTopics() async {
    return _execute(() => _dio.get(ApiConstants.questionTopics));
  }

  Future<Map<String, dynamic>> getQuestionSubjects() async {
    return _execute(() => _dio.get(ApiConstants.questionSubjects));
  }

  // ============== USER ==============

  Future<Map<String, dynamic>> getUserDashboard() async {
    return _execute(() => _dio.get(ApiConstants.userDashboard));
  }

  Future<Map<String, dynamic>> getUserProfile() async {
    return _execute(() => _dio.get(ApiConstants.userProfile));
  }

  Future<Map<String, dynamic>> updateUserProfile(Map<String, dynamic> data) async {
    return _execute(() => _dio.put(ApiConstants.updateProfile, data: data));
  }

  Future<Map<String, dynamic>> getExamHistory({
    int page = 1,
    int limit = ApiConstants.defaultPageSize,
  }) async {
    return _execute(() => _dio.get(
      ApiConstants.examHistory,
      queryParameters: {'page': page, 'limit': limit},
    ));
  }

  Future<Map<String, dynamic>> getBookmarks() async {
    return _execute(() => _dio.get(ApiConstants.bookmarks));
  }

  Future<void> addBookmark(String questionId) async {
    await _execute(() => _dio.post(ApiConstants.addBookmark(questionId)));
  }

  Future<void> removeBookmark(String questionId) async {
    await _execute(() => _dio.delete(ApiConstants.removeBookmark(questionId)));
  }

  Future<Map<String, dynamic>> getNotifications() async {
    return _execute(() => _dio.get(ApiConstants.notifications));
  }

  // ============== RESOURCES ==============

  Future<Map<String, dynamic>> getResources() async {
    return _execute(() => _dio.get(ApiConstants.resources));
  }

  Future<Map<String, dynamic>> getGuidelines() async {
    return _execute(() => _dio.get(ApiConstants.guidelines));
  }

  // ============== STATISTICS ==============

  Future<Map<String, dynamic>> getStatistics() async {
    return _execute(() => _dio.get(ApiConstants.statistics));
  }

  // ============== PRICING ==============

  Future<Map<String, dynamic>> getPackages() async {
    return _execute(() => _dio.get(ApiConstants.packages));
  }

  // ============== FAQ ==============

  Future<Map<String, dynamic>> getFaq() async {
    return _execute(() => _dio.get(ApiConstants.faq));
  }

  // ============== FEATURES ==============

  Future<Map<String, dynamic>> getFeatures() async {
    return _execute(() => _dio.get(ApiConstants.features));
  }

  // ============== HELPERS ==============

  Future<Map<String, dynamic>> _execute(
      Future<Response> Function() request,
      ) async {
    try {
      final response = await request();
      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      }
      return {'data': response.data};
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ApiException(message: 'অজানা ত্রুটি: $e');
    }
  }

  ApiException _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException(
          message: 'সংযোগ টাইম আউট হয়েছে। পুনরায় চেষ্টা করুন।',
        );
      case DioExceptionType.connectionError:
        return const NetworkException(
          message: 'ইন্টারনেট সংযোগ পরীক্ষা করুন।',
        );
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final data = e.response?.data;
        final message = (data is Map ? data['message'] ?? data['error'] : null) ??
            _statusCodeMessage(statusCode);
        if (statusCode == 401) return const UnauthorizedException();
        return ApiException(
          message: message,
          statusCode: statusCode,
          data: data,
        );
      default:
        return ApiException(message: 'নেটওয়ার্ক ত্রুটি: ${e.message}');
    }
  }

  String _statusCodeMessage(int? code) {
    switch (code) {
      case 400: return 'অনুরোধটি সঠিক নয়।';
      case 403: return 'এই কাজটি করার অনুমতি নেই।';
      case 404: return 'তথ্য পাওয়া যায়নি।';
      case 422: return 'ইনপুট যাচাইকরণ ব্যর্থ।';
      case 429: return 'অনেক বেশি অনুরোধ। একটু অপেক্ষা করুন।';
      case 500: return 'সার্ভার ত্রুটি। পরে পুনরায় চেষ্টা করুন।';
      default: return 'ত্রুটি ঘটেছে (কোড: $code)।';
    }
  }

  Future<void> saveTokens({
    required String token,
    required String refreshToken,
  }) async {
    await _storage.write(key: _tokenKey, value: token);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  Future<String?> getToken() => _storage.read(key: _tokenKey);
  Future<String?> getRefreshToken() => _storage.read(key: _refreshTokenKey);
}

// Auth interceptor - attaches token to requests
class _AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _storage;
  final Dio _dio;
  final Logger _logger;
  bool _isRefreshing = false;

  static const _tokenKey = 'auth_token';
  static const _refreshTokenKey = 'refresh_token';

  _AuthInterceptor(this._storage, this._dio, this._logger);

  @override
  Future<void> onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    final token = await _storage.read(key: _tokenKey);
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
      DioException err,
      ErrorInterceptorHandler handler,
      ) async {
    if (err.response?.statusCode == 401 && !_isRefreshing) {
      _isRefreshing = true;
      try {
        final refreshToken = await _storage.read(key: _refreshTokenKey);
        if (refreshToken == null) {
          handler.next(err);
          return;
        }

        final response = await _dio.post(
          ApiConstants.refreshToken,
          data: {'refresh_token': refreshToken},
          options: Options(headers: {'skipAuth': true}),
        );

        final newToken = response.data['access_token'];
        await _storage.write(key: _tokenKey, value: newToken);

        // Retry original request
        err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
        final retryResponse = await _dio.fetch(err.requestOptions);
        handler.resolve(retryResponse);
      } catch (e) {
        _logger.e('Token refresh failed: $e');
        await _storage.deleteAll();
        handler.next(err);
      } finally {
        _isRefreshing = false;
      }
    } else {
      handler.next(err);
    }
  }
}

// Retry interceptor with exponential backoff
class _RetryInterceptor extends Interceptor {
  final Dio _dio;
  final Logger _logger;

  _RetryInterceptor(this._dio, this._logger);

  @override
  Future<void> onError(
      DioException err,
      ErrorInterceptorHandler handler,
      ) async {
    final retryCount = err.requestOptions.extra['retryCount'] as int? ?? 0;

    final shouldRetry = retryCount < ApiConstants.maxRetries &&
        (err.type == DioExceptionType.connectionTimeout ||
            err.type == DioExceptionType.receiveTimeout ||
            err.type == DioExceptionType.connectionError ||
            (err.response?.statusCode != null &&
                err.response!.statusCode! >= 500));

    if (!shouldRetry) {
      handler.next(err);
      return;
    }

    final delay = Duration(
      milliseconds: ApiConstants.retryDelay.inMilliseconds * (retryCount + 1),
    );
    _logger.w('Retrying request (${retryCount + 1}/${ApiConstants.maxRetries})...');
    await Future.delayed(delay);

    err.requestOptions.extra['retryCount'] = retryCount + 1;

    try {
      final response = await _dio.fetch(err.requestOptions);
      handler.resolve(response);
    } catch (e) {
      handler.next(err);
    }
  }
}