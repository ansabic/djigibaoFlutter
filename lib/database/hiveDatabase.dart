import 'package:hive_flutter/adapters.dart';

Future<String> initHive() async {
  await Hive.initFlutter("djigibao_manager");
  final result =  await Hive.openBox("user");
  if(result.isNotEmpty)
    return await result.get("owner");
  else
    return "";
}