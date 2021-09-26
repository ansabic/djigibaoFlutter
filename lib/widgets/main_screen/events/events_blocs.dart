import 'package:djigibao_manager/database/entities/event.dart';
import 'package:djigibao_manager/database/entities/event_type.dart';
import 'package:djigibao_manager/database/local_repository.dart';
import 'package:table_calendar/table_calendar.dart';

class EventsManager {
  final localRepository = LocalRepository();

  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay = DateTime.now();

  DateTime? rangeStart;
  DateTime? rangeEnd;

  RangeSelectionMode rangeSelectionMode = RangeSelectionMode.toggledOff;

  var calendarFormat = CalendarFormat.month;

  List<Event> events = List<Event>.empty();

  bool addCalendarVisibility = true;
  bool addDialogVisibility = false;
  bool dialogVisibility = false;

  String tempEventDescription = "";
  EventType tempEventType = EventType.Rehearsal;

  void changeTempEventDescription(String text) {
    tempEventDescription = text;
    if (text.isNotEmpty)
      addDialogVisibility = true;
    else
      addDialogVisibility = false;
  }

  void showAllEvents() {
    events = localRepository.getAllEvents();
  }

  void showEventsOfDay(DateTime day) {
    final allEvents = localRepository.getAllEvents();
    events = allEvents.where((element) => element.dateTime == day).toList();
  }

  void saveEvent(DateTime dateTime) {
    localRepository.saveEvent(Event(
        dateTime: dateTime,
        description: tempEventDescription,
        eventType: tempEventType,
        solved: false));
    tempEventType = EventType.Rehearsal;
    tempEventDescription = "";
    dialogVisibility = false;
    addDialogVisibility = false;
    addCalendarVisibility = true;
  }
}
