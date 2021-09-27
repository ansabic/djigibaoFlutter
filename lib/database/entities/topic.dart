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
  final List<User> users;
  @HiveField(3)
  final bool solved;

  Topic(
      {required this.name,
      required this.type,
      required this.users,
      required this.solved});
}
