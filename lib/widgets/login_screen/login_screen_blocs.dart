import 'package:bloc/bloc.dart';
import 'package:djigibao_manager/database/entities/role.dart';
import 'package:djigibao_manager/database/entities/user.dart';
import 'package:djigibao_manager/database/local_repository.dart';
import 'package:djigibao_manager/firebase/firestore/user_repository_remote.dart';

class FieldController extends Cubit<String> {
  FieldController() : super("");

  void changeField(String field) {
    emit(field);
  }
}

class RolePicked {
  String rolePicked = roleToValue(Role.Vocal);

  void changeRole(String role) {
    rolePicked = role;
  }
}

class LoginUser {
  Future<void> loginUserLocallyAndRemote(User user, String password) async {
    final userRepositoryRemote = UserRepositoryRemote();
    final localRepository = LocalRepository();

    await userRepositoryRemote.insertUserRemote(user);
    localRepository.saveThisUser(user);
    localRepository.savePassword(password);
  }
}
