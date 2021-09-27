import 'package:djigibao_manager/database/entities/topic.dart';
import 'package:djigibao_manager/database/entities/user.dart';
import 'package:djigibao_manager/database/local_repository.dart';

class AddTopicManager {
  final localRepository = LocalRepository();
  String name = "";
  List<User> users = List<User>.empty();

  Future<void> saveTopic(Topic topic) async {
    await localRepository.saveTopic(topic);
  }

  void getUsers() {
    users = localRepository.getUsers();
  }
}
