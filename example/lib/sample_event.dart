import 'package:cell_calendar/cell_calendar.dart';

List<CalendarEvent> sampleEvents() {
  final today = DateTime.now();
  final sampleEvents = [
    CalendarEvent(summary: "New iPhone", start: today.add(Duration(days: -42)), colorId: 11),
    CalendarEvent(summary: "Writing test", start: today.add(Duration(days: -30)), colorId: 2),
    CalendarEvent(
        summary: "Play soccer",
        start: today.add(Duration(days: -7)),
        colorId: 3,
        recurrence: RecurrenceProperties(startDate: today.add(Duration(days: -7)), recurrenceType: RecurrenceType.monthlyByWeekDay)),
    CalendarEvent(summary: "Learn about history", start: today.add(Duration(days: -7))),
    CalendarEvent(summary: "Buy new keyboard", start: today.add(Duration(days: -7))),
    CalendarEvent(
        summary: "公園で散歩",
        start: today.add(Duration(days: -7)),
        colorId: 4,
        recurrence: RecurrenceProperties(startDate: today.add(Duration(days: -7)), recurrenceType: RecurrenceType.weekly)),
    CalendarEvent(summary: "Buy a present for Rebecca", start: today.add(Duration(days: -7)), colorId: 1),
    CalendarEvent(summary: "Firebase", start: today.add(Duration(days: -7))),
    CalendarEvent(summary: "Task Deadline", start: today),
    CalendarEvent(
        summary: "Jon's Birthday",
        start: today.add(Duration(days: 3)),
        colorId: 4,
        recurrence: RecurrenceProperties(startDate: today.add(Duration(days: 3)), recurrenceType: RecurrenceType.yearly)),
    CalendarEvent(summary: "Date with Rebecca", start: today.add(Duration(days: 7)), colorId: 5),
    CalendarEvent(summary: "Start to study Spanish", start: today.add(Duration(days: 13))),
    CalendarEvent(
        summary: "Have lunch with Mike",
        start: today.add(Duration(days: 13)),
        colorId: 6,
        recurrence: RecurrenceProperties(startDate: today.add(Duration(days: 13)), recurrenceType: RecurrenceType.daily, weekDays: CalendarEvent.weekdayList)),
    CalendarEvent(summary: "Buy new Play Station software", start: today.add(Duration(days: 13)), colorId: 7),
    CalendarEvent(summary: "Update my flutter package", start: today.add(Duration(days: 13))),
    CalendarEvent(summary: "Watch movies in my house", start: today.add(Duration(days: 21))),
    CalendarEvent(summary: "Medical Checkup", start: today.add(Duration(days: 30)), colorId: 1),
    CalendarEvent(summary: "Gym", start: today.add(Duration(days: 42)), colorId: 10),
  ];
  return sampleEvents;
}
