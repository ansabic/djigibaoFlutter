import 'package:hive/hive.dart';

part 'topic_type.g.dart';

@HiveType(typeId: 6)
enum TopicType {
  @HiveField(0)
  Task,
  @HiveField(1)
  Common
}

String topicTypeToValue(TopicType topicType) {
  switch (topicType) {
    case TopicType.Task:
      return "Task";
    case TopicType.Common:
      return "Common";
  }
}

TopicType eventFromValue(String value) {
  switch (value) {
    case "Task":
      return TopicType.Task;
    case "Common":
      return TopicType.Common;
    default:
      return TopicType.Common;
  }
}
