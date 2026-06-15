import 'package:flutter_test/flutter_test.dart';
import 'package:job_prostuti_app/core/utils/extensions.dart';
import 'package:job_prostuti_app/core/utils/helpers.dart';

void main() {
  group('AppHelpers', () {
    group('formatNumber', () {
      test('formats lakhs correctly', () {
        expect(AppHelpers.formatNumber(900000), contains('লাখ'));
        expect(AppHelpers.formatNumber(100000), contains('লাখ'));
      });

      test('formats thousands correctly', () {
        expect(AppHelpers.formatNumber(5000), contains('হাজার'));
        expect(AppHelpers.formatNumber(1000), contains('হাজার'));
      });

      test('returns plain number for small values', () {
        expect(AppHelpers.formatNumber(999), '999');
        expect(AppHelpers.formatNumber(0), '0');
      });
    });

    group('getBanglaNumber', () {
      test('converts digits to Bangla', () {
        expect(AppHelpers.getBanglaNumber(0), '০');
        expect(AppHelpers.getBanglaNumber(9), '৯');
        expect(AppHelpers.getBanglaNumber(47), '৪৭');
        expect(AppHelpers.getBanglaNumber(2024), '২০২৪');
      });
    });

    group('getScoreGrade', () {
      test('returns correct grades', () {
        expect(AppHelpers.getScoreGrade(95), 'A+');
        expect(AppHelpers.getScoreGrade(85), 'A');
        expect(AppHelpers.getScoreGrade(75), 'B+');
        expect(AppHelpers.getScoreGrade(65), 'B');
        expect(AppHelpers.getScoreGrade(55), 'C');
        expect(AppHelpers.getScoreGrade(45), 'F');
      });
    });

    group('isValidEmail', () {
      test('validates correct emails', () {
        expect(AppHelpers.isValidEmail('user@example.com'), isTrue);
        expect(AppHelpers.isValidEmail('test.email+tag@domain.co'), isTrue);
      });

      test('rejects invalid emails', () {
        expect(AppHelpers.isValidEmail('notanemail'), isFalse);
        expect(AppHelpers.isValidEmail('@domain.com'), isFalse);
        expect(AppHelpers.isValidEmail('user@'), isFalse);
        expect(AppHelpers.isValidEmail(''), isFalse);
      });
    });

    group('isValidPhone', () {
      test('validates Bangladeshi phone numbers', () {
        expect(AppHelpers.isValidPhone('01712345678'), isTrue);
        expect(AppHelpers.isValidPhone('01987654321'), isTrue);
        expect(AppHelpers.isValidPhone('01312345678'), isTrue);
      });

      test('rejects invalid phones', () {
        expect(AppHelpers.isValidPhone('01112345678'), isFalse); // invalid operator
        expect(AppHelpers.isValidPhone('1712345678'), isFalse);  // missing leading 0
        expect(AppHelpers.isValidPhone('017123456'), isFalse);   // too short
        expect(AppHelpers.isValidPhone(''), isFalse);
      });
    });

    group('isValidPassword', () {
      test('accepts passwords >= 8 chars', () {
        expect(AppHelpers.isValidPassword('password'), isTrue);
        expect(AppHelpers.isValidPassword('securepass123'), isTrue);
      });

      test('rejects short passwords', () {
        expect(AppHelpers.isValidPassword('1234567'), isFalse);
        expect(AppHelpers.isValidPassword(''), isFalse);
      });
    });

    group('formatDuration', () {
      test('formats minutes and seconds', () {
        expect(AppHelpers.formatDuration(const Duration(minutes: 5, seconds: 30)), '05:30');
      });

      test('formats with hours', () {
        final formatted = AppHelpers.formatDuration(const Duration(hours: 1, minutes: 30, seconds: 0));
        expect(formatted, '01:30:00');
      });
    });
  });

  group('Extensions', () {
    group('StringX.banglaDigits', () {
      test('converts English digits to Bangla', () {
        expect('2024'.banglaDigits, '২০২৪');
        expect('0'.banglaDigits, '০');
        expect('abc'.banglaDigits, 'abc');
        expect('abc123'.banglaDigits, 'abc১২৩');
      });
    });

    group('StringX.isValidEmail', () {
      test('validates emails', () {
        expect('test@example.com'.isValidEmail, isTrue);
        expect('invalid'.isValidEmail, isFalse);
      });
    });

    group('StringX.capitalize', () {
      test('capitalizes first letter', () {
        expect('hello'.capitalize, 'Hello');
        expect(''.capitalize, '');
        expect('a'.capitalize, 'A');
      });
    });

    group('IntX', () {
      test('bangla converts int to Bangla digits', () {
        expect(47.bangla, '৪৭');
        expect(0.bangla, '০');
      });

      test('seconds creates correct Duration', () {
        expect(30.seconds, const Duration(seconds: 30));
      });

      test('minutes creates correct Duration', () {
        expect(5.minutes, const Duration(minutes: 5));
      });
    });

    group('DateTimeX', () {
      test('isToday returns true for now', () {
        expect(DateTime.now().isToday, isTrue);
      });

      test('isPast returns true for yesterday', () {
        expect(DateTime.now().subtract(const Duration(days: 1)).isPast, isTrue);
      });

      test('isFuture returns true for tomorrow', () {
        expect(DateTime.now().add(const Duration(days: 1)).isFuture, isTrue);
      });
    });
  });
}