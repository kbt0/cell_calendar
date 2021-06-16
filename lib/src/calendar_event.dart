import 'package:flutter/material.dart';

/// DataModel of event
///
/// [eventName] and [eventDate] is essential to show in [CellCalendar]
class CalendarEvent {
  CalendarEvent({
    required this.eventName,
    required this.eventDate,
    required this.eventRecurrence,
    this.eventMemo = '',
    this.eventBackgroundColor = Colors.blue,
    this.eventTextColor = Colors.white,
    this.eventID,
  });

  final String eventName;
  final DateTime eventDate;
  final RecurrenceProperties eventRecurrence;
  final String eventMemo;
  final String? eventID;
  final Color eventBackgroundColor;
  final Color eventTextColor;
}

class RecurrenceProperties {
  RecurrenceProperties({
    required this.startDate,
    this.recurrenceType,
    this.interval = 1,
    this.weekDays,
  })  : dayOfMonth = startDate.day,
        dayOfWeek = startDate.weekday,
        month = startDate.month,
        week = ((startDate.day - 1) ~/ 7);

  final DateTime startDate;
  final RecurrenceType? recurrenceType;
  final int interval;

  final int dayOfMonth;
  final int dayOfWeek;
  final int month;
  final int week;
  final List<WeekDays>? weekDays;
}

enum RecurrenceType {
  daily,
  weekly,
  monthly,
  yearly,
}

enum WeekDays {
  sunday,
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
}
