import 'package:djigibao_manager/navigation/destination.dart';
import 'package:djigibao_manager/navigation/navigation.dart';
import 'package:djigibao_manager/widgets/main_screen/topics/topics_bloc.dart';
import 'package:flutter/material.dart';

class Topics extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Topics();
}

class _Topics extends State<Topics> {
  final manager = TopicsManager();

  @override
  void initState() {
    manager.getAllTopics();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final navigation = Navigation(context: context);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Row(
        children: [
          Container(
            width: 60,
            child: Row(
              children: [
                Expanded(
                    flex: 50,
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.only(top: 30, left: 2),
                            itemCount: manager.topics.length,
                            itemBuilder: (context, position) {
                              final item = manager.topics[position];
                              return Card(
                                color: Theme.of(context).backgroundColor,
                                child: Container(
                                  height: 50,
                                  child: Stack(
                                    children: [
                                      Center(
                                        child: Text(
                                          item.name,
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: ListView.builder(
                                          padding: EdgeInsets.only(top: 0),
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: item.users.length,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, position) {
                                            final userItem =
                                                item.users[position];
                                            Color color = Colors.grey;
                                            if (item.usersSolved
                                                .contains(userItem))
                                              color = Colors.grey;
                                            else
                                              color = Colors.green;
                                            return Icon(Icons.circle,
                                                color: color, size: 2);
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: FloatingActionButton(
                            onPressed: () {
                              navigation.navigateFromTopics(
                                  destination: TopicsDestination.AddTopic);
                            },
                            backgroundColor: Colors.amber,
                            child: Icon(
                              Icons.add,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    )),
                Flexible(
                  flex: 1,
                  child: VerticalDivider(
                    color: Colors.amber,
                    thickness: 0.1,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Flex(
                direction: Axis.vertical,
                children: [
                  Flexible(
                    flex: 1,
                    child: Center(
                      child: Text("Title"),
                    ),
                  ),
                  Expanded(
                      flex: 50,
                      child: ListView.builder(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                        itemCount: manager.messages.length,
                        itemBuilder: (context, position) {
                          return Text(manager.messages[position].content);
                        },
                      )),
                  Flexible(
                    flex: 5,
                    child: Text("Send message"),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
