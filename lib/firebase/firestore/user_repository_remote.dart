import 'package:djigibao_manager/firebase/firestore/base.dart';
import 'package:djigibao_manager/database/entities/user.dart';

class UserRepositoryRemote {
  final collectionUsers = FirestoreBase().collectionUsers;

  Future<void> getAllUsersRemote() async {}

  Future<void> insertUserRemote(User user) async {
    await collectionUsers.doc(user.name).set(user.toJson());
  }
}
