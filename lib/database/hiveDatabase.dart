import 'package:djigibao_manager/constants.dart';
import 'package:djigibao_manager/database/entities/role.dart';
import 'package:hive_flutter/adapters.dart';

import 'entities/user.dart';

Future<String> initHive() async {
  await Hive.initFlutter(APP_NAME);
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(RoleAdapter());

  final result = await Hive.openBox(HIVE_USER);
  if (result.isNotEmpty)
    return (result.get(HIVE_USER) as User).name;
  else
    return "";
}
