import 'package:djigibao_manager/database/entities/song.dart';
import 'package:djigibao_manager/navigation/destination.dart';
import 'package:djigibao_manager/navigation/navigation.dart';
import 'package:djigibao_manager/widgets/main_screen/songs/add_song/add_song_blocs.dart';
import 'package:djigibao_manager/widgets/main_screen/songs/edit_song/edit_song_blocs.dart';
import 'package:flutter/material.dart';

class AddSongScreen extends StatelessWidget {
  final titleController = TextEditingController();
  final bodyController = TextEditingController();
  final authorController = TextEditingController();

  final editSongManager = EditSongManager();

  @override
  Widget build(BuildContext context) {
    final navigation = Navigation(context: context);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await editSongManager.editSong(Song(
              title: titleController.text,
              body: bodyController.text,
              author: authorController.text,
              created: DateTime.now(),
              lastModified: DateTime.now()));
          navigation.navigateFromStartTo(MainDestination.Home);
        },
        child: Icon(Icons.add),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 50, horizontal: 30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 30),
                child: TextField(
                  onChanged: (title) => editSongManager.check(
                      titleController.text,
                      authorController.text,
                      bodyController.text),
                  style: TextStyle(color: Colors.amber),
                  textAlign: TextAlign.center,
                  controller: titleController,
                  decoration: InputDecoration(hintText: "Title"),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 140,
                      child: TextField(
                        onChanged: (title) => editSongManager.check(
                            titleController.text,
                            authorController.text,
                            bodyController.text),
                        style: TextStyle(color: Colors.amber),
                        textAlign: TextAlign.center,
                        controller: authorController,
                        decoration: InputDecoration(hintText: "Author"),
                      ),
                    )
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  TextField(
                    onChanged: (title) => editSongManager.check(
                        titleController.text,
                        authorController.text,
                        bodyController.text),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    minLines: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.amber,
                    ),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: "Song Body"),
                    controller: bodyController,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
