import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../core/services/api_service.dart';
import '../models/question_model.dart';

final questionRepositoryProvider = Provider<QuestionRepository>((ref) {
  return QuestionRepository(ref.read(apiServiceProvider));
});

class QuestionRepository {
  final ApiService _api;

  QuestionRepository(this._api);

  Future<List<QuestionModel>> getQuestions({
    int page = 1,
    String? subjectId,
    String? topicId,
    String? search,
    String? difficulty,
  }) async {
    try {
      final data = await _api.getQuestions(
        page: page,
        subjectId: subjectId,
        topicId: topicId,
        search: search,
        difficulty: difficulty,
      );
      final questions = (data['data'] as List<dynamic>? ?? [])
          .map((e) => QuestionModel.fromJson(e as Map<String, dynamic>))
          .toList();

      // Cache for offline
      if (page == 1 && subjectId == null && search == null) {
        final box = Hive.box('questions_cache');
        box.put('questions_p1', data['data']);
      }

      return questions;
    } catch (e) {
      if (page == 1 && subjectId == null && search == null) {
        final box = Hive.box('questions_cache');
        final cached = box.get('questions_p1');
        if (cached != null) {
          return (cached as List<dynamic>)
              .map((e) => QuestionModel.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList();
        }
      }
      rethrow;
    }
  }

  Future<List<String>> getSubjects() async {
    final data = await _api.getQuestionSubjects();
    return (data['data'] as List<dynamic>? ?? []).map((e) => e.toString()).toList();
  }

  Future<List<String>> getTopics() async {
    final data = await _api.getQuestionTopics();
    return (data['data'] as List<dynamic>? ?? []).map((e) => e.toString()).toList();
  }

  Future<void> addBookmark(String questionId) async {
    await _api.addBookmark(questionId);
  }

  Future<void> removeBookmark(String questionId) async {
    await _api.removeBookmark(questionId);
  }
}