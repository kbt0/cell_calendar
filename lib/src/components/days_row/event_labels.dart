import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../calendar_event.dart';
import '../../controllers/calendar_state_controller.dart';
import '../../controllers/cell_height_controller.dart';

/// Numbers to return accurate events in the cell.
const dayLabelContentHeight = 26;
const dayLabelVerticalMargin = 1;
const _dayLabelHeight = dayLabelContentHeight + (dayLabelVerticalMargin * 2);

const _eventLabelContentHeight = 20;
const _eventLabelBottomMargin = 1;
const _eventLabelHeight = _eventLabelContentHeight + _eventLabelBottomMargin;

/// Get events to be shown from [CalendarStateController]
///
/// Shows accurate number of [_EventLabel] by the height of the parent cell
/// notified from [CellHeightController]
class EventLabels extends StatelessWidget {
  EventLabels(this.date);

  final DateTime date;

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
    final cellHeight = Provider.of<CellHeightController>(context).cellHeight;
    return Selector<CalendarStateController, List<CalendarEvent>>(
      builder: (context, events, _) {
        if (cellHeight == null) {
          return const SizedBox.shrink();
        }
        final eventsOnTheDay = CalendarEvent.getEventsOnTheDay(date, events);
        final hasEnoughSpace = _hasEnoughSpace(cellHeight, eventsOnTheDay.length);
        final maxIndex = _maxIndex(cellHeight, eventsOnTheDay.length);
        return ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: eventsOnTheDay.length,
          itemBuilder: (context, index) {
            // return _EventLabel(eventsOnTheDay[index]);
            if (hasEnoughSpace) {
              return _EventLabel(eventsOnTheDay[index]);
            } else if (index < maxIndex) {
              return _EventLabel(eventsOnTheDay[index]);
            } else if (index == maxIndex) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _EventLabel(
                    eventsOnTheDay[index],
                  ),
                  Container(
                    child: Row(
                      children: [
                        SizedBox(width: 5),
                        Text(
                          ' 他${(eventsOnTheDay.length - 1) - index}件',
                          style: TextStyle(fontSize: 12),
                        ),
                        Icon(
                          Icons.more_horiz,
                          size: 13,
                        ),
                      ],
                    ),
                  )
                ],
              );
            } else if (index == 0) {
              return _EventLabel(eventsOnTheDay[index]); //一つだけ表示
            } else {
              return SizedBox.shrink();
            }
          },
        );
      },
      selector: (context, controller) => controller.events,
    );
  }
}

/// label to show [CalendarEvent]
class _EventLabel extends StatelessWidget {
  _EventLabel(this.event);

  final CalendarEvent event;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(left: 4, right: 4, bottom: 1),
        height: 20,
        width: double.infinity,
        // color: event.eventBackgroundColor,
        decoration: BoxDecoration(
          color: event.color,
          borderRadius: BorderRadius.circular(2),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4.0, 0, 4.0, 0),
          child: Text(
            event.summary,
            style: TextStyle(color: event.textColor, fontWeight: FontWeight.normal, fontSize: 14),
            strutStyle: StrutStyle(
              fontSize: 14.0,
              height: 1.3,
            ),
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
