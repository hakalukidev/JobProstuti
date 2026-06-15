import 'package:flutter_test/flutter_test.dart';
import 'package:job_prostuti_app/core/constants/api_constants.dart';
import 'package:job_prostuti_app/core/services/api_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';

class MockDio extends Mock implements Dio {}

void main() {
  group('ApiService', () {
    late ApiService apiService;

    setUp(() {
      apiService = ApiService();
    });

    group('ApiException', () {
      test('should create exception with message and status code', () {
        const exception = ApiException(
          message: 'Test error',
          statusCode: 404,
        );
        expect(exception.message, 'Test error');
        expect(exception.statusCode, 404);
        expect(exception.toString(), contains('Test error'));
        expect(exception.toString(), contains('404'));
      });

      test('NetworkException should extend ApiException', () {
        const exception = NetworkException(message: 'No internet');
        expect(exception, isA<ApiException>());
        expect(exception.message, 'No internet');
      });

      test('UnauthorizedException should have 401 status', () {
        const exception = UnauthorizedException();
        expect(exception.statusCode, 401);
        expect(exception, isA<ApiException>());
      });
    });

    group('ApiConstants', () {
      test('baseUrl should be set', () {
        expect(ApiConstants.baseUrl, isNotEmpty);
      });

      test('apiBase should combine baseUrl and version', () {
        expect(ApiConstants.apiBase, contains(ApiConstants.apiVersion));
      });

      test('courseDetail should include id', () {
        expect(ApiConstants.courseDetail('123'), contains('123'));
      });

      test('examQuestions should include examId', () {
        expect(ApiConstants.examQuestions('abc'), contains('abc'));
      });

      test('submitExam should include examId', () {
        expect(ApiConstants.submitExam('xyz'), contains('xyz'));
      });

      test('defaultPageSize should be positive', () {
        expect(ApiConstants.defaultPageSize, greaterThan(0));
      });

      test('maxRetries should be positive', () {
        expect(ApiConstants.maxRetries, greaterThan(0));
      });
    });

    group('Token management', () {
      test('getToken returns null initially', () async {
        final token = await apiService.getToken();
        // In test environment, secure storage returns null
        expect(token, isNull);
      });

      test('getRefreshToken returns null initially', () async {
        final refreshToken = await apiService.getRefreshToken();
        expect(refreshToken, isNull);
      });
    });
  });
}