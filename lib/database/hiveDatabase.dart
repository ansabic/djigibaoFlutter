import 'package:djigibao_manager/constants.dart';
import 'package:djigibao_manager/database/entities/attachment.dart';
import 'package:djigibao_manager/database/entities/event.dart';
import 'package:djigibao_manager/database/entities/event_type.dart';
import 'package:djigibao_manager/database/entities/role.dart';
import 'package:djigibao_manager/database/entities/song.dart';
import 'package:hive_flutter/adapters.dart';

import 'entities/user.dart';

Future<String> initHive() async {
  await Hive.initFlutter(APP_NAME);
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(RoleAdapter());
  Hive.registerAdapter(SongAdapter());
  Hive.registerAdapter(AttachmentAdapter());
  Hive.registerAdapter(EventTypeAdapter());
  Hive.registerAdapter(EventAdapter());

  await Hive.openBox(HIVE_SONGS);
  await Hive.openBox(HIVE_SYNC_TIME);
  await Hive.openBox(HIVE_ATTACHMENTS);
  await Hive.openBox(HIVE_EVENTS);

  final result = await Hive.openBox(HIVE_USER);
  if (result.isNotEmpty)
    return (result.get(HIVE_USER) as User).name;
  else
    return "";
}
