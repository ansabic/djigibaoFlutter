import 'dart:math';

import 'package:djigibao_manager/database/entities/attachment.dart';
import 'package:djigibao_manager/database/entities/song.dart';
import 'package:djigibao_manager/navigation/destination.dart';
import 'package:djigibao_manager/navigation/navigation.dart';
import 'package:djigibao_manager/widgets/main_screen/songs/add_song/add_song_blocs.dart';
import 'package:flutter/material.dart';

class AddSongScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddSongScreen();
}

class _AddSongScreen extends State<AddSongScreen> {
  final titleController = TextEditingController();
  final bodyController = TextEditingController();
  final authorController = TextEditingController();

  final addSongManager = AddSongManager();

  @override
  Widget build(BuildContext context) {
    final navigation = Navigation(context: context);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      floatingActionButton: StreamBuilder<bool>(
        stream: addSongManager.stream,
        builder: (context, snapshot) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: FloatingActionButton(
                    onPressed: () async {
                      await addSongManager.pickAttachment();
                      setState(() {});
                    },
                    child: Transform.rotate(
                        angle: pi / 2, child: Icon(Icons.attachment)),
                  )),
              Visibility(
                visible: snapshot.data ?? false,
                child: FloatingActionButton(
                  onPressed: () async {
                    await addSongManager.addSong(Song(
                        title: titleController.text,
                        body: bodyController.text,
                        author: authorController.text,
                        created: DateTime.now(),
                        lastModified: DateTime.now()));
                    navigation.navigateFromStartTo(MainDestination.Home);
                  },
                  child: Icon(Icons.add),
                ),
              )
            ],
          );
        },
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 50, horizontal: 30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 30),
                child: TextField(
                  onChanged: (title) => addSongManager.check(
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
                        onChanged: (title) => addSongManager.check(
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
                    onChanged: (title) => addSongManager.check(
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
                          itemCount: addSongManager.attachments.length,
                          itemBuilder: (context, position) {
                            return AttachmentItem(
                                attachment:
                                    addSongManager.attachments[position]);
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

class AttachmentItem extends StatelessWidget {
  final Attachment attachment;

  AttachmentItem({required this.attachment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(attachment.name,
                style: TextStyle(
                  color: Colors.amber,
                )),
          ),
        ],
      ),
    );
  }
}
