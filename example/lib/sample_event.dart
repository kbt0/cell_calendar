import 'package:cell_calendar/cell_calendar.dart';

List<CalendarEvent> sampleEvents() {
  final today = DateTime.now();
  final sampleEvents = [
    CalendarEvent(eventName: "New iPhone", eventDate: today.add(Duration(days: -42)), eventColorId: 11),
    CalendarEvent(eventName: "Writing test", eventDate: today.add(Duration(days: -30)), eventColorId: 2),
    CalendarEvent(
        eventName: "Play soccer",
        eventDate: today.add(Duration(days: -7)),
        eventColorId: 3,
        eventRecurrence: RecurrenceProperties(startDate: today.add(Duration(days: -7)), recurrenceType: RecurrenceType.monthlyByWeekDay)),
    CalendarEvent(eventName: "Learn about history", eventDate: today.add(Duration(days: -7))),
    CalendarEvent(eventName: "Buy new keyboard", eventDate: today.add(Duration(days: -7))),
    CalendarEvent(
        eventName: "公園で散歩",
        eventDate: today.add(Duration(days: -7)),
        eventColorId: 4,
        eventRecurrence: RecurrenceProperties(startDate: today.add(Duration(days: -7)), recurrenceType: RecurrenceType.weekly)),
    CalendarEvent(eventName: "Buy a present for Rebecca", eventDate: today.add(Duration(days: -7)), eventColorId: 1),
    CalendarEvent(eventName: "Firebase", eventDate: today.add(Duration(days: -7))),
    CalendarEvent(eventName: "Task Deadline", eventDate: today),
    CalendarEvent(
        eventName: "Jon's Birthday",
        eventDate: today.add(Duration(days: 3)),
        eventColorId: 4,
        eventRecurrence: RecurrenceProperties(startDate: today.add(Duration(days: 3)), recurrenceType: RecurrenceType.yearly)),
    CalendarEvent(eventName: "Date with Rebecca", eventDate: today.add(Duration(days: 7)), eventColorId: 5),
    CalendarEvent(eventName: "Start to study Spanish", eventDate: today.add(Duration(days: 13))),
    CalendarEvent(
        eventName: "Have lunch with Mike",
        eventDate: today.add(Duration(days: 13)),
        eventColorId: 6,
        eventRecurrence:
            RecurrenceProperties(startDate: today.add(Duration(days: 13)), recurrenceType: RecurrenceType.daily, weekDays: CalendarEvent.weekdayList)),
    CalendarEvent(eventName: "Buy new Play Station software", eventDate: today.add(Duration(days: 13)), eventColorId: 7),
    CalendarEvent(eventName: "Update my flutter package", eventDate: today.add(Duration(days: 13))),
    CalendarEvent(eventName: "Watch movies in my house", eventDate: today.add(Duration(days: 21))),
    CalendarEvent(eventName: "Medical Checkup", eventDate: today.add(Duration(days: 30)), eventColorId: 1),
    CalendarEvent(eventName: "Gym", eventDate: today.add(Duration(days: 42)), eventColorId: 10),
  ];
  return sampleEvents;
}
