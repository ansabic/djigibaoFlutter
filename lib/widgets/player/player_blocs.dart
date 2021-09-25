import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:djigibao_manager/database/entities/attachment.dart';
import 'package:djigibao_manager/database/entities/song.dart';
import 'package:djigibao_manager/database/local_repository.dart';
import 'package:djigibao_manager/services/audio_player.dart';

class SongPlayerManager extends Cubit<bool> {
  final Song song;

  SongPlayerManager({required this.song}) : super(false);

  final repository = LocalRepository();
  final player = Player();
  late final Attachment? songFile;
  late final int duration;

  void init() {
    songFile = repository
        .getAttachmentsLocalWithSong(song.title)
        .firstWhereOrNull((element) => element.type.contains("mp3"));
    if (songFile != null) player.setLocation(songFile!.localLocation);
  }

  void play() {
    player.play();
    emit(true);
  }

  void stop() {
    player.stop();
    emit(false);
  }

  void pause() {
    player.pause();
    emit(false);
  }
}
