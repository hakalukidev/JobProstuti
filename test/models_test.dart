import 'package:flutter_test/flutter_test.dart';
import 'package:job_prostuti_app/models/course_model.dart';
import 'package:job_prostuti_app/models/exam_model.dart';
import 'package:job_prostuti_app/models/question_model.dart';
import 'package:job_prostuti_app/models/resource_model.dart';
import 'package:job_prostuti_app/models/result_model.dart';


void main() {
  group('CourseModel', () {
    test('fromJson parses all fields', () {
      final json = {
        'id': 'c1',
        'title': 'BCS প্রস্তুতি',
        'short_description': 'সম্পূর্ণ BCS প্রস্তুতি',
        'image_url': 'https://example.com/img.jpg',
        'category': 'বিসিএস',
        'price': 999.0,
        'discount_price': 799.0,
        'enrollment_count': 5000,
        'total_questions': 2000,
        'rating': 4.8,
        'review_count': 250,
        'is_free': false,
        'is_live': true,
        'created_at': '2024-01-01T00:00:00Z',
      };
      final course = CourseModel.fromJson(json);
      expect(course.id, 'c1');
      expect(course.title, 'BCS প্রস্তুতি');
      expect(course.price, 999.0);
      expect(course.discountPrice, 799.0);
      expect(course.hasDiscount, isTrue);
      expect(course.discountPercent, 20);
      expect(course.effectivePrice, 799.0);
      expect(course.isLive, isTrue);
      expect(course.rating, 4.8);
    });

    test('isFree course has no effective price', () {
      final json = {
        'id': 'c2',
        'title': 'Free Course',
        'short_description': 'Free',
        'image_url': '',
        'category': 'প্রাইমারি',
        'price': 0.0,
        'is_free': true,
        'created_at': '2024-01-01T00:00:00Z',
      };
      final course = CourseModel.fromJson(json);
      expect(course.isFree, isTrue);
      expect(course.hasDiscount, isFalse);
      expect(course.effectivePrice, 0.0);
    });
  });

  group('ExamModel', () {
    test('fromJson parses correctly', () {
      final json = {
        'id': 'e1',
        'title': 'লাইভ পরীক্ষা ১',
        'exam_type': 'live',
        'total_questions': 100,
        'time_limit_minutes': 60,
        'total_marks': 100.0,
        'negative_marks': 0.25,
        'is_live': true,
        'has_started': true,
        'has_ended': false,
        'attempt_count': 1500,
        'created_at': '2024-01-01T00:00:00Z',
      };
      final exam = ExamModel.fromJson(json);
      expect(exam.id, 'e1');
      expect(exam.totalQuestions, 100);
      expect(exam.timeLimitMinutes, 60);
      expect(exam.isLive, isTrue);
      expect(exam.isRunning, isTrue);
      expect(exam.hasEnded, isFalse);
      expect(exam.negativeMarks, 0.25);
    });

    test('isUpcoming returns true for future scheduled exam', () {
      final future = DateTime.now().add(const Duration(hours: 2));
      final json = {
        'id': 'e2',
        'title': 'Future Exam',
        'exam_type': 'live',
        'total_questions': 50,
        'time_limit_minutes': 30,
        'total_marks': 50.0,
        'is_live': true,
        'has_started': false,
        'has_ended': false,
        'scheduled_at': future.toIso8601String(),
        'created_at': '2024-01-01T00:00:00Z',
      };
      final exam = ExamModel.fromJson(json);
      expect(exam.isUpcoming, isTrue);
      expect(exam.isRunning, isFalse);
    });
  });

  group('QuestionModel', () {
    test('fromJson parses options correctly', () {
      final json = {
        'id': 'q1',
        'question': 'বাংলাদেশের রাজধানী কোনটি?',
        'options': ['ঢাকা', 'চট্টগ্রাম', 'সিলেট', 'রাজশাহী'],
        'correct_option_index': 0,
        'explanation': 'ঢাকা বাংলাদেশের রাজধানী।',
        'subject': 'সাধারণ জ্ঞান',
        'topic': 'বাংলাদেশ',
        'difficulty': 'easy',
        'year': 2023,
        'source': '44th BCS',
        'created_at': '2024-01-01T00:00:00Z',
      };
      final q = QuestionModel.fromJson(json);
      expect(q.question, 'বাংলাদেশের রাজধানী কোনটি?');
      expect(q.options.length, 4);
      expect(q.correctOptionIndex, 0);
      expect(q.explanation, isNotNull);
      expect(q.difficulty, 'easy');
      expect(q.year, 2023);
      expect(q.source, '44th BCS');
    });

    test('copyWith preserves other fields', () {
      final q = QuestionModel(
        id: 'q1',
        question: 'Test?',
        options: ['A', 'B'],
        correctOptionIndex: 0,
        subject: 'Test',
        createdAt: DateTime(2024),
        isBookmarked: false,
      );
      final updated = q.copyWith(isBookmarked: true);
      expect(updated.isBookmarked, isTrue);
      expect(updated.question, 'Test?');
      expect(updated.id, 'q1');
    });

    test('UserAnswer tracks selection', () {
      final answer = UserAnswer(questionId: 'q1', selectedOptionIndex: 2);
      expect(answer.isAnswered, isTrue);
      expect(answer.selectedOptionIndex, 2);
    });

    test('UserAnswer with no selection is unanswered', () {
      final answer = UserAnswer(questionId: 'q1');
      expect(answer.isAnswered, isFalse);
    });
  });

  group('ResultModel', () {
    test('grade returns A+ for 90+', () {
      final result = ResultModel(
        id: 'r1', examId: 'e1', examTitle: 'Test', userId: 'u1',
        totalQuestions: 100, attemptedQuestions: 95, correctAnswers: 93,
        wrongAnswers: 2, skippedAnswers: 5, totalMarks: 100,
        obtainedMarks: 93, negativeMarks: 0.5, netMarks: 92.5,
        percentage: 92.5, timeTakenSeconds: 3000,
        submittedAt: DateTime.now(),
      );
      expect(result.grade, 'A+');
    });

    test('grade returns F for below 50', () {
      final result = ResultModel(
        id: 'r2', examId: 'e1', examTitle: 'Test', userId: 'u1',
        totalQuestions: 100, attemptedQuestions: 40, correctAnswers: 35,
        wrongAnswers: 5, skippedAnswers: 60, totalMarks: 100,
        obtainedMarks: 35, negativeMarks: 1.25, netMarks: 33.75,
        percentage: 33.75, timeTakenSeconds: 1800,
        submittedAt: DateTime.now(),
      );
      expect(result.grade, 'F');
    });

    test('timeTaken returns correct Duration', () {
      final result = ResultModel(
        id: 'r3', examId: 'e1', examTitle: 'T', userId: 'u1',
        totalQuestions: 10, attemptedQuestions: 10, correctAnswers: 8,
        wrongAnswers: 2, skippedAnswers: 0, totalMarks: 10,
        obtainedMarks: 8, negativeMarks: 0.5, netMarks: 7.5,
        percentage: 75, timeTakenSeconds: 2700,
        submittedAt: DateTime.now(),
      );
      expect(result.timeTaken.inMinutes, 45);
    });
  });

  group('StatisticsModel', () {
    test('fromJson parses statistics', () {
      final json = {
        'total_users': 900000,
        'live_courses': 20,
        'total_questions': 100000,
        'total_topics': 300,
        'total_downloads': 900000,
        'total_exam_attempts': 5000000,
      };
      final stats = StatisticsModel.fromJson(json);
      expect(stats.totalUsers, 900000);
      expect(stats.liveCourses, 20);
      expect(stats.totalQuestions, 100000);
      expect(stats.totalTopics, 300);
    });

    test('fromJson uses defaults when fields missing', () {
      final stats = StatisticsModel.fromJson({});
      expect(stats.totalUsers, 900000);
      expect(stats.liveCourses, 20);
    });
  });

  group('PackageModel', () {
    test('hasDiscount returns true when discountPrice < price', () {
      final pkg = PackageModel(
        id: 'p1', name: 'Premium', price: 999, discountPrice: 799, durationDays: 30,
      );
      expect(pkg.hasDiscount, isTrue);
      expect(pkg.discountPercent, 20);
      expect(pkg.effectivePrice, 799);
    });

    test('hasDiscount returns false when no discountPrice', () {
      final pkg = PackageModel(id: 'p2', name: 'Basic', price: 499, durationDays: 30);
      expect(pkg.hasDiscount, isFalse);
      expect(pkg.effectivePrice, 499);
    });
  });

  group('ResourceModel', () {
    test('fileSizeFormatted returns MB for large files', () {
      final resource = ResourceModel(
        id: 'r1', title: 'Test PDF', type: 'pdf',
        fileUrl: 'https://example.com/file.pdf', subject: 'বাংলা',
        fileSizeKb: 2048, createdAt: DateTime(2024),
      );
      expect(resource.fileSizeFormatted, contains('MB'));
    });

    test('fileSizeFormatted returns KB for small files', () {
      final resource = ResourceModel(
        id: 'r2', title: 'Small PDF', type: 'pdf',
        fileUrl: 'https://example.com/file.pdf', subject: 'ইংরেজি',
        fileSizeKb: 500, createdAt: DateTime(2024),
      );
      expect(resource.fileSizeFormatted, contains('KB'));
    });
  });
}