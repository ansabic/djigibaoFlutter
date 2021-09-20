import 'package:djigibao_manager/database/entities/song.dart';
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
                navigation.navigateFromHomeTo(HomeDestination.AddSong);
              },
              child: Icon(Icons.add),
            ),
            body: ListView.builder(
              itemCount: songsManager.songs.length,
              itemBuilder: (context, position) {
                return SongItem(
                    title: (songsManager.songs[position] as Song).title,
                    author: (songsManager.songs[position] as Song).author,
                    body: (songsManager.songs[position] as Song).body);
              },
            )),
        onWillPop: () async => false);
  }
}

class SongItem extends StatefulWidget {
  final String title;
  final String author;
  final String body;

  SongItem({required this.title, required this.author, required this.body});

  @override
  State<StatefulWidget> createState() =>
      _SongItem(title: title, author: author, body: body);
}

class _SongItem extends State<SongItem> {
  var detailsVisible = false;
  final String title;
  final String author;
  final String body;

  _SongItem({required this.title, required this.author, required this.body});

  @override
  Widget build(BuildContext context) {
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
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.amber,
                      ),
                    ),
                    Spacer(flex: 84),
                    Icon(Icons.edit)
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
                                  author,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.amber,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Text(
                            body,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.amber,
                            ),
                          ),
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
