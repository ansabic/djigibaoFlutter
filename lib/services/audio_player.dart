import 'package:audioplayers/audioplayers.dart';

class Player {
  final AudioPlayer player = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);

  String location = "";

  void setLocation(String newLocation) {
    location = newLocation;
  }

  Future<void> play() async {
    if (location.isNotEmpty) await player.play(location, isLocal: true);
  }

  Future<void> pause() async {
    if (location.isNotEmpty) await player.pause();
  }

  Future<void> stop() async {
    if (location.isNotEmpty) await player.stop();
  }

  Future<void> ffExactly(int minutes, int seconds) async {
    if (location.isNotEmpty)
      await player.seek(Duration(minutes: minutes, seconds: seconds));
  }

  Future<void> ff(int percent, Duration duration) async {
    if (location.isNotEmpty)
      await player.seek(Duration(seconds: duration.inSeconds * percent ~/ 100));
  }
}
