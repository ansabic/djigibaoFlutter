import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:djigibao_manager/database/entities/message.dart';
import 'package:djigibao_manager/database/entities/topic_type.dart';
import 'package:djigibao_manager/database/entities/user.dart';
import 'package:hive/hive.dart';

part 'topic.g.dart';

@HiveType(typeId: 7)
class Topic {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final TopicType type;
  @HiveField(2)
  final List<User>? users;
  @HiveField(3)
  final List<User>? usersSolved;
  @HiveField(4)
  final List<Message>? messages;
  @HiveField(5)
  final DateTime created;

  Topic(
      {required this.name,
      required this.type,
      required this.users,
      required this.usersSolved,
      required this.messages,
      required this.created});

  Topic.fromJson(Map<String, dynamic> json)
      : name = json["name"],
        type = topicTypeFromValue(json["type"]),
        users = (Map<String, dynamic>.from(json["users"] ?? {}).values)
            .map((e) => User.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
        usersSolved =
            (Map<String, dynamic>.from(json["usersSolved"] ?? {}).values)
                .map((e) => User.fromJson(Map<String, dynamic>.from(e)))
                .toList(),
        messages = (Map<String, dynamic>.from(json["messages"] ?? {}).values)
            .map((e) => Message.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
        created =
            Timestamp.fromMillisecondsSinceEpoch(int.parse(json["created"]))
                .toDate();

  Map<String, dynamic> toJson() => {
        "name": name,
        "type": topicTypeToValue(type),
        "users": users
            ?.asMap()
            .map((key, value) => MapEntry(value.name, value.toJson())),
        "usersSolved": usersSolved
            ?.asMap()
            .map((key, value) => MapEntry(value.name, value.toJson())),
        "messages": messages?.asMap().map((key, value) => MapEntry(
            Timestamp.fromDate(value.created).millisecondsSinceEpoch.toString(),
            value.toJson())),
        "created": created.millisecondsSinceEpoch.toString()
      };
}

void printTopics(List<Topic> topics) {
  topics.forEach((element) {
    print("NAME: ${element.name} \n");
    print("TYPE: ${topicTypeToValue(element.type)} \n");
    print("MESSAGES: [ \n");
    element.messages?.forEach((element) {
      print("-------------------------------------------- \n");
      print("MESSAGE_CREATED: ${element.created.toString()}\n");
      print("MESSAGE_WRITTEN_BY_NAME: ${element.writtenBy.name}\n");
      print("MESSAGE_WRITTEN_BY_ROLE: ${element.writtenBy.role}\n");
      print("MESSAGE_CONTENT: ${element.content.toString()}\n");
      print("--------------------------------------------\n");
    });
    print("] \n");
    print("USERS: [ \n");
    element.users?.forEach((element) {
      print("-------------------------------------------- \n");
      print("USER_NAME: ${element.name}");
      print("USER_ROLE: ${element.role}");
      print("-------------------------------------------- \n");
    });
    print("] \n");
    print("USERS_SOLVED: [ \n");
    element.usersSolved?.forEach((element) {
      print("-------------------------------------------- \n");
      print("USER_NAME: ${element.name}");
      print("USER_ROLE: ${element.role}");
      print("-------------------------------------------- \n");
    });
    print("] \n");
  });
}
