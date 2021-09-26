import 'package:bloc/bloc.dart';
import 'package:djigibao_manager/database/entities/attachment.dart';
import 'package:djigibao_manager/database/entities/song.dart';
import 'package:djigibao_manager/database/local_repository.dart';
import 'package:djigibao_manager/firebase/firestore/songs_repository_remote.dart';
import 'package:file_picker/file_picker.dart';

class EditSongManager extends Cubit<bool> {
  final localRepository = LocalRepository();
  final remoteRepository = SongsRepositoryRemote();
  late final List<Attachment> attachments;

  final String? oldName;

  EditSongManager({required this.oldName}) : super(true);

  Future<void> editSong(Song song) async {
    if (song.title != oldName && oldName != null) {
      localRepository.removeSong(oldName ?? "");
      remoteRepository.removeSongRemote(oldName ?? "");
    }
    localRepository.saveSong(song);
    localRepository.saveAttachments(attachments, song.title);
    remoteRepository.insertSongRemote(song);
  }

  void deleteSong() {
    localRepository.removeSong(oldName ?? "");
    remoteRepository.removeSongRemote(oldName ?? "");
  }

  void check(String title, String author, String body) {
    if (title.isEmpty || author.isEmpty || body.isEmpty)
      emit(false);
    else
      emit(true);
  }

  Future<void> pickAttachment() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      final singleResult = result.files.single;
      final newAttachment = Attachment(
          name: singleResult.name,
          localLocation: singleResult.path ?? "",
          remoteLocation: "",
          type: singleResult.extension ?? "");
      attachments.add(newAttachment);
    }
  }
}
