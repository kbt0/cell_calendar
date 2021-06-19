import 'dart:convert';

import 'package:cell_calendar/cell_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/foundation.dart';

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
  final List<int>? weekDays;

  RecurrenceProperties copyWith() => RecurrenceProperties(
        startDate: this.startDate.add(Duration()),
        recurrenceType: this.recurrenceType,
        interval: this.interval,
        weekDays: this.weekDays == null ? null : List.from(this.weekDays!),
      );

  @override
  bool operator ==(Object other) {
    return other is RecurrenceProperties &&
        other.startDate.compareTo(startDate) == 0 &&
        other.recurrenceType == recurrenceType &&
        other.interval == interval &&
        listEquals(other.weekDays, weekDays);
  }

  // jsonからEventInfo作成
  static RecurrenceProperties fromJson(Map<String, dynamic> data) {
    RecurrenceProperties recurrence = new RecurrenceProperties(
      startDate: (data['startDate'] == null) ? null : data['startDate'].toDate(),
      recurrenceType: EnumToString.fromString(RecurrenceType.values, data['recurrenceType']),
      interval: data['interval'],
      weekDays: json.decode(data['weekDays']),
    );
    return recurrence;
  }

  toJson() {
    return {
      'startDate': Timestamp.fromDate(startDate),
      'recurrenceType': recurrenceType.toString(),
      'interval': interval,
      'weekDays': jsonEncode(weekDays),
    };
  }
}
