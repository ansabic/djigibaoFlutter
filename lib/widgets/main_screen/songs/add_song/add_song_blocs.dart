import 'package:bloc/bloc.dart';
import 'package:djigibao_manager/database/entities/attachment.dart';
import 'package:djigibao_manager/database/entities/song.dart';
import 'package:djigibao_manager/database/local_repository.dart';
import 'package:djigibao_manager/firebase/firestore/songs_repository_remote.dart';
import 'package:file_picker/file_picker.dart';

class AddSongManager extends Cubit<bool> {
  AddSongManager() : super(false);
  final attachments = List<Attachment>.empty(growable: true);

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

  Future<void> pickAttachment() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      final singleResult = result.files.single;
      attachments.add(Attachment(
          name: singleResult.name,
          location: singleResult.path ?? "",
          type: singleResult.extension ?? ""));
    }
  }
}
