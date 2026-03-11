// lib/core/utils/app_utils.dart
// General utility functions for the app

import 'package:intl/intl.dart';

class AppUtils {
  AppUtils._();

  /// Format DateTime to human-readable string.
  /// Example: "15 Jan 2024, 10:30 AM"
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
  }

  /// Format date only.
  /// Example: "15 January 2024"
  static String formatDate(DateTime dateTime) {
    return DateFormat('dd MMMM yyyy').format(dateTime);
  }

  /// Format time only.
  /// Example: "10:30 AM"
  static String formatTime(DateTime dateTime) {
    return DateFormat('hh:mm a').format(dateTime);
  }

  /// Returns relative time string like "2 hours ago", "Just now"
  static String timeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hours ago';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return formatDate(dateTime);
  }

  /// Validate email format.
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// Validate password — minimum 6 characters.
  static bool isValidPassword(String password) {
    return password.length >= 6;
  }

  /// Validate Indian phone number (10 digits).
  static bool isValidPhone(String phone) {
    return RegExp(r'^[6-9]\d{9}$').hasMatch(phone);
  }

  /// Capitalize first letter of each word.
  static String toTitleCase(String text) {
    if (text.isEmpty) return text;
    return text
        .split(' ')
        .map((word) =>
            word.isEmpty ? word : word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  /// Generate a unique ID for local records.
  static String generateLocalId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  /// Get color hex from severity string.
  static String severityToEmoji(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return '🔴';
      case 'high':
        return '🟠';
      case 'medium':
        return '🟡';
      case 'low':
        return '🟢';
      default:
        return '⚪';
    }
  }

  /// Returns badge color for severity.
  static String getSeverityLabel(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return 'CRITICAL';
      case 'high':
        return 'HIGH RISK';
      case 'medium':
        return 'MODERATE';
      case 'low':
        return 'LOW RISK';
      default:
        return 'UNKNOWN';
    }
  }
}
