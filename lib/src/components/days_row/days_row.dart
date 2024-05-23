import 'package:cell_calendar/cell_calendar.dart';
import 'package:cell_calendar/src/controllers/calendar_events_provider.dart';
import 'package:flutter/material.dart';
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
class _DayCell extends HookConsumerWidget {
  _DayCell(this.date, this.visiblePageDate, this.dateTextStyle);

  final DateTime date;
  final DateTime visiblePageDate;
  final TextStyle? dateTextStyle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // イベント取得
    final events = ref.watch(calendarEventsProvider);
    // １日のイベントを取得
    final eventsOnTheDate =
        (events == null) ? null : CalendarEvent.getEventsOnTheDay(date, events);
    //ソート（繰り返しの場合、日付を比較しない）
    eventsOnTheDate?.sort((a, b) {
      if (a.allday != b.allday) {
        return b.allday.toString().compareTo(a.allday.toString());
      } else if (a.colorId != b.colorId) {
        return b.colorId.compareTo(a.colorId);
      } else {
        var _a = DateTime(
                date.year,
                date.month,
                date.day,
                a.start.hour,
                a.start.minute,
                a.start.second,
                a.start.millisecond,
                a.start.microsecond)
            .toLocal();
        var _b = DateTime(
                date.year,
                date.month,
                date.day,
                b.start.hour,
                b.start.minute,
                b.start.second,
                b.start.millisecond,
                b.start.microsecond)
            .toLocal();
        return _a.compareTo(_b);
      }
    });

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final isToday = date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
    final isCurrentMonth = visiblePageDate.month == date.month;
    final isPastDay = date.difference(today) < Duration.zero;
    return Expanded(
      child: GestureDetector(
        onTap: !isCurrentMonth
            ? null
            : () {
                provider.Provider.of<CalendarStateController>(context,
                        listen: false)
                    .onCellTapped(date, eventsOnTheDate);
              },
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              left:
                  BorderSide(color: Theme.of(context).dividerColor, width: 0.5),
              top: BorderSide(color: Theme.of(context).dividerColor, width: 1),
              right:
                  BorderSide(color: Theme.of(context).dividerColor, width: 0.5),
            ),
            // border: isToday && isCurrentMonth
            //     ? Border(
            //         left: BorderSide(color: Theme.of(context).primaryColor, width: 1),
            //         top: BorderSide(color: Theme.of(context).primaryColor, width: 1),
            //         right: BorderSide(color: Theme.of(context).primaryColor, width: 1),
            //         bottom: BorderSide(color: Theme.of(context).primaryColor, width: 1),
            //       )
            //     : Border(
            //         left: BorderSide(color: Theme.of(context).dividerColor, width: 0.5),
            //         top: BorderSide(color: Theme.of(context).dividerColor, width: 1),
            //         right: BorderSide(color: Theme.of(context).dividerColor, width: 0.5),
            //       ),
          ),
          child: MeasureSize(
            onChange: (size) {
              if (size == null) return;
              provider.Provider.of<CellHeightController>(context, listen: false)
                  .onChanged(size);
            },
            child: (!isCurrentMonth)
                //月跨ぎしない
                ? Container()
                : Column(
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
                        child: Opacity(
                          opacity: !isPastDay ? 1.0 : 0.3,
                          // Overflow対策
                          child: EventLabels(
                            date,
                            visiblePageDate,
                            eventsOnTheDate,
                          ),
                        ),
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
    final caption = Theme.of(context)
        .textTheme
        .bodySmall!
        .copyWith(fontWeight: FontWeight.w500);
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
          textScaler: TextScaler.linear(1.0),
          textAlign: TextAlign.center,
          style: textStyle.copyWith(
            fontSize: 18,
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
    final caption = Theme.of(context).textTheme.bodySmall!.copyWith(
        fontWeight: FontWeight.w500,
        color: Theme.of(context).colorScheme.onSurface);
    final textStyle = caption.merge(dateTextStyle);
    return Container(
      margin: EdgeInsets.symmetric(vertical: dayLabelVerticalMargin.toDouble()),
      height: dayLabelContentHeight.toDouble(),
      child: Center(
        child: Text(
          date.day.toString(),
          textScaler: TextScaler.linear(1.0),
          textAlign: TextAlign.center,
          style: textStyle.copyWith(
            fontSize: 18,
            color: isCurrentMonth
                ? textStyle.color
                : textStyle.color!.withOpacity(0.4),
          ),
        ),
      ),
    );
  }
}
