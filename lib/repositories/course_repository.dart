import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../core/services/api_service.dart';
import '../models/course_model.dart';

final courseRepositoryProvider = Provider<CourseRepository>((ref) {
  return CourseRepository(ref.read(apiServiceProvider));
});

// Providers
final coursesProvider = FutureProvider.family<List<CourseModel>, Map<String, dynamic>>(
      (ref, params) async {
    final repo = ref.read(courseRepositoryProvider);
    return repo.getCourses(
      page: params['page'] as int? ?? 1,
      category: params['category'] as String?,
      search: params['search'] as String?,
    );
  },
);

final courseDetailProvider = FutureProvider.family<CourseModel, String>(
      (ref, id) async {
    final repo = ref.read(courseRepositoryProvider);
    return repo.getCourseDetail(id);
  },
);

final allCoursesProvider = FutureProvider<List<CourseModel>>((ref) async {
  final repo = ref.read(courseRepositoryProvider);
  return repo.getCourses();
});

class CourseRepository {
  final ApiService _api;
  static const _cacheKey = 'courses_cache';

  CourseRepository(this._api);

  Future<List<CourseModel>> getCourses({
    int page = 1,
    String? category,
    String? search,
  }) async {
    try {
      final data = await _api.getCourses(
        page: page,
        category: category,
        search: search,
      );
      final courses = (data['data'] as List<dynamic>? ?? [])
          .map((e) => CourseModel.fromJson(e as Map<String, dynamic>))
          .toList();

      // Cache first page
      if (page == 1 && category == null && search == null) {
        final box = Hive.box('questions_cache');
        box.put(_cacheKey, data['data']);
      }

      return courses;
    } catch (e) {
      // Return cached data on error
      if (page == 1 && category == null && search == null) {
        final box = Hive.box('questions_cache');
        final cached = box.get(_cacheKey);
        if (cached != null) {
          return (cached as List<dynamic>)
              .map((e) => CourseModel.fromJson(
            Map<String, dynamic>.from(e as Map),
          ))
              .toList();
        }
      }
      rethrow;
    }
  }

  Future<CourseModel> getCourseDetail(String id) async {
    final data = await _api.getCourseDetail(id);
    final courseData = data['data'] as Map<String, dynamic>? ?? data;
    return CourseModel.fromJson(courseData);
  }

  Future<void> enrollCourse(String courseId) async {
    await _api.enrollCourse(courseId);
  }

  Future<Map<String, dynamic>> getCourseProgress(String courseId) async {
    return _api.getCourseProgress(courseId);
  }
}