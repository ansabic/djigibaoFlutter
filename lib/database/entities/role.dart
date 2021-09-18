import 'package:hive/hive.dart';

part 'role.g.dart';

@HiveType(typeId: 1)
enum Role {
  @HiveField(0)
  Guitarist,
  @HiveField(1)
  Keyboardist,
  @HiveField(2)
  Vocal,
  @HiveField(3)
  BackVocal,
  @HiveField(4)
  Drummer,
  @HiveField(5)
  Bassist
}

String roleToValue(Role role) {
  switch (role) {
    case Role.Guitarist:
      return "Guitarist";
    case Role.Keyboardist:
      return "Keyboardist";
    case Role.Vocal:
      return "Vocal";
    case Role.BackVocal:
      return "Back Vocal";
    case Role.Drummer:
      return "Drummer";
    case Role.Bassist:
      return "Bassist";
  }
}

Role roleFromValue(String value) {
  switch (value) {
    case "Guitarist":
      return Role.Guitarist;
    case "Keyboardist":
      return Role.Keyboardist;
    case "Vocal":
      return Role.Vocal;
    case "Back Vocal":
      return Role.BackVocal;
    case "Drummer":
      return Role.Drummer;
    case "Bassist":
      return Role.Bassist;
    default:
      return Role.Vocal;
  }
}
