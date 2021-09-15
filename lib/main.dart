import 'package:djigibao_manager/database/hiveDatabase.dart';
import 'package:djigibao_manager/firebase/base.dart';
import 'package:djigibao_manager/firebase/firestore/base.dart';
import 'package:djigibao_manager/widgets/login_screen/login_screen.dart';
import 'package:djigibao_manager/widgets/main_screen/main_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  final firebase = FirebaseBase();
  await firebase.initFirebase();
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
            backgroundColor: Colors.blueAccent,
            primarySwatch: Colors.blue,
            hintColor: Colors.white30,
            textTheme: TextTheme(bodyText1: TextStyle(), bodyText2: TextStyle())
                .apply(
                    bodyColor: Colors.white, displayColor: Colors.blueAccent)),
        home: FirstSwitchScreen(username: username));
  }
}

class FirstSwitchScreen extends StatelessWidget {
  final String username;

  FirstSwitchScreen({required this.username});

  @override
  Widget build(BuildContext context) {
    if (username == "")
      return LoginScreen();
    else
      return MainScreen();
  }
}
