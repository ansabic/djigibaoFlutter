import 'package:collection/collection.dart';
import 'package:djigibao_manager/database/entities/song.dart';
import 'package:djigibao_manager/database/local_repository.dart';
import 'package:djigibao_manager/navigation/destination.dart';
import 'package:djigibao_manager/navigation/navigation.dart';
import 'package:djigibao_manager/widgets/main_screen/songs/songs_blocs.dart';
import 'package:flutter/material.dart';

class SongsScreen extends StatelessWidget {
  final songsManager = SongsManager();



  @override
  Widget build(BuildContext context) {
    final navigation = Navigation(context: context);
    return WillPopScope(
        child: Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                navigation.navigateFromSong(
                    destination: SongDestination.AddSong);
              },
              child: Icon(Icons.add),
            ),
            body: ListView.builder(
              itemCount: songsManager.songs.length,
              itemBuilder: (context, position) {
                return SongItem(song: songsManager.songs[position] as Song);
              },
            )),
        onWillPop: () async => false);
  }
}

class SongItem extends StatefulWidget {
  final Song song;

  SongItem({required this.song});

  @override
  State<StatefulWidget> createState() => _SongItem(song: song);


}

class _SongItem extends State<SongItem> {
  var detailsVisible = false;
  final Song song;
  final player = SongsManager().player;
  final localRepository = LocalRepository();

  _SongItem({required this.song});


  @override
  void initState() {
    super.initState();
    player.setLocation(localRepository
            .getAttachmentsLocalWithSong(song.title)
            .firstWhereOrNull((element) =>
                element.type.contains("mp3") || element.type.contains("wav"))
            ?.localLocation ??
        "");
  }


  @override
  void dispose() {
    super.dispose();
    player.stop();
  }

  @override
  Widget build(BuildContext context) {
    final navigation = Navigation(context: context);
    return GestureDetector(
      onTap: () {
        setState(() {
          detailsVisible = !detailsVisible;
        });
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Card(
          color: Theme.of(context).backgroundColor,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(flex: 100),
                    Text(
                      song.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.amber,
                      ),
                    ),
                    Spacer(flex: 70),
                    IconButton(
                        onPressed: () {
                          navigation.navigateFromSong(
                              destination: SongDestination.EditSong,
                              song: song);
                        },
                        icon: Icon(Icons.edit))
                  ],
                ),
                Visibility(
                  visible: detailsVisible,
                  child: Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  song.author,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.amber,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Text(
                            song.body,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.amber,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                            child: Center(
                              child: IconButton(
                                icon: Icon(Icons.play_arrow),
                                onPressed: () {
                                  player.play();
                                },)
                            ),
                          )
                        ],
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
