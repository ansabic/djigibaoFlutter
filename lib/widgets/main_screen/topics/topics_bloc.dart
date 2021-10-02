import 'package:collection/collection.dart';
import 'package:djigibao_manager/database/entities/message.dart';
import 'package:djigibao_manager/database/entities/topic.dart';
import 'package:djigibao_manager/database/local_repository.dart';
import 'package:djigibao_manager/firebase/realtime_database.dart';

class TopicsManager {
  final localRepository = LocalRepository();
  final topicsDatabase = TopicsDatabase();

  List<Topic> topics = List<Topic>.empty(growable: true);
  List<Message> messages = List<Message>.empty(growable: true);

  Stream<List<Message>>? messagesStream;
  Stream<List<Topic>>? topicStream;

  Future<void> removeTopic(Topic topic) async {
    await localRepository.deleteTopic(topic);
  }

  Future<void> getAllTopics() async {
    final result = await topicsDatabase.getAllTopics();
    await getAllTopicMessages(result.firstOrNull);
    topics = result;
  }

  Future<void> getAllTopicMessages(Topic? topic) async {
    if (topic != null) {
      final result = await topicsDatabase.getAllMessages(topic);
      messages = result;
    }
  }
}
