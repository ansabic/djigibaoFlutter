import 'package:djigibao_manager/database/entities/topic.dart';
import 'package:djigibao_manager/database/entities/user.dart';
import 'package:djigibao_manager/database/local_repository.dart';
import 'package:djigibao_manager/firebase/realtime_database.dart';

class AddTopicManager {
  final localRepository = LocalRepository();
  final database = TopicsDatabase();
  String name = "";
  List<User> users = List<User>.empty();

  Future<void> saveTopic(Topic topic) async {
    database.addOrChangeTopic(topic);
    await localRepository.saveTopic(topic);
  }

  void getUsers() {
    users = localRepository.getUsers();
  }
}
