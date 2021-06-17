import 'package:cell_calendar/cell_calendar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// 現在選択されているイベントの管理
final calendarEventsProvider = StateNotifierProvider<CalendarEventsNotifier, List<CalendarEvent>?>(
  (ref) => CalendarEventsNotifier(),
);

class CalendarEventsNotifier extends StateNotifier<List<CalendarEvent>?> {
  // 初期値を入れる
  CalendarEventsNotifier() : super(null);

  void setEvents(List<CalendarEvent> events) {
    state = events;
  }
}
