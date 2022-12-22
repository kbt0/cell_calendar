import 'dart:math';

/// DataModel of event
///
/// [summary] and [start] is essential to show in [CellCalendar]
import 'package:cell_calendar/cell_calendar.dart';
import 'package:cell_calendar/src/models/recurrence_properties.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class CalendarEvent {
  CalendarEvent({
    required this.summary,
    required this.start,
    DateTime? end,
    this.allday = false,
    this.holiday = false,
    this.recurrence,
    this.description = '',
    this.shouldNotify = false,
    this.colorId = 0,
    this.textColor = Colors.white,
    this.created,
    this.updated,
    this.editable = true,
    String? id,
  })  
  // idはnullならuuidが自動採番される
  : id = id ?? uuid.v4(),
        end = end ?? start.add(Duration(hours: 1)),
        color = CalendarEventColorList[min(colorId, CalendarEventColorList.length)].color;

  String summary;
  DateTime start;
  DateTime end;
  bool allday;
  bool holiday;
  RecurrenceProperties? recurrence;
  String description;
  int colorId;
  Color color;
  Color textColor;
  bool shouldNotify;
  DateTime? created;
  DateTime? updated;
  bool editable;
  final String? id;

  CalendarEvent copyWith() => CalendarEvent(
      summary: this.summary,
      start: this.start.add(Duration()),
      end: this.end.add(Duration()),
      allday: this.allday,
      holiday: this.holiday,
      //todo recurrenceのディープコピー
      recurrence: (this.recurrence == null) ? null : this.recurrence!.copyWith(),
      description: this.description,
      shouldNotify: this.shouldNotify,
      colorId: this.colorId,
      textColor: this.textColor,
      created: this.created?.add(Duration()),
      updated: this.updated?.add(Duration()),
      editable: this.editable,
      id: this.id);

  void restore(CalendarEvent other) {
    this.summary = other.summary;
    this.start = other.start;
    this.end = other.end;
    this.allday = other.allday;
    this.holiday = other.holiday;
    this.recurrence = (other.recurrence == null) ? null : other.recurrence!.copyWith();
    this.description = other.description;
    this.shouldNotify = other.shouldNotify;
    this.colorId = other.colorId;
    this.color = other.color;
    this.textColor = other.textColor;
    this.created = other.created;
    this.updated = other.updated;
    this.editable = other.editable;
  }

  @override
  bool operator ==(Object other) {
    return other is CalendarEvent &&
        other.summary == summary &&
        other.start == start &&
        other.end == end &&
        other.allday == allday &&
        other.holiday == holiday &&
        //todo recurrenceのディープコピー比較
        other.recurrence == recurrence &&
        other.description == description &&
        other.shouldNotify == shouldNotify &&
        other.colorId == colorId &&
        other.color == color &&
        other.textColor == textColor &&
        other.created == created &&
        other.updated == updated &&
        other.editable == editable;
  }

  // FirestoreのDocumentSnapshotからcalendarEvent作成
  static CalendarEvent fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot) {
    return CalendarEvent.fromJson(snapshot.id, snapshot.data());
  }

  // jsonからcalendarEvent作成
  static CalendarEvent fromJson(String id, Map<String, dynamic> data) {
    CalendarEvent calendarEvent = new CalendarEvent(
      summary: data['summary'] ?? '',
      description: data['description'] ?? '',
      shouldNotify: data['shouldNotify'],
      colorId: data['colorId'],
      start: (data['start'] == null) ? null : data['start'].toDate(),
      end: (data['end'] == null) ? null : data['end'].toDate(),
      allday: data['allday'] ?? false,
      holiday: data['holiday'] ?? false,
      recurrence: (data['recurrence'] == null) ? null : RecurrenceProperties.fromJson(data['recurrence']),
      created: (data['created'] == null) ? null : data['created'].toDate(),
      updated: (data['updated'] == null) ? null : data['updated'].toDate(),
      editable: data['editable'] ?? true,
      id: id,
    );
    return calendarEvent;
  }

  toJson() {
    return {
      'id': id,
      'summary': summary,
      'description': description,
      'shouldNotify': shouldNotify,
      'colorId': colorId,
      'start': Timestamp.fromDate(start),
      'end': Timestamp.fromDate(end),
      'allday': allday,
      'holiday': holiday,
      'recurrence': (recurrence == null) ? null : recurrence!.toJson(),
      'created': (created == null) ? null : Timestamp.fromDate(created!),
      'updated': (updated == null) ? null : Timestamp.fromDate(updated!),
      'editable': editable,
    };
  }

  // その日のイベントを取得
  static List<CalendarEvent> getEventsOnTheDay(DateTime date, List<CalendarEvent> events) {
    var res = events.where((event) => event.start.year == date.year && event.start.month == date.month && event.start.day == date.day).toList();
    //TODO 繰り返しイベント取得
    // events.forEach((event) {
    //   if (event.eventRecurrence != null && event.eventRecurrence!.weekDays != null) {
    //     print(date.weekday);
    //     print(WeekDays.values);
    //     print(event.eventRecurrence!.weekDays!.contains(date.weekday);
    //   }
    // });

    /// 毎日の繰り返し
    final dailyByWeekDayRecur = events.where((event) =>
        event.recurrence != null && event.recurrence!.startDate.isBefore(date) && event.recurrence!.recurrenceType == RecurrenceType.dailyByWeekDays && weekdayList.contains(date.weekday % 7));
    res.addAll(dailyByWeekDayRecur);

    /// 毎日の繰り返し
    final dailyRecur = events.where((event) =>
        event.recurrence != null &&
        event.recurrence!.startDate.isBefore(date) &&
        event.recurrence!.recurrenceType == RecurrenceType.daily &&
        (event.recurrence!.weekDays == null || event.recurrence!.weekDays!.contains(date.weekday)));
    res.addAll(dailyRecur);

    /// 毎週の繰り返し
    final weeklyRecur = events.where(
        (event) => event.recurrence != null && event.recurrence!.startDate.isBefore(date) && event.recurrence!.recurrenceType == RecurrenceType.weekly && event.recurrence!.dayOfWeek == date.weekday);
    res.addAll(weeklyRecur);

    /// 毎月(日にち指定)の繰り返し
    final monthlyRecur = events.where(
        (event) => event.recurrence != null && event.recurrence!.startDate.isBefore(date) && event.recurrence!.recurrenceType == RecurrenceType.monthly && event.recurrence!.dayOfMonth == date.day);
    res.addAll(monthlyRecur);

    /// 毎月(曜日指定)の繰り返し
    final monthlyByWeekDayRecur = events.where((event) =>
        event.recurrence != null &&
        event.recurrence!.startDate.isBefore(date) &&
        event.recurrence!.recurrenceType == RecurrenceType.monthlyByWeekDay &&
        event.recurrence!.week == ((date.day - 1) ~/ 7) &&
        event.recurrence!.dayOfWeek == date.weekday);
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
    res = res.toSet().toList();
    return res;
  }

  //平日の配列
  // static const weekdayList = [WeekDays.monday, WeekDays.tuesday, WeekDays.wednesday, WeekDays.thursday, WeekDays.friday];
  static const weekdayList = [1, 2, 3, 4, 5];
}

enum RecurrenceType {
  none,
  dailyByWeekDays,
  daily,
  weekly,
  monthly,
  monthlyByWeekDay,
  yearly,
}

// enum WeekDays {
//   sunday,
//   monday,
//   tuesday,
//   wednesday,
//   thursday,
//   friday,
//   saturday,
// }

const List<CalendarEventColor> CalendarEventColorList = [
  CalendarEventColor('ブルー', Colors.lightBlue),
  CalendarEventColor('トマト', Colors.redAccent),
  CalendarEventColor('ミカン', Colors.orange),
  CalendarEventColor('バナナ', Colors.amber),
  CalendarEventColor('バジル', Colors.teal),
  CalendarEventColor('セージ', Colors.green),
  CalendarEventColor('ピーコック', Colors.cyan),
  CalendarEventColor('ブルーベリー', Colors.indigoAccent),
  CalendarEventColor('ラベンダー', Colors.deepPurpleAccent),
  CalendarEventColor('ブドウ', Colors.purple),
  CalendarEventColor('フラミンゴ', Colors.pinkAccent),
  CalendarEventColor('グラファイト', Colors.grey),
];

class CalendarEventColor {
  const CalendarEventColor(this.name, this.color);

  final String name;
  final Color color;
}
