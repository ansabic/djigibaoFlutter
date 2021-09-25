import 'package:djigibao_manager/database/entities/song.dart';
import 'package:djigibao_manager/widgets/player/player_blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SongPlayer extends StatelessWidget {
  final Song song;
  late final SongPlayerManager playerManager;

  SongPlayer({required this.song});

  @override
  Widget build(BuildContext context) {
    playerManager = SongPlayerManager(song: song);
    playerManager.init();
    return Container(
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      height: 50,
                      child: StreamBuilder<bool>(
                          stream: playerManager.stream,
                          builder: (context, snapshot) {
                            return Visibility(
                              visible: !playerManager.state,
                              child: IconButton(
                                  onPressed: () {
                                    playerManager.play();
                                  },
                                  icon: Icon(Icons.play_arrow)),
                            );
                          })),
                  Container(
                      height: 50,
                      child: StreamBuilder<bool>(
                          stream: playerManager.stream,
                          builder: (context, snapshot) {
                            return Visibility(
                              visible: playerManager.state,
                              child: IconButton(
                                  onPressed: () {
                                    playerManager.pause();
                                  },
                                  icon: Icon(Icons.pause)),
                            );
                          })),
                  Container(
                      height: 50,
                      child: StreamBuilder<bool>(
                          stream: playerManager.stream,
                          builder: (context, snapshot) {
                            return Visibility(
                              visible: playerManager.state,
                              child: IconButton(
                                  onPressed: () {
                                    playerManager.stop();
                                  },
                                  icon: Icon(Icons.stop)),
                            );
                          }))
                ],
              ),
              Container(
                  height: 50,
                  child: StreamBuilder<Duration>(
                      stream:
                          playerManager.player.player.onAudioPositionChanged,
                      builder: (context, current) {
                        return StreamBuilder<Duration>(
                          stream: playerManager.player.player.onDurationChanged,
                          builder: (context, duration) {
                            final totalDuration =
                                (duration.data?.inSeconds ?? 100).toInt();
                            final nowDuration =
                                (current.data?.inSeconds ?? 0).toInt();
                            final minuteInt = (nowDuration ~/ 60);
                            final secondInt = nowDuration % 60;
                            String minuteStringed = minuteInt.toString();
                            if (minuteInt / 10 < 1)
                              minuteStringed = "0$minuteInt";
                            String secondStringed = secondInt.toString();
                            if (secondInt / 10 < 1)
                              secondStringed = "0$secondInt";
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  child: LinearProgressIndicator(
                                    value: nowDuration / totalDuration,
                                    color: Colors.amber,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.amber),
                                  ),
                                ),
                                Text("$minuteStringed:$secondStringed")
                              ],
                            );
                          },
                        );
                      }))
            ],
          )),
    );
  }
}
