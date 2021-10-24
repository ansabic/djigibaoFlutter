import 'package:djigibao_manager/constants.dart';
import 'package:djigibao_manager/database/entities/attachment.dart';
import 'package:djigibao_manager/database/entities/event.dart';
import 'package:djigibao_manager/database/entities/message.dart';
import 'package:djigibao_manager/database/entities/topic.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'entities/song.dart';
import 'entities/user.dart';

class LocalRepository {
  Future<String> getPassword() async {
    final box = await Hive.openBox(HIVE_USER);
    if (box.isNotEmpty)
      return await box.get(HIVE_PASSWORD);
    else
      return "";
  }

  User getUser() {
    return Hive.box(HIVE_USER).get(HIVE_USER);
  }

  List<User> getUsers() {
    return Hive.box(HIVE_USERS).values.toList().cast<User>();
  }

  void savePassword(String password) {
    Hive.box(HIVE_USER).put(HIVE_PASSWORD, password);
  }

  void saveThisUser(User user) {
    Hive.box(HIVE_USER).put(HIVE_USER, user);
  }

  void saveSong(Song song) {
    Hive.box(HIVE_SONGS).put(song.title, song);
  }

  Future<void> removeSong(String title) async {
    await Hive.box(HIVE_SONGS).delete(title);
  }

  List<Song> getAllSongs() {
    return Hive.box(HIVE_SONGS).values.toList().cast<Song>();
  }

  void updateSongsSyncTime() {
    Hive.box(HIVE_SYNC_TIME).put(HIVE_LAST_SONGS_SYNC, DateTime.now());
  }

  void updateUsersSyncTime() {
    Hive.box(HIVE_SYNC_TIME).put(HIVE_LAST_USERS_SYNC, DateTime.now());
  }

  void saveAttachments(List<Attachment> attachments, String name) {
    Hive.box(HIVE_ATTACHMENTS).put(name, attachments);
  }

  void updateAttachment(Attachment attachment, String name) {
    Hive.box(HIVE_ATTACHMENTS).put(name, attachment);
  }

  void deleteAttachmentsForSong(String songName) {
    Hive.box(HIVE_ATTACHMENTS).delete(songName);
  }

  List<Attachment> getAttachmentsLocal() {
    return (Hive.box(HIVE_ATTACHMENTS).values).cast<Attachment>().toList();
  }

  List<Attachment> getAttachmentsLocalWithSong(String songName) {
    return (Hive.box(HIVE_ATTACHMENTS).get(songName) as Iterable)
        .cast<Attachment>()
        .toList();
  }

  Future<DateTime> getSongsLastSync() async {
    return await Hive.box(HIVE_SYNC_TIME).get(HIVE_LAST_SONGS_SYNC) as DateTime;
  }

  Future<DateTime> getUsersLastSync() async {
    return await Hive.box(HIVE_SYNC_TIME).get(HIVE_LAST_USERS_SYNC) as DateTime;
  }

  List<Event> getAllEvents() {
    return (Hive.box(HIVE_EVENTS).values).cast<Event>().toList();
  }

  void saveEvent(Event event) {
    Hive.box(HIVE_EVENTS).put(event.description, event);
  }

  Future<void> deleteEvent(Event event) async {
    await Hive.box(HIVE_EVENTS).delete(event.description);
  }

  List<Topic> getAllTopics() {
    return (Hive.box(HIVE_TOPICS).values).cast<Topic>().toList();
  }

  Future<void> saveTopic(Topic topic) async {
    await Hive.box(HIVE_TOPICS).put(topic.name, topic);
  }

  Future<void> deleteTopic(Topic topic) async {
    await Hive.box(HIVE_TOPICS).delete(topic.name);
  }

  List<Message> getAllMessages() {
    return (Hive.box(HIVE_MESSAGES).values).cast<Message>().toList();
  }

  void saveMessage(Message message, String topic) async {
    await Hive.box(HIVE_MESSAGES).put(message.created.toString(), message);
    await Hive.box(HIVE_MESSAGE_TOPIC_RELATION)
        .add(Map.fromEntries([MapEntry(topic, message.created.toString())]));
  }

  List<Message> getMessagesOfTopic(String topic) {
    List<Message> messages = List<Message>.empty(growable: true);
    List<Map<String, String>> newRelations = List.empty(growable: true);
    Hive.box(HIVE_MESSAGE_TOPIC_RELATION).values.forEach((element) {
      newRelations.add(Map.from(element));
    });
    newRelations.forEach((element) {
      if (element.keys.contains(topic))
        messages.add(Hive.box(HIVE_MESSAGES).get(element[topic]));
    });
    messages.sort((a, b) => b.created.millisecondsSinceEpoch
        .compareTo(a.created.millisecondsSinceEpoch));
    return messages;
  }
}
