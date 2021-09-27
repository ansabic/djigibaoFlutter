import 'package:djigibao_manager/database/entities/topic.dart';
import 'package:djigibao_manager/database/local_repository.dart';

class TopicsManager {
  final localRepository = LocalRepository();

  List<Topic> topics = List<Topic>.empty(growable: true);

  void getAllTopics() {
    topics = localRepository.getAllTopics();
  }

  Future<void> removeTopic(Topic topic) async {
    await localRepository.deleteTopic(topic);
  }
}
