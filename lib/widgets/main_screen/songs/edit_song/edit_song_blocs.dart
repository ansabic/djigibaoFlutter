import 'package:bloc/bloc.dart';
import 'package:djigibao_manager/database/entities/song.dart';
import 'package:djigibao_manager/database/local_repository.dart';
import 'package:djigibao_manager/firebase/firestore/songs_repository_remote.dart';

class EditSongManager extends Cubit<bool> {
  final localRepository = LocalRepository();
  final remoteRepository = SongsRepositoryRemote();

  final String? oldName;

  EditSongManager({required this.oldName}) : super(true);

  Future<void> editSong(Song song) async {
    if (song.title != oldName && oldName != null) {
      await localRepository.removeSong(oldName ?? "");
      await remoteRepository.removeSongRemote(oldName ?? "");
    }
    await localRepository.saveSong(song);
    await remoteRepository.insertSongRemote(song);
  }

  Future<void> deleteSong() async {
    await localRepository.removeSong(oldName ?? "");
    await remoteRepository.removeSongRemote(oldName ?? "");
  }

  void check(String title, String author, String body) {
    if (title.isEmpty || author.isEmpty || body.isEmpty)
      emit(false);
    else
      emit(true);
  }
}
