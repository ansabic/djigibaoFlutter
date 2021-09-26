// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventTypeAdapter extends TypeAdapter<EventType> {
  @override
  final int typeId = 4;

  @override
  EventType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return EventType.Rehearsal;
      case 1:
        return EventType.Gig;
      case 2:
        return EventType.Task;
      case 3:
        return EventType.Other;
      default:
        return EventType.Rehearsal;
    }
  }

  @override
  void write(BinaryWriter writer, EventType obj) {
    switch (obj) {
      case EventType.Rehearsal:
        writer.writeByte(0);
        break;
      case EventType.Gig:
        writer.writeByte(1);
        break;
      case EventType.Task:
        writer.writeByte(2);
        break;
      case EventType.Other:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
