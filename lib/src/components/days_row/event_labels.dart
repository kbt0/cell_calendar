import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart' as provider;

import '../../controllers/calendar_state_controller.dart';
import '../../controllers/cell_height_controller.dart';
import '../../models/calendar_event.dart';

/// Numbers to return accurate events in the cell.
const dayLabelContentHeight = 26;
const dayLabelVerticalMargin = 1;
const _dayLabelHeight = dayLabelContentHeight + (dayLabelVerticalMargin * 2);

const eventLabelContentHeight = 20;
const eventLabelBottomMargin = 1;
const _eventLabelHeight = eventLabelContentHeight + eventLabelBottomMargin;

/// Get events to be shown from [CalendarStateController]
///
/// Shows accurate number of [_EventLabel] by the height of the parent cell
/// notified from [CellHeightController]
class EventLabels extends HookWidget {
  EventLabels(
    this.date,
    this.visiblePageDate,
    _eventsOnTheDate,
  ) : eventsOnTheDate = _eventsOnTheDate ?? <CalendarEvent>[];

  final DateTime date;
  final DateTime visiblePageDate;
  final List<CalendarEvent> eventsOnTheDate;

  bool _hasEnoughSpace(double cellHeight, int eventsLength) {
    final eventsTotalHeight = _eventLabelHeight * eventsLength;
    final spaceForEvents = cellHeight - _dayLabelHeight;
    return spaceForEvents > eventsTotalHeight;
  }

  int _maxIndex(double cellHeight, int eventsLength) {
    final spaceForEvents = cellHeight - _dayLabelHeight;
    const indexing = 1;
    const indexForPlot = 1;
    return spaceForEvents ~/ _eventLabelHeight - (indexing + indexForPlot);
  }

  @override
  Widget build(BuildContext context) {
    final cellHeight = provider.Provider.of<CellHeightController>(context).cellHeight;
    // return provider.Selector<CalendarStateController, List<CalendarEvent>>(
    //   builder: (context, events, _) {
    if (cellHeight == null) {
      return const SizedBox.shrink();
    }
    final isCurrentMonth = visiblePageDate.month == date.month;
    final hasEnoughSpace = _hasEnoughSpace(cellHeight, eventsOnTheDate.length);
    final maxIndex = _maxIndex(cellHeight, eventsOnTheDate.length);
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: eventsOnTheDate.length,
      itemBuilder: (context, index) {
        // return _EventLabel(eventsOnTheDay[index]);
        if (hasEnoughSpace) {
          return _EventLabel(eventsOnTheDate[index]);
        } else if (index < maxIndex) {
          return _EventLabel(eventsOnTheDate[index]);
        } else if (index == maxIndex) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _EventLabel(
                eventsOnTheDate[index],
              ),
              Container(
                child: Row(
                  children: [
                    // SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        ' 他${(eventsOnTheDate.length - 1) - index}件',
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.visible,
                        style: TextStyle(fontSize: 10),
                      ),
                    ),
                    // Icon(
                    //   Icons.more_horiz,
                    //   size: 13,
                    // ),
                  ],
                ),
              )
            ],
          );
        } else if (index == 0) {
          return _EventLabel(eventsOnTheDate[index]); //一つだけ表示
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
// selector: (context, controller) => controller.events,
//   );
// }
}

/// label to show [CalendarEvent]
class _EventLabel extends StatelessWidget {
  _EventLabel(this.event);

  final CalendarEvent event;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(left: eventLabelBottomMargin.toDouble(), right: eventLabelBottomMargin.toDouble(), bottom: eventLabelBottomMargin.toDouble()),
        height: eventLabelContentHeight.toDouble(),
        width: double.infinity,
        // color: event.eventBackgroundColor,
        decoration: BoxDecoration(
          color: event.color,
          borderRadius: BorderRadius.circular(2),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(1.0, 0, 0.0, 0),
          child: Text(
            event.summary,
            textScaleFactor: 1.0,
            maxLines: 1,
            style: TextStyle(
              color: event.textColor,
              fontWeight: FontWeight.normal,
              fontSize: 15,
              height: 1.0,
            ),
            strutStyle: StrutStyle(
              fontSize: 15.0,
              height: 1.0,
            ),
            textAlign: TextAlign.start,
            overflow: TextOverflow.visible,
          ),
        ),
      ),
    );
  }
}
