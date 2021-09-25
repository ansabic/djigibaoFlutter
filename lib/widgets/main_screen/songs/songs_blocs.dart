import 'package:bloc/bloc.dart';
import 'package:djigibao_manager/constants.dart';
import 'package:djigibao_manager/services/audio_player.dart';
import 'package:hive_flutter/adapters.dart';

class SongsManager extends Cubit<bool> {
  List<dynamic> songs = Hive.box(HIVE_SONGS).values.toList();
  final player = Player();

  SongsManager() : super(false);

  void hide() => emit(false);

  void show() => emit(true);
}
