import 'package:flutter/material.dart';

class DateHelper {
  // Formats a DateTime to a date string in YYYY-MM-DD format
  static String formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  // Formats a DateTime to a datetime string in YYYY-MM-DD HH:MM format
  static String formatDateTime(DateTime dateTime) {
    return '${formatDate(dateTime)} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  // Checks if a due date is overdue (before current date/time)
  static bool isOverdue(DateTime? dueDate) {
    if (dueDate == null) return false;
    return dueDate.isBefore(DateTime.now());
  }
  
  // Returns a color based on due date status
  static Color getDueDateColor(DateTime? dueDate, bool completed) {
    if (completed) return Colors.grey;
    if (isOverdue(dueDate)) return Colors.red;
    
    // If due within 24 hours
    if (dueDate != null) {
      final now = DateTime.now();
      final difference = dueDate.difference(now);
      if (difference.inHours < 24) return Colors.orange;
    }
    
    return Colors.black;
  }
}