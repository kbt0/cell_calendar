import 'dart:math';

import 'package:flutter/material.dart';

/// DataModel of event
///
/// [eventName] and [eventDate] is essential to show in [CellCalendar]
class CalendarEvent {
  CalendarEvent({
    required this.eventName,
    required this.eventDate,
    this.eventRecurrence,
    this.eventMemo = '',
    this.eventColorId = 0,
    this.eventTextColor = Colors.white,
    this.eventID,
  }) : eventBackgroundColor = CalendarEventColorMap.entries.map((e) => e.value).toList()[min(eventColorId, CalendarEventColorMap.length)];

  final String eventName;
  final DateTime eventDate;
  final RecurrenceProperties? eventRecurrence;
  final String eventMemo;
  final int eventColorId;
  final Color eventBackgroundColor;
  final Color eventTextColor;
  final String? eventID;
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

const Map<String, Color> CalendarEventColorMap = {
  "ブルー": Colors.lightBlue,
  "トマト": Colors.redAccent,
  "ミカン": Colors.orange,
  "バナナ": Colors.amber,
  "バジル": Colors.teal,
  "セージ": Colors.green,
  "ピーコック": Colors.cyan,
  "ブルーベリー": Colors.indigoAccent,
  "ラベンダー": Colors.deepPurpleAccent,
  "ブドウ": Colors.purple,
  "フラミンゴ": Colors.pinkAccent,
  "グラファイト": Colors.grey,
};
