import 'package:cell_calendar/cell_calendar.dart';
import 'package:cell_calendar/src/controllers/calendar_events_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:provider/provider.dart' as provider;

import '../../controllers/calendar_state_controller.dart';
import '../../controllers/cell_height_controller.dart';
import 'event_labels.dart';
import 'measure_size.dart';

/// Show the row of [_DayCell] cells with events
class DaysRow extends StatelessWidget {
  const DaysRow({
    required this.visiblePageDate,
    required this.dates,
    required this.dateTextStyle,
    Key? key,
  }) : super(key: key);

  final List<DateTime> dates;
  final DateTime visiblePageDate;
  final TextStyle? dateTextStyle;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: dates.map((date) {
          return _DayCell(
            date,
            visiblePageDate,
            dateTextStyle,
          );
        }).toList(),
      ),
    );
  }
}

/// Cell of calendar.
///
/// Its height is circulated by [MeasureSize] and notified by [CellHeightController]
class _DayCell extends HookWidget {
  _DayCell(this.date, this.visiblePageDate, this.dateTextStyle);

  final DateTime date;
  final DateTime visiblePageDate;
  final TextStyle? dateTextStyle;

  @override
  Widget build(BuildContext context) {
    final events = useProvider(calendarEventsProvider);
    final eventsOnTheDate = CalendarEvent.getEventsOnTheDay(date, events!);

    final today = DateTime.now();
    final isToday = date.year == today.year && date.month == today.month && date.day == today.day;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          provider.Provider.of<CalendarStateController>(context, listen: false).onCellTapped(date, eventsOnTheDate!);
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Theme.of(context).dividerColor, width: 1),
              right: BorderSide(color: Theme.of(context).dividerColor, width: 1),
            ),
          ),
          child: MeasureSize(
            onChange: (size) {
              if (size == null) return;
              provider.Provider.of<CellHeightController>(context, listen: false).onChanged(size);
            },
            child: Column(
              children: [
                isToday
                    ? _TodayLabel(
                        date: date,
                        dateTextStyle: dateTextStyle,
                      )
                    : _DayLabel(
                        date: date,
                        visiblePageDate: visiblePageDate,
                        dateTextStyle: dateTextStyle,
                      ),
                Expanded(
                  // Overflow対策
                  child: EventLabels(date, eventsOnTheDate),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TodayLabel extends StatelessWidget {
  const _TodayLabel({
    Key? key,
    required this.date,
    required this.dateTextStyle,
  }) : super(key: key);

  final DateTime date;
  final TextStyle? dateTextStyle;

  @override
  Widget build(BuildContext context) {
    final config = provider.Provider.of<TodayUIConfig>(context, listen: false);
    final caption = Theme.of(context).textTheme.caption!.copyWith(fontWeight: FontWeight.w500);
    final textStyle = caption.merge(dateTextStyle);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1),
      height: dayLabelContentHeight.toDouble(),
      width: dayLabelContentHeight.toDouble(),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: config.todayMarkColor,
      ),
      child: Center(
        child: Text(
          date.day.toString(),
          textAlign: TextAlign.center,
          style: textStyle.copyWith(
            color: config.todayTextColor,
          ),
        ),
      ),
    );
  }
}

class _DayLabel extends StatelessWidget {
  const _DayLabel({
    Key? key,
    required this.date,
    required this.visiblePageDate,
    required this.dateTextStyle,
  }) : super(key: key);

  final DateTime date;
  final DateTime visiblePageDate;
  final TextStyle? dateTextStyle;

  @override
  Widget build(BuildContext context) {
    final isCurrentMonth = visiblePageDate.month == date.month;
    final caption = Theme.of(context).textTheme.caption!.copyWith(fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.onSurface);
    final textStyle = caption.merge(dateTextStyle);
    return Container(
      margin: EdgeInsets.symmetric(vertical: dayLabelVerticalMargin.toDouble()),
      height: dayLabelContentHeight.toDouble(),
      child: Text(
        date.day.toString(),
        textAlign: TextAlign.center,
        style: textStyle.copyWith(
          color: isCurrentMonth ? textStyle.color : textStyle.color!.withOpacity(0.4),
        ),
      ),
    );
  }
}
