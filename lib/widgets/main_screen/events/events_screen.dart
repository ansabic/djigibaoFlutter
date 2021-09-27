import 'package:djigibao_manager/database/entities/event_type.dart';
import 'package:djigibao_manager/widgets/main_screen/events/events_blocs.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class EventsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EventsScreen();
}

class _EventsScreen extends State<EventsScreen> {
  final manager = EventsManager();
  final descriptionController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(manager.selectedDay, selectedDay)) {
      setState(() {
        manager.selectedDay = selectedDay;
        manager.focusedDay = focusedDay;
        manager.rangeStart = null; // Important to clean those
        manager.rangeEnd = null;
        manager.rangeSelectionMode = RangeSelectionMode.toggledOff;
        manager.showEventsOfDay(focusedDay);
      });
    }
  }

  void onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      manager.selectedDay = null;
      manager.focusedDay = focusedDay;
      manager.rangeStart = start;
      manager.rangeEnd = end;
      manager.rangeSelectionMode = RangeSelectionMode.toggledOn;
      if (start != null && end != null) manager.showRangeEvents(start, end);
    });
  }

  @override
  void initState() {
    manager.showAllEvents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).backgroundColor,
      floatingActionButton: Visibility(
          visible: manager.addCalendarVisibility,
          child: FloatingActionButton(
            onPressed: () {
              setState(() {
                manager.addCalendarVisibility = false;
                manager.dialogVisibility = true;
              });
            },
            backgroundColor: Colors.amber,
            child: Icon(Icons.add),
          )),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 50, bottom: 5),
                  child: Center(
                    child: Text(
                      "Events",
                      style: TextStyle(color: Colors.amber, fontSize: 18),
                    ),
                  ),
                ),
                TableCalendar(
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  focusedDay: manager.focusedDay,
                  firstDay: DateTime.now().subtract(Duration(days: 730)),
                  lastDay: DateTime.now().add(Duration(days: 730)),
                  selectedDayPredicate: (day) =>
                      isSameDay(day, manager.selectedDay),
                  onRangeSelected: onRangeSelected,
                  rangeSelectionMode: manager.rangeSelectionMode,
                  rangeStartDay: manager.rangeStart,
                  rangeEndDay: manager.rangeEnd,
                  onDaySelected: onDaySelected,
                  onPageChanged: (focusedDay) {
                    setState(() {
                      manager.focusedDay = focusedDay;
                      manager.showNewPage();
                    });
                  },
                  calendarFormat: manager.calendarFormat,
                  onFormatChanged: (format) {
                    setState(() {
                      manager.calendarFormat = format;
                      manager.showNewFormat();
                    });
                  },
                  calendarStyle: CalendarStyle(
                      rangeHighlightColor: Colors.white12,
                      outsideDaysVisible: false,
                      selectedDecoration: BoxDecoration(
                          color: Colors.amber,
                          shape: BoxShape.circle,
                          border: Border.all(width: 2, color: Colors.amber)),
                      holidayDecoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          border: Border.all(width: 2, color: Colors.red)),
                      rangeStartDecoration: BoxDecoration(
                          color: Colors.white30,
                          shape: BoxShape.circle,
                          border: Border.all(width: 2, color: Colors.white30)),
                      rangeEndDecoration: BoxDecoration(
                          color: Colors.white30,
                          shape: BoxShape.circle,
                          border: Border.all(width: 2, color: Colors.white30)),
                      todayDecoration: BoxDecoration(
                          color: Colors.white12,
                          shape: BoxShape.circle,
                          border: Border.all(width: 2, color: Colors.white12)),
                      markerDecoration: BoxDecoration(
                          color: Colors.amberAccent,
                          shape: BoxShape.circle,
                          border:
                              Border.all(width: 1, color: Colors.amberAccent))),
                  eventLoader: (day) {
                    final result = manager.localRepository
                        .getAllEvents()
                        .where((element) => element.dateTime == day)
                        .toList();
                    return result;
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.only(top: 0),
                    itemCount: manager.events.length,
                    itemBuilder: (context, position) {
                      final item = manager.events[position];
                      Color color = Theme.of(context).backgroundColor;
                      if (item.eventType == EventType.Task && item.solved)
                        color = Colors.lightGreen;
                      else if (item.eventType == EventType.Task && !item.solved)
                        color = Colors.orange;
                      else if (item.eventType != EventType.Task &&
                          item.dateTime.isBefore(DateTime.now()))
                        color = Colors.red;
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Card(
                          color: color,
                          child: Container(
                            height: 40,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: EdgeInsets.all(3),
                                    child: Text(
                                      eventTypeToValue(item.eventType),
                                      style: TextStyle(
                                        fontSize: 8,
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: !item.solved &&
                                      item.eventType == EventType.Task,
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: IconButton(
                                          icon: Icon(Icons.check,
                                              color: Colors.amber),
                                          onPressed: () {
                                            setState(() {
                                              manager.editEventSolve(
                                                  item, true);
                                              manager.showAllEvents();
                                            });
                                          })),
                                ),
                                Visibility(
                                  visible: item.solved &&
                                      item.eventType == EventType.Task,
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: IconButton(
                                          icon: Icon(Icons.cancel_outlined,
                                              color: Colors.amber),
                                          onPressed: () {
                                            setState(() {
                                              manager.editEventSolve(
                                                  item, false);
                                              manager.showAllEvents();
                                            });
                                          })),
                                ),
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    child: Text(item.description),
                                  ),
                                ),
                                Align(
                                    alignment: Alignment.centerRight,
                                    child: IconButton(
                                        icon: Icon(Icons.delete,
                                            color: Colors.amber),
                                        onPressed: () async {
                                          await manager.removeEvent(item);
                                          setState(() {
                                            manager.showAllEvents();
                                          });
                                        })),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    child: Text(
                                        "${item.dateTime.day}.${item.dateTime.month}.${item.dateTime.year}."),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
              child: Visibility(
                  visible: manager.dialogVisibility,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 80),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 1, color: Colors.grey)),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 20),
                              child: Text(
                                "${manager.focusedDay.day}.${manager.focusedDay.month}.${manager.focusedDay.year}",
                                style: TextStyle(color: Colors.amber),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 20),
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                maxLines: null,
                                minLines: 1,
                                style: TextStyle(color: Colors.amber),
                                decoration:
                                    InputDecoration(hintText: "description"),
                                controller: descriptionController,
                                onChanged: (text) {
                                  setState(() {
                                    manager.changeTempEventDescription(text);
                                  });
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 80, vertical: 20),
                              child: DropdownButtonFormField<String>(
                                dropdownColor: Colors.black54,
                                style: TextStyle(
                                    backgroundColor: Colors.transparent,
                                    color: Colors.amber),
                                items: EventType.values.map((e) {
                                  return DropdownMenuItem(
                                    value: eventTypeToValue(e),
                                    child: Center(
                                      child: Text(
                                        eventTypeToValue(e),
                                        style: TextStyle(color: Colors.amber),
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (text) {
                                  manager.tempEventType =
                                      eventFromValue(text ?? "");
                                },
                              ),
                            ),
                            Visibility(
                              visible: manager.addDialogVisibility,
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: IconButton(
                                  icon: Icon(Icons.add, color: Colors.amber),
                                  onPressed: () {
                                    setState(() {
                                      manager.saveEvent(manager.focusedDay);
                                      descriptionController.text = "";
                                    });
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )))
        ],
      ),
    );
  }
}
