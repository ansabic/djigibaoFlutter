import 'package:djigibao_manager/database/entities/topic_type.dart';
import 'package:djigibao_manager/navigation/destination.dart';
import 'package:djigibao_manager/navigation/navigation.dart';
import 'package:djigibao_manager/widgets/main_screen/topics/topics_bloc.dart';
import 'package:flutter/material.dart';

class Topics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final manager = TopicsManager();
    final navigation = Navigation(context: context);
    manager.getAllTopics();
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            navigation.navigateFromTopics(
                destination: TopicsDestination.AddTopic);
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.amber),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: ListView.builder(
          padding: EdgeInsets.only(top: 0),
          itemCount: manager.topics.length,
          itemBuilder: (context, position) {
            final item = manager.topics[position];
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Card(
                color: Theme.of(context).backgroundColor,
                child: Container(
                  height: 60,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Text(item.name),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Text(topicTypeToValue(item.type)),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(item.users.map((e) => e.name).join(", ")),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
