import 'package:djigibao_manager/database/entities/event.dart';
import 'package:djigibao_manager/database/entities/event_type.dart';
import 'package:djigibao_manager/database/local_repository.dart';
import 'package:table_calendar/table_calendar.dart';

class EventsManager {
  final localRepository = LocalRepository();

  DateTime focusedDay = DateTime.utc(
      DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime selectedDay = DateTime.utc(
      DateTime.now().year, DateTime.now().month, DateTime.now().day);

  DateTime? rangeStart;
  DateTime? rangeEnd;

  RangeSelectionMode rangeSelectionMode = RangeSelectionMode.toggledOff;

  var calendarFormat = CalendarFormat.month;
  var pickedMonth = DateTime.now().month;
  var pickedYear = DateTime.now().year;

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
    events = localRepository
        .getAllEvents()
        .where((element) =>
            element.dateTime.month == focusedDay.month &&
            element.dateTime.year == focusedDay.year)
        .toList();
    events.sort((a, b) => a.dateTime.compareTo(b.dateTime));
  }

  void showEventsOfDay(DateTime day) {
    final allEvents = localRepository.getAllEvents();
    events = allEvents.where((element) => element.dateTime == day).toList();
  }

  void showNewFormat() {
    DateTime firstDay;
    firstDay = focusedDay.subtract(Duration(days: focusedDay.weekday - 1));
    switch (calendarFormat) {
      case CalendarFormat.month:
        showAllEvents();
        break;
      case CalendarFormat.twoWeeks:
        if (getWeekInYear(focusedDay.add(Duration(days: 1))) % 2 != 0)
          firstDay = firstDay.subtract(Duration(days: 7));
        final afterTwoWeeks = firstDay.add(Duration(days: 13));
        showRangeEvents(firstDay, afterTwoWeeks);
        break;
      case CalendarFormat.week:
        final afterWeek = firstDay.add(Duration(days: 6));
        print(focusedDay.toString());
        showRangeEvents(firstDay, afterWeek);
        break;
    }
  }

  void showNewPage() {
    DateTime firstDay =
        focusedDay.subtract(Duration(days: focusedDay.weekday - 1));
    switch (calendarFormat) {
      case CalendarFormat.month:
        events = localRepository
            .getAllEvents()
            .where((element) =>
                element.dateTime.month == focusedDay.month &&
                element.dateTime.year == focusedDay.year)
            .toList();
        break;
      case CalendarFormat.twoWeeks:
        if (getWeekInYear(focusedDay.add(Duration(days: 1))) % 2 != 0)
          firstDay = firstDay.subtract(Duration(days: 7));
        final afterTwoWeeks = firstDay.add(Duration(days: 13));
        events = localRepository
            .getAllEvents()
            .where((element) =>
                (element.dateTime.isAfter(firstDay) ||
                    element.dateTime == firstDay) &&
                (element.dateTime.isBefore(afterTwoWeeks) ||
                    element.dateTime == afterTwoWeeks))
            .toList();
        break;
      case CalendarFormat.week:
        final afterWeek = firstDay.add(Duration(days: 6));
        events = localRepository
            .getAllEvents()
            .where((element) =>
                (element.dateTime.isAfter(firstDay) ||
                    element.dateTime == firstDay) &&
                (element.dateTime.isBefore(afterWeek) ||
                    element.dateTime == afterWeek))
            .toList();
        break;
    }
    events.sort((a, b) => a.dateTime.compareTo(b.dateTime));
  }

  void showRangeEvents(DateTime from, DateTime to) {
    events = localRepository
        .getAllEvents()
        .where((element) =>
            (element.dateTime.isBefore(to) || element.dateTime == to) &&
            (element.dateTime.isAfter(from) || element.dateTime == from))
        .toList();
    events.sort((a, b) => a.dateTime.compareTo(b.dateTime));
  }

  void editEventSolve(Event event, bool solve) {
    localRepository.saveEvent(Event(
        description: event.description,
        dateTime: event.dateTime,
        eventType: event.eventType,
        solved: solve));
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
    showNewPage();
  }

  Future<void> removeEvent(Event event) async {
    await localRepository.deleteEvent(event);
  }

  int getWeekInYear(DateTime date) {
    final startOfYear = new DateTime(date.year, 1, 1, 0, 0);
    final firstMonday = startOfYear.weekday;
    final daysInFirstWeek = 8 - firstMonday;
    final diff = date.difference(startOfYear);
    var weeks = ((diff.inDays - daysInFirstWeek) / 7).ceil();
    if (daysInFirstWeek > 3) weeks += 1;
    return weeks;
  }
}
