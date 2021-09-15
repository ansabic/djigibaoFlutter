import 'package:djigibao_manager/constants.dart';
import 'package:hive_flutter/adapters.dart';

Future<String> initHive() async {
  await Hive.initFlutter(APP_NAME);
  final result = await Hive.openBox(HIVE_USER);
  if (result.isNotEmpty)
    return await result.get(HIVE_OWNER);
  else
    return "";
}
