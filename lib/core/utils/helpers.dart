import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppHelpers {
  static void showSnackBar(
      BuildContext context,
      String message, {
        bool isError = false,
        Duration duration = const Duration(seconds: 3),
      }) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade700,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  static String formatNumber(int number) {
    if (number >= 100000) {
      final lakhs = number / 100000;
      return '${lakhs.toStringAsFixed(lakhs.truncateToDouble() == lakhs ? 0 : 1)} লাখ';
    } else if (number >= 1000) {
      final thousands = number / 1000;
      return '${thousands.toStringAsFixed(thousands.truncateToDouble() == thousands ? 0 : 1)} হাজার';
    }
    return number.toString();
  }

  static String formatDate(DateTime date) {
    return DateFormat('dd MMMM yyyy', 'bn_BD').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('dd MMM yyyy, hh:mm a', 'bn_BD').format(date);
  }

  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${_padZero(hours)}:${_padZero(minutes)}:${_padZero(seconds)}';
    }
    return '${_padZero(minutes)}:${_padZero(seconds)}';
  }

  static String _padZero(int n) => n.toString().padLeft(2, '0');

  static String getBanglaNumber(int number) {
    const banglaDigits = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
    return number
        .toString()
        .split('')
        .map((d) => int.tryParse(d) != null ? banglaDigits[int.parse(d)] : d)
        .join();
  }

  static String getTimeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inDays > 365) return '${(diff.inDays / 365).floor()} বছর আগে';
    if (diff.inDays > 30) return '${(diff.inDays / 30).floor()} মাস আগে';
    if (diff.inDays > 0) return '${diff.inDays} দিন আগে';
    if (diff.inHours > 0) return '${diff.inHours} ঘণ্টা আগে';
    if (diff.inMinutes > 0) return '${diff.inMinutes} মিনিট আগে';
    return 'এইমাত্র';
  }

  static String getScoreGrade(double percentage) {
    if (percentage >= 90) return 'A+';
    if (percentage >= 80) return 'A';
    if (percentage >= 70) return 'B+';
    if (percentage >= 60) return 'B';
    if (percentage >= 50) return 'C';
    return 'F';
  }

  static Color getGradeColor(double percentage) {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 60) return Colors.blue;
    if (percentage >= 40) return Colors.orange;
    return Colors.red;
  }

  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  static bool isValidPhone(String phone) {
    return RegExp(r'^01[3-9]\d{8}$').hasMatch(phone);
  }

  static bool isValidPassword(String password) {
    return password.length >= 8;
  }
}