import 'package:djigibao_manager/database/entities/song.dart';
import 'package:djigibao_manager/navigation/destination.dart';
import 'package:djigibao_manager/navigation/navigation.dart';
import 'package:djigibao_manager/widgets/main_screen/songs/add_song/add_song_screen.dart';
import 'package:djigibao_manager/widgets/main_screen/songs/edit_song/edit_song_blocs.dart';
import 'package:flutter/material.dart';

class EditSongScreen extends StatefulWidget {
  final Song? song;

  EditSongScreen({required this.song});

  @override
  State<StatefulWidget> createState() => _EditSongScreen(song: song);
}

class _EditSongScreen extends State<EditSongScreen> {
  final Song? song;

  _EditSongScreen({required this.song});

  late final TextEditingController titleController;
  late final TextEditingController bodyController;
  late final TextEditingController authorController;

  late final EditSongManager editSongManager;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: song?.title);
    bodyController = TextEditingController(text: song?.body);
    authorController = TextEditingController(text: song?.author);

    editSongManager = EditSongManager(oldName: song?.title);
    editSongManager.attachments = editSongManager.localRepository
        .getAttachmentsLocalWithSong(song?.title ?? "");
  }

  @override
  Widget build(BuildContext context) {
    final navigation = Navigation(context: context);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: FloatingActionButton(
                onPressed: () {
                  editSongManager.deleteSong();
                  navigation.navigateFromStartTo(MainDestination.Home);
                },
                child: Icon(Icons.delete)),
          ),
          StreamBuilder<bool>(
            stream: editSongManager.stream,
            builder: (context, snapshot) {
              return Visibility(
                visible: snapshot.data ?? true,
                child: FloatingActionButton(
                  onPressed: () async {
                    await editSongManager.editSong(Song(
                        title: titleController.text,
                        body: bodyController.text,
                        author: authorController.text,
                        created: song?.created ?? DateTime.now(),
                        lastModified: DateTime.now()));
                    navigation.navigateFromStartTo(MainDestination.Home);
                  },
                  child: Icon(Icons.save),
                ),
              );
            },
          )
        ],
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
                  ),
                  SizedBox(
                      height: 200,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: ListView.builder(
                          padding: EdgeInsets.only(top: 0),
                          itemCount: editSongManager.attachments.length,
                          itemBuilder: (context, position) {
                            return AttachmentItem(
                                attachment:
                                    editSongManager.attachments[position]);
                          },
                        ),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
