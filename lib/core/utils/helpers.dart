import 'package:intl/intl.dart';

class Helpers {
  Helpers._();

  static String formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return '';

    DateTime dateTime;
    if (timestamp is int) {
      dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    } else if (timestamp is String) {
      dateTime = DateTime.parse(timestamp);
    } else {
      try {
        dateTime = (timestamp as dynamic).toDate();
      } catch (e) {
        return '';
      }
    }

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d, yyyy').format(dateTime);
    }
  }

  static String formatMessageTime(dynamic timestamp) {
    if (timestamp == null) return '';

    DateTime dateTime;
    if (timestamp is DateTime) {
      dateTime = timestamp;
    } else {
      try {
        dateTime = (timestamp as dynamic).toDate();
      } catch (e) {
        return '';
      }
    }

    return DateFormat('hh:mm a').format(dateTime);
  }
}
