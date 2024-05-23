import 'package:cell_calendar/cell_calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';


/// Controller to call functions from argument like [onPageChanged] and [onCellTapped]
class CalendarStateController extends ChangeNotifier {
  CalendarStateController({
    // required this.events,
    required this.onPageChangedFromUserArgument,
    required this.onCellTappedFromUserArgument,
  }) {
    this._initialize();
  }

  // final List<CalendarEvent> events;

  final Function(DateTime firstDate, DateTime lastDate)? onPageChangedFromUserArgument;

  final void Function(DateTime, List<CalendarEvent>?)? onCellTappedFromUserArgument;

  DateTime? currentDateTime;

  void _initialize() {
    currentDateTime = DateTime.now();
    notifyListeners();
  }

  void onPageChanged(int index) {
    currentDateTime = index.visibleDateTime;
    if (onPageChangedFromUserArgument != null) {
      final currentFirstDate = _getFirstDay(currentDateTime!);
      onPageChangedFromUserArgument!(currentFirstDate, currentFirstDate.add(Duration(days: 41)));
    }
    notifyListeners();
  }

  DateTime _getFirstDay(DateTime dateTime) {
    final firstDayOfTheMonth = DateTime(dateTime.year, dateTime.month, 1);
    return firstDayOfTheMonth.add(firstDayOfTheMonth.weekday.daysDuration);
  }

  // List<CalendarEvent> eventsOnTheDay(DateTime date) {
  //   final res = events.where((event) => event.start.year == date.year && event.start.month == date.month && event.start.day == date.day).toList();
  //   return res;
  // }

  void onCellTapped(DateTime date, List<CalendarEvent>? events) {
    if (onCellTappedFromUserArgument != null) {
      onCellTappedFromUserArgument!(date, events);
    }
  }
}
