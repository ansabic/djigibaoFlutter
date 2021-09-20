import 'package:djigibao_manager/database/hiveDatabase.dart';
import 'package:djigibao_manager/firebase/base.dart';
import 'package:djigibao_manager/firebase/firestore/songs_repository_remote.dart';
import 'package:djigibao_manager/firebase/firestore/user_repository_remote.dart';
import 'package:djigibao_manager/widgets/login_screen/login_screen.dart';
import 'package:djigibao_manager/widgets/main_screen/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  final firebase = FirebaseBase();
  firebase.initFirebase();
  final username = await initHive();
  runApp(MyApp(username: username));
}

class MyApp extends StatelessWidget {
  final String username;

  MyApp({required this.username});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            backgroundColor: Colors.white10,
            primarySwatch: Colors.amber,
            hintColor: Colors.white30,
            iconTheme: IconThemeData(color: Colors.amber),
            textTheme: TextTheme(bodyText1: TextStyle(), bodyText2: TextStyle())
                .apply(bodyColor: Colors.white, displayColor: Colors.amber)),
        home: FutureBuilder(
            future: Firebase.initializeApp(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Scaffold(
                  backgroundColor: Theme.of(context).backgroundColor,
                  body: Center(
                    child: Text(snapshot.error.toString(),
                        style: Theme.of(context).textTheme.bodyText1),
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                return FirstSwitchScreen(username: username);
              } else
                return Scaffold(
                  backgroundColor: Theme.of(context).backgroundColor,
                  body: Center(
                    child: Text("Loading...",
                        style: Theme.of(context).textTheme.bodyText1),
                  ),
                );
            }));
  }
}

class FirstSwitchScreen extends StatelessWidget {
  final String username;

  FirstSwitchScreen({required this.username});

  Future<void> syncFirebase() async {
    await SongsRepositoryRemote().syncSongsRemote();
  }

  @override
  Widget build(BuildContext context) {
    if (username == "")
      return LoginScreen();
    else {
      //syncFirebase();
      return MainScreen();
    }
  }
}
