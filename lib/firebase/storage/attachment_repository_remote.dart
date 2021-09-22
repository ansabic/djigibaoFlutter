import 'dart:io';

import 'package:djigibao_manager/database/entities/attachment.dart';
import 'package:djigibao_manager/firebase/storage/base.dart';

class AttachmentRepositoryRemote {
  final attachmentsReference = StorageBase().attachmentsReference;

  void uploadFile(Attachment attachment, String name) {
    final file = File(attachment.localLocation);
    attachmentsReference.child(name).child(attachment.name).putFile(file);
  }
}
