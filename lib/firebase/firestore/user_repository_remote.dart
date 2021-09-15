import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:djigibao_manager/firebase/firestore/base.dart';

import '../../constants.dart';

class UserRepositoryRemote {
  final collectionUsers = FirestoreBase().collectionUsers;

  Future<void> getAllUsersRemote() async {}
}
