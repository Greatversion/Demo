import 'package:flutter/material.dart';

class TimeAgoWidget extends StatelessWidget {
  // The date and time when the event was created
  final DateTime dateCreated;

  // Constructor to initialize the widget with the dateCreated parameter
  const TimeAgoWidget({super.key, required this.dateCreated});

  /// Calculates the time difference between the current time and the dateCreated.
  /// 
  /// Returns a string representing the time elapsed in a human-readable format,
  /// such as "5 minutes ago", "2 hours ago", "1 day ago", etc.
  String getTimeAgo() {
    final currentDate = DateTime.now();
    final differenceInMinutes = currentDate.difference(dateCreated).inMinutes;
    final differenceInHours = currentDate.difference(dateCreated).inHours;
    final differenceInDays = currentDate.difference(dateCreated).inDays;

    // Determine the appropriate time unit based on the elapsed time
    if (differenceInMinutes < 60) {
      return '$differenceInMinutes minute${differenceInMinutes == 1 ? '' : 's'} ago';
    } else if (differenceInHours < 24) {
      return '$differenceInHours hour${differenceInHours == 1 ? '' : 's'} ago';
    } else if (differenceInDays < 7) {
      return '$differenceInDays day${differenceInDays == 1 ? '' : 's'} ago';
    } else if (differenceInDays < 30) {
      final weeks = (differenceInDays / 7).floor();
      return '$weeks week${weeks == 1 ? '' : 's'} ago';
    } else if (differenceInDays < 365) {
      final months = (differenceInDays / 30).floor();
      return '$months month${months == 1 ? '' : 's'} ago';
    } else {
      final years = (differenceInDays / 365).floor();
      return '$years year${years == 1 ? '' : 's'} ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build a Text widget to display the formatted time ago string
    return Text(
      getTimeAgo(),
      style: const TextStyle(
        fontSize: 13, // Font size for the text
        color: Colors.black, // Color for the text
      ),
    );
  }
}
