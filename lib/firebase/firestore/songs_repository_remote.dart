import 'package:djigibao_manager/constants.dart';
import 'package:djigibao_manager/database/entities/song.dart';
import 'package:djigibao_manager/database/local_repository.dart';
import 'package:hive_flutter/adapters.dart';

import 'base.dart';

class SongsRepositoryRemote {
  final collectionSongs = FirestoreBase().collectionSongs;
  final localRepository = LocalRepository();

  Future<void> syncSongsRemote() async {
    final songsRemote = await getAllSongsRemote();
    updateRemoteLocal(songsRemote);
    insertRemoteLocal(songsRemote);
    localRepository.updateSongsSyncTime();
  }

  Future<List<Song>> getAllSongsRemote() async {
    final result = await collectionSongs.get();
    final songsRemote = List<Song>.empty(growable: true);
    result.docs.forEach((element) {
      final item = Song.fromJson(element.data());
      songsRemote.add(item);
    });
    return songsRemote;
  }

  Future<void> insertSongRemote(Song song) async {
    await collectionSongs.doc(song.title).set(song.toJson());
  }

  void updateRemoteLocal(List<Song> songsRemote) {
    final localRepository = LocalRepository();
    final localSongs = Hive.box(HIVE_SONGS).values.cast<Song>();
    final common = localSongs
        .map((e) => e.title)
        .toSet()
        .intersection(songsRemote.map((e) => e.title).toSet());
    common.forEach((commonTitle) {
      final local =
          localSongs.firstWhere((element) => element.title == commonTitle);
      final remote =
          songsRemote.firstWhere((element) => element.title == commonTitle);

      final lastModifiedRemote = remote.lastModified;
      final lastModifiedLocal = local.lastModified;

      if (lastModifiedRemote.isAfter(lastModifiedLocal)) {
        localRepository.saveSong(remote);
      }
      if (lastModifiedLocal.isAfter(lastModifiedRemote)) {
        insertSongRemote(local);
      }
    });
  }

  void insertRemoteLocal(List<Song> songsRemote) {
    final localRepository = LocalRepository();
    final localSongs = Hive.box(HIVE_SONGS).values.cast<Song>();

    final newLocal = localSongs
        .map((e) => e.title)
        .where((element) => !songsRemote.map((e) => e.title).contains(element));
    final newRemote = songsRemote
        .map((e) => e.title)
        .where((element) => !localSongs.map((e) => e.title).contains(element));
    newLocal.forEach((title) async {
      await collectionSongs.doc(title).set(
          localSongs.firstWhere((element) => title == element.title).toJson());
    });
    newRemote.forEach((title) async {
      await localRepository.saveSong(
          songsRemote.firstWhere((element) => element.title == title));
    });
  }
}
