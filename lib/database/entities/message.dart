import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:djigibao_manager/database/entities/user.dart';
import 'package:hive/hive.dart';

part 'message.g.dart';

@HiveType(typeId: 8)
class Message {
  @HiveField(0)
  final User writtenBy;
  @HiveField(1)
  final String content;
  @HiveField(2)
  final DateTime created;

  Message(
      {required this.writtenBy, required this.content, required this.created});

  Map<String, dynamic> toJson() => {
        "writtenBy": {writtenBy.name: writtenBy.toJson()},
        "content": content,
        "created": Timestamp.fromDate(created).millisecondsSinceEpoch
      };

  Message.fromJson(Map<String, dynamic> json)
      : writtenBy = User.fromJson(Map<String, dynamic>.from(
            Map<String, dynamic>.from(json["writtenBy"]).values.first)),
        content = json["content"],
        created =
            Timestamp.fromMillisecondsSinceEpoch(json["created"]).toDate();
}
