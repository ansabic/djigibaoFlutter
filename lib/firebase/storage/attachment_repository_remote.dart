import 'dart:io';

import 'package:djigibao_manager/database/entities/attachment.dart';
import 'package:djigibao_manager/database/entities/song.dart';
import 'package:djigibao_manager/database/local_repository.dart';
import 'package:djigibao_manager/firebase/storage/base.dart';

import '../../constants.dart';

class AttachmentRepositoryRemote {
  final attachmentsReference = StorageBase().attachmentsReference;
  final localRepository = LocalRepository();


  void uploadFile(Attachment attachment, String name) {
    final file = File(attachment.localLocation);
    attachmentsReference.child(name).child(attachment.name).putFile(
        file);

    }

  void deleteFile(String songName, Attachment attachment) {
    attachmentsReference.child(songName).child(attachment.name).delete();
  }
}
