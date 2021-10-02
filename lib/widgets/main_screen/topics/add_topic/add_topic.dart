import 'package:djigibao_manager/database/entities/topic.dart';
import 'package:djigibao_manager/database/entities/topic_type.dart';
import 'package:djigibao_manager/navigation/destination.dart';
import 'package:djigibao_manager/navigation/navigation.dart';
import 'package:djigibao_manager/widgets/main_screen/topics/add_topic/add_topic_bloc.dart';
import 'package:flutter/material.dart';

class AddTopic extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddTopic();
}

class _AddTopic extends State<AddTopic> {
  final nameController = TextEditingController();
  final manager = AddTopicManager();

  @override
  void initState() {
    manager.getUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final navigation = Navigation(context: context);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      floatingActionButton: Visibility(
        visible: manager.name.isNotEmpty,
        child: FloatingActionButton(
          onPressed: () async {
            await manager.saveTopic(Topic(
                name: manager.name,
                type: TopicType.Common,
                users: manager.users,
                usersSolved: List.empty(),
                messages: List.empty()));
            navigation.navigateFromStartTo(MainDestination.Home);
          },
          backgroundColor: Colors.amber,
          child: Icon(Icons.add),
        ),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: TextFormField(
              style: TextStyle(color: Colors.amber),
              controller: nameController,
              onChanged: (text) {
                setState(() {
                  manager.name = text;
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
