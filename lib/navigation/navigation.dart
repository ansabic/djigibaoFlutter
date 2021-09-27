import 'package:djigibao_manager/database/entities/song.dart';
import 'package:djigibao_manager/database/entities/topic.dart';
import 'package:djigibao_manager/widgets/login_screen/login_screen.dart';
import 'package:djigibao_manager/widgets/main_screen/events/events_screen.dart';
import 'package:djigibao_manager/widgets/main_screen/main_screen.dart';
import 'package:djigibao_manager/widgets/main_screen/settings/settings_screen.dart';
import 'package:djigibao_manager/widgets/main_screen/songs/add_song/add_song_screen.dart';
import 'package:djigibao_manager/widgets/main_screen/songs/edit_song/edit_song_screen.dart';
import 'package:djigibao_manager/widgets/main_screen/songs/songs_screen.dart';
import 'package:djigibao_manager/widgets/main_screen/topics/add_topic/add_topic.dart';
import 'package:djigibao_manager/widgets/main_screen/topics/single_topic/single_topic.dart';
import 'package:djigibao_manager/widgets/main_screen/topics/topics.dart';
import 'package:flutter/material.dart';

import 'destination.dart';

class Navigation {
  final BuildContext context;

  Navigation({required this.context});

  void goBack() {
    Navigator.pop(context);
  }

  void navigateFromStartTo(MainDestination destination) {
    switch (destination) {
      case MainDestination.Login:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
        break;
      case MainDestination.Home:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MainScreen()));
        break;
    }
  }

  void navigateFromHomeTo(HomeDestination destination) {
    switch (destination) {
      case HomeDestination.Songs:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SongsScreen()));
        break;
      case HomeDestination.Events:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => EventsScreen()));
        break;
      case HomeDestination.Settings:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SettingsScreen()));
        break;
      case HomeDestination.Topics:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Topics()));
        break;
    }
  }

  void navigateFromSong({required SongDestination destination, Song? song}) {
    switch (destination) {
      case SongDestination.AddSong:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AddSongScreen()));
        break;
      case SongDestination.EditSong:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditSongScreen(song: song)));
        break;
    }
  }

  void navigateFromTopics(
      {required TopicsDestination destination, Topic? topic}) {
    switch (destination) {
      case TopicsDestination.SingleTopic:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SingleTopic(topic: topic!)));
        break;
      case TopicsDestination.AddTopic:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AddTopic()));
        break;
    }
  }
}
