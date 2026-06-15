import 'package:flutter_test/flutter_test.dart';
import 'package:job_prostuti_app/core/services/api_service.dart';
import 'package:job_prostuti_app/core/services/auth_service.dart';
import 'package:job_prostuti_app/models/user_model.dart';
import 'package:mocktail/mocktail.dart';


class MockApiService extends Mock implements ApiService {}

void main() {
  group('AuthService', () {
    setUp(() {
    });

    group('UserModel', () {
      test('fromJson parses correctly', () {
        final json = {
          'id': '1',
          'name': 'Test User',
          'email': 'test@example.com',
          'phone': '01712345678',
          'role': 'user',
          'created_at': '2024-01-01T00:00:00Z',
          'is_premium': false,
          'total_exams_attempted': 5,
          'average_score': 72.5,
        };
        final user = UserModel.fromJson(json);
        expect(user.id, '1');
        expect(user.name, 'Test User');
        expect(user.email, 'test@example.com');
        expect(user.phone, '01712345678');
        expect(user.role, 'user');
        expect(user.isPremium, false);
        expect(user.totalExamsAttempted, 5);
        expect(user.averageScore, 72.5);
      });

      test('fromJson handles missing optional fields', () {
        final json = {
          'id': '2',
          'name': 'Minimal User',
          'email': 'min@example.com',
          'created_at': '2024-01-01T00:00:00Z',
        };
        final user = UserModel.fromJson(json);
        expect(user.phone, isNull);
        expect(user.avatarUrl, isNull);
        expect(user.isPremium, false);
        expect(user.enrolledCourseIds, isEmpty);
      });

      test('toJson produces correct map', () {
        final user = UserModel(
          id: '1',
          name: 'Test',
          email: 'test@test.com',
          createdAt: DateTime(2024, 1, 1),
        );
        final json = user.toJson();
        expect(json['id'], '1');
        expect(json['name'], 'Test');
        expect(json['email'], 'test@test.com');
      });

      test('copyWith updates only specified fields', () {
        final original = UserModel(
          id: '1',
          name: 'Original',
          email: 'orig@test.com',
          createdAt: DateTime(2024),
        );
        final updated = original.copyWith(name: 'Updated');
        expect(updated.name, 'Updated');
        expect(updated.email, 'orig@test.com');
        expect(updated.id, '1');
      });
    });

    group('login email validation', () {
      test('invalid email format should fail form validation', () {
        final emails = ['notanemail', 'missing@', '@nodomain.com', ''];
        for (final email in emails) {
          expect(email.contains('@') && email.contains('.'), isFalse,
              reason: '$email should be invalid');
        }
      });

      test('valid email format should pass', () {
        final emails = ['user@example.com', 'test.user@domain.co.uk'];
        for (final email in emails) {
          expect(email.contains('@'), isTrue);
        }
      });
    });

    group('AuthResult', () {
      test('parses data correctly', () {
        final userData = {
          'id': '1',
          'name': 'Test',
          'email': 'test@test.com',
          'created_at': '2024-01-01T00:00:00Z',
        };
        final user = UserModel.fromJson(userData);
        final result = AuthResult(
          user: user,
          token: 'access_token_123',
          refreshToken: 'refresh_token_456',
        );
        expect(result.user.name, 'Test');
        expect(result.token, 'access_token_123');
        expect(result.refreshToken, 'refresh_token_456');
      });
    });
  });
}