// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TopicTypeAdapter extends TypeAdapter<TopicType> {
  @override
  final int typeId = 6;

  @override
  TopicType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TopicType.Task;
      case 1:
        return TopicType.Common;
      default:
        return TopicType.Task;
    }
  }

  @override
  void write(BinaryWriter writer, TopicType obj) {
    switch (obj) {
      case TopicType.Task:
        writer.writeByte(0);
        break;
      case TopicType.Common:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TopicTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
