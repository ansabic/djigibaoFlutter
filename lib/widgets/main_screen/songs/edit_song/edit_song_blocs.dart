import 'package:bloc/bloc.dart';
import 'package:djigibao_manager/database/entities/attachment.dart';
import 'package:djigibao_manager/database/entities/song.dart';
import 'package:djigibao_manager/database/local_repository.dart';
import 'package:djigibao_manager/firebase/firestore/songs_repository_remote.dart';
import 'package:file_picker/file_picker.dart';
import 'package:djigibao_manager/firebase/storage/attachment_repository_remote.dart';

class EditSongManager extends Cubit<bool> {
  final localRepository = LocalRepository();
  final remoteRepository = SongsRepositoryRemote();
  final remoteAttachmentRepository = AttachmentRepositoryRemote();
  late final List<Attachment> attachments;

  final newAttachments = List<Attachment>.empty(growable: true);
  final attachmentsToDelete = List<Attachment>.empty(growable: true);

  var loadingVisibility = false;

  final String? oldName;

  EditSongManager({required this.oldName}) : super(true);

  Future<void> editSong(Song song) async {
    if (song.title != oldName && oldName != null) {
      await localRepository.removeSong(oldName ?? "");
      remoteRepository.removeSongRemote(oldName ?? "");
    }
    localRepository.saveSong(song);
    localRepository.saveAttachments(attachments, song.title);
    remoteRepository.insertSongRemote(song);
    newAttachments.forEach((element) {
      remoteAttachmentRepository.uploadFile(element, song.title);
    });
    attachmentsToDelete.forEach((element) {
      if(!newAttachments.contains(element))
        remoteAttachmentRepository.deleteFile(oldName??"", element);
    });
  }

  void deleteSong() async {
    await localRepository.removeSong(oldName ?? "");
    remoteRepository.removeSongRemote(oldName ?? "");
    final relatedAttachments = localRepository.getAttachmentsLocalWithSong(oldName ?? "");
    localRepository.deleteAttachmentsForSong(oldName ?? "");
    relatedAttachments.forEach((element) {
      remoteAttachmentRepository.deleteFile(oldName ?? "",element);
    });
  }

  void check(String title, String author, String body) {
    if (title.isEmpty || author.isEmpty || body.isEmpty)
      emit(false);
    else
      emit(true);
  }

  void removeAttachment(Attachment attachment) {
    attachments.remove(attachment);
    if(newAttachments.contains(attachment))
      newAttachments.remove(attachment);
    attachmentsToDelete.add(attachment);
  }

  Future<void> pickAttachment() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      final singleResult = result.files.single;
      final newAttachment = Attachment(
          name: singleResult.name,
          localLocation: singleResult.path ?? "",
          type: singleResult.extension ?? "");
      attachments.add(newAttachment);
      newAttachments.add(newAttachment);
    }
  }
}
