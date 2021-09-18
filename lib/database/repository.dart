import 'package:djigibao_manager/constants.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'entities/user.dart';

class LocalRepository {
  Future<String> getPassword() async {
    final box = await Hive.openBox(HIVE_USER);
    if (box.isNotEmpty)
      return await box.get(HIVE_PASSWORD);
    else
      return "";
  }

  Future<User> getUser() async {
    final box = await Hive.openBox(HIVE_USER);
    return await box.get(HIVE_USER) as User;
  }

  Future<void> savePassword(String password) async {
    await Hive.box(HIVE_USER).put(HIVE_PASSWORD, password);
  }

  Future<void> saveThisUser(User user) async {
    await Hive.box(HIVE_USER).put(HIVE_USER, user);
  }
}
