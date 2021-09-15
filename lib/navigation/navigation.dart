import 'destination.dart';
import 'package:djigibao_manager/widgets/login_screen/login_screen.dart';
import 'package:djigibao_manager/widgets/main_screen/main_screen.dart';
import 'package:flutter/material.dart';

class Navigation {
  final BuildContext context;

  Navigation({required this.context});

  void navigateTo(Destination destination) {
    switch (destination) {
      case Destination.Login:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
        break;
      case Destination.Home:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MainScreen()));
        break;
    }
  }
}
