import 'package:cell_calendar/src/controllers/calendar_events_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:provider/provider.dart' as provider;

import 'components/days_of_the_week.dart';
import 'components/days_row/days_row.dart';
import 'components/month_year_label.dart';
import 'controllers/calendar_state_controller.dart';
import 'controllers/cell_calendar_page_controller.dart';
import 'controllers/cell_height_controller.dart';
import 'date_extension.dart';
import 'models/calendar_event.dart';

typedef daysBuilder = Widget Function(int dayIndex);

typedef monthYearBuilder = Widget Function(DateTime? visibleDateTime);

class TodayUIConfig {
  final Color todayMarkColor;
  final Color todayTextColor;

  TodayUIConfig(this.todayTextColor, this.todayMarkColor);
}

/// Calendar widget like a Google Calendar
///
/// Expected to be used in full screen
class CellCalendar extends HookWidget {
  CellCalendar({
    this.cellCalendarPageController,
    this.events = const [],
    this.onPageChanged,
    this.onCellTapped,
    this.todayMarkColor = Colors.blue,
    this.todayTextColor = Colors.white,
    this.daysOfTheWeekBuilder,
    this.monthYearLabelBuilder,
    this.dateTextStyle,
  });

  final CellCalendarPageController? cellCalendarPageController;

  /// Builder to show days of the week labels
  ///
  /// 0 for Sunday, 6 for Saturday.
  /// By default, it returns English labels
  final daysBuilder? daysOfTheWeekBuilder;

  final monthYearBuilder? monthYearLabelBuilder;

  final TextStyle? dateTextStyle;

  final List<CalendarEvent> events;
  final void Function(DateTime firstDate, DateTime lastDate)? onPageChanged;
  final void Function(DateTime selectDate, List<CalendarEvent>? eventsOnTheDate)? onCellTapped;
  final Color todayMarkColor;
  final Color todayTextColor;

  @override
  Widget build(BuildContext context) {
    final calendarEventsController = useProvider(calendarEventsProvider.notifier);
    //1フレーム後に実行
    WidgetsBinding.instance?.addPostFrameCallback((_) => calendarEventsController.setEvents(events));

    return provider.MultiProvider(
      providers: [
        provider.ChangeNotifierProvider(
          create: (_) => CalendarStateController(
            //events: events,
            onPageChangedFromUserArgument: onPageChanged,
            onCellTappedFromUserArgument: onCellTapped,
          ),
        ),
        provider.ChangeNotifierProvider(
          create: (_) => CellHeightController(),
        ),
        provider.Provider.value(value: TodayUIConfig(todayTextColor, todayMarkColor)),
      ],
      child: _CalendarPageView(
        daysOfTheWeekBuilder,
        monthYearLabelBuilder,
        dateTextStyle,
        cellCalendarPageController,
      ),
    );
  }
}

/// Shows [MonthYearLabel] and PageView of [_CalendarPage]
class _CalendarPageView extends StatelessWidget {
  _CalendarPageView(
    this.daysOfTheWeekBuilder,
    this.monthYearLabelBuilder,
    this.dateTextStyle,
    this.cellCalendarPageController,
  );

  final daysBuilder? daysOfTheWeekBuilder;
  final monthYearBuilder? monthYearLabelBuilder;
  final TextStyle? dateTextStyle;
  final CellCalendarPageController? cellCalendarPageController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MonthYearLabel(monthYearLabelBuilder),
        Expanded(
          child: PageView.builder(
            controller: cellCalendarPageController ?? CellCalendarPageController(),
            itemBuilder: (context, index) {
              return _CalendarPage(
                index.visibleDateTime,
                daysOfTheWeekBuilder,
                dateTextStyle,
              );
            },
            onPageChanged: (index) {
              provider.Provider.of<CalendarStateController>(context, listen: false).onPageChanged(index);
            },
          ),
        ),
      ],
    );
  }
}

/// Page of [_CalendarPage]
///
/// Wrapped with [CalendarMonthController]
class _CalendarPage extends StatelessWidget {
  const _CalendarPage(
    this.visiblePageDate,
    this.daysOfTheWeekBuilder,
    this.dateTextStyle, {
    Key? key,
  }) : super(key: key);

  final DateTime visiblePageDate;
  final daysBuilder? daysOfTheWeekBuilder;
  final TextStyle? dateTextStyle;

  List<DateTime> _getCurrentDays(DateTime dateTime) {
    final List<DateTime> result = [];
    final firstDay = _getFirstDay(dateTime);
    result.add(firstDay);
    for (int i = 0; i + 1 < 42; i++) {
      result.add(firstDay.add(Duration(days: i + 1)));
    }
    return result;
  }

  DateTime _getFirstDay(DateTime dateTime) {
    final firstDayOfTheMonth = DateTime(dateTime.year, dateTime.month, 1);
    return firstDayOfTheMonth.add(firstDayOfTheMonth.weekday.daysDuration);
  }

  @override
  Widget build(BuildContext context) {
    final days = _getCurrentDays(visiblePageDate);
    return Column(
      children: [
        DaysOfTheWeek(daysOfTheWeekBuilder),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              6,
              (index) {
                return DaysRow(
                  visiblePageDate: visiblePageDate,
                  dates: days.getRange(index * 7, (index + 1) * 7).toList(),
                  dateTextStyle: dateTextStyle,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
