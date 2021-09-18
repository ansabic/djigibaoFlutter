import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 60, vertical: 100),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    //TODO on pressed
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.deepPurple)),
                  child: Text(
                    "Songs",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    //TODO on pressed
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.deepPurple)),
                  child: Text(
                    "Events",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    //TODO on pressed
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.deepPurple)),
                  child: Text(
                    "Settings",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
