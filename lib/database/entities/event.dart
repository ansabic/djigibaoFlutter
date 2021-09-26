import 'package:hive/hive.dart';

import 'event_type.dart';

part 'event.g.dart';

@HiveType(typeId: 5)
class Event {
  @HiveField(0)
  final String description;
  @HiveField(1)
  final DateTime dateTime;
  @HiveField(2)
  final EventType eventType;
  @HiveField(3)
  final bool solved;

  Event(
      {required this.description,
      required this.dateTime,
      required this.eventType,
      required this.solved});
}
