import 'package:firebase_storage/firebase_storage.dart';

class StorageBase {
  final attachmentsReference = FirebaseStorage.instance.ref("attachments");
}
