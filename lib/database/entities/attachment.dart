import 'package:hive/hive.dart';

part 'attachment.g.dart';

@HiveType(typeId: 3)
class Attachment {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String localLocation;
  @HiveField(2)
  final String type;

  Attachment(
      {required this.name,
      required this.localLocation,
      required this.type});
}
