import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:djigibao_manager/constants.dart';

class FirestoreBase {
  final collectionUsers =
      FirebaseFirestore.instance.collection(FIRESTORE_USERS);

  void init() {}
}
