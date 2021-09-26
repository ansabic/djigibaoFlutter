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
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 50, bottom: 10),
                  child: Text(
                    "Events",
                    style: TextStyle(color: Colors.amber, fontSize: 18),
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
                    manager.focusedDay = focusedDay;
                  },
                  calendarFormat: manager.calendarFormat,
                  onFormatChanged: (format) {
                    setState(() {
                      manager.calendarFormat = format;
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
                        .where((element) => element.dateTime.day == day.day)
                        .toList();
                    return result;
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: SizedBox(
                      height: 400,
                      child: ListView.builder(
                        padding: EdgeInsets.only(top: 0),
                        itemCount: manager.events.length,
                        itemBuilder: (context, position) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Card(
                              color: Theme.of(context).backgroundColor,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Text(
                                        manager.events[position].description ??
                                            ""),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Text(manager
                                            .events[position].dateTime
                                            .toString() ??
                                        ""),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      )),
                )
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
