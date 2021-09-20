import 'package:bloc/bloc.dart';
import 'package:djigibao_manager/database/entities/song.dart';
import 'package:djigibao_manager/database/local_repository.dart';
import 'package:djigibao_manager/firebase/firestore/songs_repository_remote.dart';

class AddSongManager extends Cubit<bool> {
  AddSongManager() : super(false);

  void check(String title, String author, String body) {
    if (title.isNotEmpty && author.isNotEmpty && body.isNotEmpty)
      emit(true);
    else
      emit(false);
  }

  Future<void> addSong(Song song) async {
    final remoteRepository = SongsRepositoryRemote();
    final localRepository = LocalRepository();

    await remoteRepository.insertSongRemote(song);
    await localRepository.saveSong(song);
  }
}
