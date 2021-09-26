import 'package:hive/hive.dart';

part 'event_type.g.dart';

@HiveType(typeId: 4)
enum EventType {
  @HiveField(0)
  Rehearsal,
  @HiveField(1)
  Gig,
  @HiveField(2)
  Task,
  @HiveField(3)
  Other
}

String eventTypeToValue(EventType eventType) {
  switch (eventType) {
    case EventType.Rehearsal:
      return "Rehearsal";
    case EventType.Gig:
      return "Gig";
    case EventType.Other:
      return "Other";
    case EventType.Task:
      return "Task";
  }
}

EventType eventFromValue(String value) {
  switch (value) {
    case "Rehearsal":
      return EventType.Rehearsal;
    case "Gig":
      return EventType.Gig;
    case "Task":
      return EventType.Task;
    case "Other":
      return EventType.Other;
    default:
      return EventType.Other;
  }
}
