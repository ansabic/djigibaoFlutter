import 'package:djigibao_manager/constants.dart';
import 'package:djigibao_manager/database/entities/attachment.dart';
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

  Future<User> getUser() async {
    final box = await Hive.openBox(HIVE_USER);
    return await box.get(HIVE_USER) as User;
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

  void removeSong(String title) {
    Hive.box(HIVE_SONGS).delete(title);
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

  List<Attachment> getAttachmentsLocal() {
    return Hive.box(HIVE_ATTACHMENTS).values.cast<Attachment>().toList();
  }

  List<Attachment> getAttachmentsLocalWithSong(String songName) {
    return (Hive.box(HIVE_ATTACHMENTS).get(songName) as List<dynamic>)
        .map((e) => e as Attachment)
        .toList();
  }

  Future<DateTime> getSongsLastSync() async {
    return await Hive.box(HIVE_SYNC_TIME).get(HIVE_LAST_SONGS_SYNC) as DateTime;
  }

  Future<DateTime> getUsersLastSync() async {
    return await Hive.box(HIVE_SYNC_TIME).get(HIVE_LAST_USERS_SYNC) as DateTime;
  }
}
