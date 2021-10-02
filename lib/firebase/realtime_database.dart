import 'package:djigibao_manager/database/entities/message.dart';
import 'package:djigibao_manager/database/entities/topic.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class TopicsDatabase {
  final database = FirebaseDatabase(
      app: Firebase.app(),
      databaseURL:
          "https://djigibao-manager-default-rtdb.europe-west1.firebasedatabase.app");

  Stream<Event> topicsAdded() =>
      database.reference().child("topics").onChildAdded;

  Stream<Event> topicsRemoved() =>
      database.reference().child("topics").onChildRemoved;

  Stream<Event> topicChanged(String topic) =>
      database.reference().child("topics").child(topic).onValue;

  Stream<Event> messagesAdded(String topic) => database
      .reference()
      .child("topics")
      .child(topic)
      .child("messages")
      .onChildAdded;

  void init() async {
    await database.goOnline();
  }

  Future<List<Topic>> getAllTopics() async {
    final result = await database.reference().child("topics").get();
    final parsedResult = (Map<String, dynamic>.from(result.value))
        .values
        .map((value) => Topic.fromJson(Map<String, dynamic>.from(value)))
        .toList(growable: true);
    printTopics(parsedResult);
    return parsedResult;
  }

  Future<List<Message>> getAllMessages(Topic topic) async {
    final result =
        await database.reference().child("topics").child(topic.name).once();
    return Topic.fromJson((Map<String, dynamic>.from(result.value))).messages;
  }

  void addOrChangeTopic(Topic topic) async {
    await database
        .reference()
        .child("topics")
        .child(topic.name)
        .set(topic.toJson());
  }

  void addMessage(Topic topic, Message message) async {
    await database
        .reference()
        .child("topics")
        .child(topic.name)
        .child("messages")
        .child(message.created.toString())
        .set(message.toJson());
  }
}
