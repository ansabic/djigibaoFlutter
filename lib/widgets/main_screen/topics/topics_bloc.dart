import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:djigibao_manager/constants.dart';
import 'package:djigibao_manager/database/entities/message.dart';
import 'package:djigibao_manager/database/entities/topic.dart';
import 'package:djigibao_manager/database/entities/user.dart';
import 'package:djigibao_manager/database/local_repository.dart';
import 'package:djigibao_manager/firebase/realtime_database.dart';
import 'package:hive_flutter/adapters.dart';

class TopicsManager extends Cubit<String?> {
  final localRepository = LocalRepository();
  final topicsDatabase = TopicsDatabase();
  final refreshLatest = RefreshLatest();

  List<Topic> topics = List<Topic>.empty(growable: true);
  List<Message> messages = List<Message>.empty(growable: true);

  String lastMessageId = "0";
  String lastTopicId = "0";

  StreamSubscription? currentMessageStream;

  TopicsManager() : super("global");

  Future<void> removeTopic(Topic topic) async {
    await localRepository.deleteTopic(topic);
  }

  String currentTopicName = "";
  String currentMessage = "";
  final database = TopicsDatabase();

  void initLocalMessages() {
    messages = localRepository
        .getMessagesOfTopic(currentTopicName)
        .toList(growable: true);
    messages.sort((a, b) => b.created.millisecondsSinceEpoch
        .compareTo(a.created.millisecondsSinceEpoch));
    if (messages.isNotEmpty)
      lastMessageId = messages
          .reduce((value, element) => (value.created.millisecondsSinceEpoch >
                  element.created.millisecondsSinceEpoch)
              ? value
              : element)
          .created
          .millisecondsSinceEpoch
          .toString();
    print(messages.length);
  }

  void addMessageRemote() {
    final user = (Hive.box(HIVE_USER).get(HIVE_USER) as User?);
    if (user != null && currentMessage.isNotEmpty && state != null) {
      final tempMessage = Message(
          writtenBy: user, content: currentMessage, created: DateTime.now());
      database.addMessage(state!, tempMessage);
      currentMessage = "";
    }
  }

  Future<void> syncTopics(List<String> topicNames) async {
    for (var element in topicNames) {
      final topic = await database.getTopic(element);
      if (!localRepository
          .getAllTopics()
          .map((e) => e.name)
          .contains(element)) {
        localRepository.saveTopic(topic);
        topics.add(topic);
      }
    }
    topics.sort((a, b) => b.created.millisecondsSinceEpoch
        .compareTo(a.created.millisecondsSinceEpoch));
    if (topics.isNotEmpty)
      lastTopicId = topics
          .reduce((value, element) => (value.created.millisecondsSinceEpoch >
                  element.created.millisecondsSinceEpoch)
              ? value
              : element)
          .created
          .millisecondsSinceEpoch
          .toString();
  }

  void initLocalTopics() {
    topics = localRepository.getAllTopics().toList(growable: true);
    topics.sort((a, b) => b.created.millisecondsSinceEpoch
        .compareTo(a.created.millisecondsSinceEpoch));
    if (topics.isNotEmpty)
      lastTopicId = topics
          .reduce((value, element) => (value.created.millisecondsSinceEpoch >
                  element.created.millisecondsSinceEpoch)
              ? value
              : element)
          .created
          .millisecondsSinceEpoch
          .toString();
  }

  void setCurrentTopic(String? topic) {
    currentTopicName = topic ?? "";
    if (topic != null) {
      emit(currentTopicName);
      messages = localRepository.getMessagesOfTopic(topic);
    }
  }

  void saveMessage(Message parsedResult) {
    localRepository.saveMessage(parsedResult, currentTopicName);
    lastMessageId = messages
        .reduce((value, element) => (value.created.millisecondsSinceEpoch >
                element.created.millisecondsSinceEpoch)
            ? value
            : element)
        .created
        .millisecondsSinceEpoch
        .toString();
  }
}

class RefreshLatest extends Cubit<bool> {
  RefreshLatest() : super(false);

  void refresh() {
    emit(true);
  }
}
