import 'package:djigibao_manager/constants.dart';
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

  Future<void> savePassword(String password) async {
    await Hive.box(HIVE_USER).put(HIVE_PASSWORD, password);
  }

  Future<void> saveThisUser(User user) async {
    await Hive.box(HIVE_USER).put(HIVE_USER, user);
  }

  Future<void> saveSong(Song song) async {
    await Hive.box(HIVE_SONGS).put(song.title, song);
  }

  List<Song> getSongs() {
    return Hive.box(HIVE_SONGS).values.toList() as List<Song>;
  }

  Future<void> updateSongsSyncTime() async {
    await Hive.box(HIVE_SYNC_TIME).put(HIVE_LAST_SONGS_SYNC, DateTime.now());
  }

  Future<void> updateUsersSyncTime() async {
    await Hive.box(HIVE_SYNC_TIME).put(HIVE_LAST_USERS_SYNC, DateTime.now());
  }

  Future<DateTime> getSongsLastSync() async {
    return await Hive.box(HIVE_SYNC_TIME).get(HIVE_LAST_SONGS_SYNC) as DateTime;
  }

  Future<DateTime> getUsersLastSync() async {
    return await Hive.box(HIVE_SYNC_TIME).get(HIVE_LAST_USERS_SYNC) as DateTime;
  }
}
