import 'package:bloc/bloc.dart';
import 'package:djigibao_manager/constants.dart';
import 'package:djigibao_manager/database/entities/message.dart';
import 'package:djigibao_manager/database/entities/topic.dart';
import 'package:djigibao_manager/database/entities/user.dart';
import 'package:djigibao_manager/database/local_repository.dart';
import 'package:djigibao_manager/firebase/realtime_database.dart';
import 'package:hive_flutter/adapters.dart';

class TopicsManager extends Cubit<Topic?> {
  final localRepository = LocalRepository();
  final topicsDatabase = TopicsDatabase();
  final refreshLatest = RefreshLatest();

  List<Topic> topics = List<Topic>.empty(growable: true);
  List<Message> messages = List<Message>.empty(growable: true);

  Stream<List<Message>>? messagesStream;
  Stream<List<Topic>>? topicStream;

  TopicsManager() : super(null);

  Future<void> removeTopic(Topic topic) async {
    await localRepository.deleteTopic(topic);
  }

  String currentMessage = "";
  final database = TopicsDatabase();



  void addMessage()  {
    final user = (Hive.box(HIVE_USER).get(HIVE_USER) as User?);
    if (user != null && currentMessage.isNotEmpty && state != null) {
      final tempMessage = Message(
          writtenBy: user, content: currentMessage, created: DateTime.now());
      database.addMessage(state!, tempMessage);
      currentMessage = "";
    }
  }

  void setCurrentTopic(Topic? topic) {
    emit(topic);
  }
}

class RefreshLatest extends Cubit<bool>{
  RefreshLatest() : super(false);

  void refresh() {
    emit(true);
  }

}
