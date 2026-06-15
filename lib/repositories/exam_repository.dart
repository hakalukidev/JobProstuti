import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../core/services/api_service.dart';
import '../models/exam_model.dart';
import '../models/question_model.dart';
import '../models/result_model.dart';

final examRepositoryProvider = Provider<ExamRepository>((ref) {
  return ExamRepository(ref.read(apiServiceProvider));
});

final liveExamsProvider = FutureProvider<List<ExamModel>>((ref) async {
  final repo = ref.read(examRepositoryProvider);
  return repo.getLiveExams();
});

final examDetailProvider = FutureProvider.family<ExamModel, String>((ref, id) async {
  final repo = ref.read(examRepositoryProvider);
  return repo.getExamDetail(id);
});

final examQuestionsProvider = FutureProvider.family<List<QuestionModel>, String>(
      (ref, examId) async {
    final repo = ref.read(examRepositoryProvider);
    return repo.getExamQuestions(examId);
  },
);

class ExamRepository {
  final ApiService _api;

  ExamRepository(this._api);

  Future<List<ExamModel>> getLiveExams({int page = 1}) async {
    try {
      final data = await _api.getLiveExams(page: page);
      return (data['data'] as List<dynamic>? ?? [])
          .map((e) => ExamModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      final box = Hive.box('exams_cache');
      final cached = box.get('live_exams');
      if (cached != null) {
        return (cached as List<dynamic>)
            .map((e) => ExamModel.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
      }
      rethrow;
    }
  }

  Future<ExamModel> getExamDetail(String id) async {
    final data = await _api.getExamDetail(id);
    final examData = data['data'] as Map<String, dynamic>? ?? data;
    return ExamModel.fromJson(examData);
  }

  Future<List<QuestionModel>> getExamQuestions(String examId) async {
    final data = await _api.getExamQuestions(examId);
    final questions = (data['data'] as List<dynamic>? ?? [])
        .map((e) => QuestionModel.fromJson(e as Map<String, dynamic>))
        .toList();

    // Cache for offline
    final box = Hive.box('exams_cache');
    box.put('exam_questions_$examId', data['data']);

    return questions;
  }

  Future<ResultModel> submitExam({
    required String examId,
    required List<UserAnswer> answers,
    required int timeTakenSeconds,
  }) async {
    final data = await _api.submitExam(
      examId: examId,
      answers: answers
          .map((a) => {
        'question_id': a.questionId,
        'selected_option_index': a.selectedOptionIndex,
      })
          .toList(),
      timeTakenSeconds: timeTakenSeconds,
    );
    final resultData = data['data'] as Map<String, dynamic>? ?? data;
    return ResultModel.fromJson(resultData);
  }

  Future<ResultModel> getExamResult(String examId) async {
    final data = await _api.getExamResult(examId);
    final resultData = data['data'] as Map<String, dynamic>? ?? data;
    return ResultModel.fromJson(resultData);
  }

  Future<ExamModel> createModelTest({
    required List<String> subjectIds,
    required int questionCount,
    required int timeLimitMinutes,
    required int marksPerQuestion,
    required double negativeMarks,
  }) async {
    final data = await _api.createModelTest(
      subjectIds: subjectIds,
      questionCount: questionCount,
      timeLimitMinutes: timeLimitMinutes,
      marksPerQuestion: marksPerQuestion,
      negativeMarks: negativeMarks,
    );
    final examData = data['data'] as Map<String, dynamic>? ?? data;
    return ExamModel.fromJson(examData);
  }
}