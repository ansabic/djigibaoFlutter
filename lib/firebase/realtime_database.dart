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

  Future<List<Message>?> getAllMessages(Topic topic) async {
    final result =
        await database.reference().child("topics").child(topic.name).once();
    return Topic.fromJson((Map<String, dynamic>.from(result.value))).messages;
  }

  Future<Topic> getTopic(String topicName) async {
    final result =
        await database.reference().child("topics").child(topicName).get();
    return Topic.fromJson((Map<String, dynamic>.from(result.value)));
  }

  void addOrChangeTopic(Topic topic) async {
    await database
        .reference()
        .child("topics")
        .child(topic.name)
        .set(topic.toJson());
    database
        .reference()
        .child("topicIds")
        .child(topic.created.millisecondsSinceEpoch.toString())
        .set(topic.name);
  }

  Future<void> addMessage(String topic, Message message) async {
    await database
        .reference()
        .child("topics")
        .child(topic)
        .child("messages")
        .child(message.created.millisecondsSinceEpoch.toString())
        .set(message.toJson());
  }
}
