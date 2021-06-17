import 'dart:math';

import 'package:flutter/material.dart';

/// DataModel of event
///
/// [summary] and [start] is essential to show in [CellCalendar]
class CalendarEvent {
  CalendarEvent({
    required this.summary,
    required this.start,
    DateTime? end,
    this.recurrence,
    this.description = '',
    this.shouldNotify = false,
    this.colorId = 0,
    this.textColor = Colors.white,
    this.created,
    this.updated,
    String? id,
  })  : id = id,
        end = end ?? start.add(Duration()),
        color = CalendarEventColorMap.entries.map((e) => e.value).toList()[min(colorId, CalendarEventColorMap.length)];

  final String summary;
  final DateTime start;
  final DateTime? end;
  final RecurrenceProperties? recurrence;
  final String description;
  final int colorId;
  final Color color;
  final Color textColor;
  bool shouldNotify;
  DateTime? created;
  DateTime? updated;
  final String? id;

  // その日のイベントを取得
  static List<CalendarEvent> getEventsOnTheDay(DateTime date, List<CalendarEvent> events) {
    final res = events.where((event) => event.start.year == date.year && event.start.month == date.month && event.start.day == date.day).toList();
    //TODO 繰り返しイベント取得
    // events.forEach((event) {
    //   if (event.eventRecurrence != null && event.eventRecurrence!.weekDays != null) {
    //     print(date.weekday);
    //     print(WeekDays.values);
    //     print(event.eventRecurrence!.weekDays!.contains(WeekDays.values[date.weekday % 7]));
    //   }
    // });

    /// 毎日の繰り返し
    final dailyRecur = events.where((event) =>
        event.recurrence != null &&
        event.recurrence!.startDate.isBefore(date) &&
        event.recurrence!.recurrenceType == RecurrenceType.daily &&
        (event.recurrence!.weekDays == null || event.recurrence!.weekDays!.contains(WeekDays.values[date.weekday % 7])));
    res.addAll(dailyRecur);

    /// 毎週の繰り返し
    final weeklyRecur = events.where((event) =>
        event.recurrence != null &&
        event.recurrence!.startDate.isBefore(date) &&
        event.recurrence!.recurrenceType == RecurrenceType.weekly &&
        event.recurrence!.dayOfWeek == date.weekday % 7);
    res.addAll(weeklyRecur);

    /// 毎月(日にち指定)の繰り返し
    final monthlyRecur = events.where((event) =>
        event.recurrence != null &&
        event.recurrence!.startDate.isBefore(date) &&
        event.recurrence!.recurrenceType == RecurrenceType.monthly &&
        event.recurrence!.dayOfMonth == date.day);
    res.addAll(monthlyRecur);

    /// 毎月(曜日指定)の繰り返し
    final monthlyByWeekDayRecur = events.where((event) =>
        event.recurrence != null &&
        event.recurrence!.startDate.isBefore(date) &&
        event.recurrence!.recurrenceType == RecurrenceType.monthlyByWeekDay &&
        event.recurrence!.week == ((date.day - 1) ~/ 7) &&
        event.recurrence!.dayOfWeek == date.weekday % 7);
    res.addAll(monthlyByWeekDayRecur);

    /// 毎年の繰り返し
    final yearlyRecur = events.where((event) =>
        event.recurrence != null &&
        event.recurrence!.startDate.isBefore(date) &&
        event.recurrence!.recurrenceType == RecurrenceType.yearly &&
        event.recurrence!.month == date.month &&
        event.recurrence!.dayOfMonth == date.day);
    res.addAll(yearlyRecur);

    //重複削除
    res.toSet().toList();
    return res;
  }

  //平日の配列
  static const weekdayList = [WeekDays.monday, WeekDays.tuesday, WeekDays.wednesday, WeekDays.thursday, WeekDays.friday];
}

class RecurrenceProperties {
  RecurrenceProperties({
    required this.startDate,
    this.recurrenceType,
    this.interval = 1,
    this.weekDays,
  })  : dayOfMonth = startDate.day,
        dayOfWeek = startDate.weekday % 7,
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
  monthlyByWeekDay,
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
