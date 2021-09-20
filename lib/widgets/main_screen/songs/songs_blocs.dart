import 'package:bloc/bloc.dart';
import 'package:djigibao_manager/constants.dart';
import 'package:hive_flutter/adapters.dart';

class SongsManager {
  List<dynamic> songs = Hive.box(HIVE_SONGS).values.toList();
}
