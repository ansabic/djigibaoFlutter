import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:djigibao_manager/navigation/destination.dart';
import 'package:djigibao_manager/widgets/main_screen/main_screen_blocs.dart';
import 'package:djigibao_manager/widgets/main_screen/settings/settings_screen.dart';
import 'package:djigibao_manager/widgets/main_screen/songs/add_song/add_song_screen.dart';
import 'package:djigibao_manager/widgets/main_screen/songs/songs_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

import 'account/account_screen.dart';
import 'events/events_screen.dart';

class MainScreen extends StatelessWidget {
  final mainScreenManager = MainScreenManager();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body: StreamBuilder<HomeDestination>(
            stream: mainScreenManager.stream,
            builder: (context, snapshot) {
              return MainScreenSwitch(
                destination: snapshot.data ?? HomeDestination.Songs,
              );
            },
          ),
          backgroundColor: Theme.of(context).backgroundColor,
          bottomNavigationBar: CurvedNavigationBar(
            onTap: (position) {
              mainScreenManager.changeDestination(position);
            },
            backgroundColor: Theme.of(context).backgroundColor,
            color: Theme.of(context).backgroundColor,
            items: [
              Icon(
                Icons.list,
              ),
              Icon(Icons.event),
              Icon(Icons.settings),
              Icon(Icons.account_circle)
            ],
          ),
        ));
  }
}

class MainScreenSwitch extends StatelessWidget {
  final HomeDestination destination;

  MainScreenSwitch({required this.destination});

  @override
  Widget build(BuildContext context) {
    switch (destination) {
      case HomeDestination.Songs:
        return SongsScreen();
      case HomeDestination.Events:
        return EventsScreen();
      case HomeDestination.Settings:
        return SettingsScreen();
      case HomeDestination.Account:
        return AccountScreen();
      case HomeDestination.AddSong:
        return AddSongScreen();
    }
  }
}
