// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RoleAdapter extends TypeAdapter<Role> {
  @override
  final int typeId = 1;

  @override
  Role read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Role.Guitarist;
      case 1:
        return Role.Keyboardist;
      case 2:
        return Role.Vocal;
      case 3:
        return Role.BackVocal;
      case 4:
        return Role.Drummer;
      case 5:
        return Role.Bassist;
      default:
        return Role.Guitarist;
    }
  }

  @override
  void write(BinaryWriter writer, Role obj) {
    switch (obj) {
      case Role.Guitarist:
        writer.writeByte(0);
        break;
      case Role.Keyboardist:
        writer.writeByte(1);
        break;
      case Role.Vocal:
        writer.writeByte(2);
        break;
      case Role.BackVocal:
        writer.writeByte(3);
        break;
      case Role.Drummer:
        writer.writeByte(4);
        break;
      case Role.Bassist:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
