import 'package:collection/collection.dart';
import 'package:djigibao_manager/constants.dart';
import 'package:djigibao_manager/database/entities/message.dart';
import 'package:djigibao_manager/database/entities/topic.dart';
import 'package:djigibao_manager/database/entities/user.dart';
import 'package:djigibao_manager/navigation/destination.dart';
import 'package:djigibao_manager/navigation/navigation.dart';
import 'package:djigibao_manager/widgets/main_screen/topics/topics_bloc.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Topics extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Topics();
}

class _Topics extends State<Topics> {
  final manager = TopicsManager();
  final scrollController = ScrollController();
  var initialized = false;

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() {
    manager.topicsDatabase.database
        .reference()
        .child("topics")
        .onValue
        .listen((event) {
      final result = event.snapshot;
      final parsedResult = (Map<String, dynamic>.from(result.value))
          .values
          .map((value) => Topic.fromJson(Map<String, dynamic>.from(value)))
          .toList(growable: true);
      printTopics(parsedResult);
      if (!initialized) {
        manager.setCurrentTopic(parsedResult
            .firstWhereOrNull((element) => element.name == "global"));
        initialized = true;
      }
      manager.topicStream =
          Stream<List<Topic>>.value(parsedResult).asBroadcastStream();
      refresh();
    });
    manager.stream.listen((currentTopic) {
      manager.topicsDatabase.database
          .reference()
          .child("topics")
          .child(currentTopic?.name ?? "global")
          .child("messages")
          .onValue
          .listen((event) {
        manager.refreshLatest.refresh();
        final result = event.snapshot;
        final parsedResult = (Map<String, dynamic>.from(result.value??{}))
            .values
            .map((value) => Message.fromJson(Map<String, dynamic>.from(value)))
            .toList(growable: true);
        manager.messagesStream =
            Stream<List<Message>>.value(parsedResult.reversed.toList())
                .asBroadcastStream();
        refresh();
      });
    });
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final navigation = Navigation(context: context);

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      resizeToAvoidBottomInset: false,
      body: Flex(
        direction: Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 10,
            child: Row(
              children: [
                Expanded(
                    flex: 50,
                    child: Column(
                      children: [
                        Expanded(
                          child: StreamBuilder<List<Topic>>(
                            stream: manager.topicStream,
                            initialData: [],
                            builder: (context, snapshot) {
                              return ListView.builder(
                                padding: EdgeInsets.only(top: 30, left: 2),
                                itemCount: snapshot.data?.length,
                                itemBuilder: (context, position) {
                                  final item = snapshot.data?[position];
                                  return Card(
                                    color: Theme.of(context).backgroundColor,
                                    child: GestureDetector(
                                      onTap: () {
                                        manager.setCurrentTopic(item);
                                      },
                                      child: Container(
                                          height: 50,
                                          alignment: Alignment.center,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child:
                                                Center(
                                                  child: Text(
                                                    item?.name ?? "",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(fontSize: 10),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                  child: Center(
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  padding:
                                                      EdgeInsets.only(top: 0),
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  itemCount: item?.users?.length,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemBuilder:
                                                      (context, position) {
                                                    final userItem = item
                                                        ?.users?[position].name;
                                                    Color color = Colors.grey;
                                                    if (item?.usersSolved
                                                            ?.map((e) => e.name)
                                                            .contains(
                                                                userItem) ==
                                                        true)
                                                      color = Colors.green;
                                                    else
                                                      color = Colors.grey;
                                                    return Padding(
                                                      padding: EdgeInsets.symmetric(horizontal: 1),
                                                        child: Icon(Icons.circle,
                                                            color: color, size: 5),
                                                    );
                                                  },
                                                ),
                                              ))
                                            ],
                                          )),
                                    ),
                                  );
                                },
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
              flex: 60,
            child: Column(
              children: [
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: EdgeInsets.only(top: 30, bottom: 5),
                    child: (StreamBuilder<Topic?>(
                      stream: manager.stream,
                      initialData: null,
                      builder: (context, snapshot) {
                        return Text(
                          (snapshot.data?.name ?? "").toUpperCase(),
                          style: TextStyle(fontSize: 18, color: Colors.amber),
                        );
                      },
                    )),
                  ),
                ),
                Expanded(
                  flex: 50,
                  child: StreamBuilder<List<Message>>(
                    stream: manager.messagesStream,
                    initialData: [],
                    builder: (context, snapshot) {
                      return ListView.builder(
                        controller: scrollController,
                        reverse: true,
                        scrollDirection: Axis.vertical,
                        padding:
                        EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, position) {
                          final item = snapshot.data?[position];
                          String time = "";
                          final now = DateTime.now();
                          double left = 0;
                          double right = 0;
                          final user = (Hive.box(HIVE_USER).get(
                              HIVE_USER) as User?);
                          if (user?.name == item?.writtenBy.name &&
                              user?.name != null) {
                            left = 70;
                            right = 0;
                          }
                          else {
                            left = 0;
                            right = 70;
                          }
                          if (item?.created.year == now.year &&
                              item?.created.month == now.month &&
                              item?.created.day == now.day)
                            time =
                            "${item?.created.hour}:${item?.created.minute}";
                          else
                            time =
                            "${item?.created.day}.${item?.created.month}.${item
                                ?.created.year}. ${item?.created.hour}:${item?.created.minute}";

                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                            child: Card(
                              margin: EdgeInsets.only(left: left, right: right),
                              color: Theme.of(context).backgroundColor,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 3),
                                    child:  Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          item?.writtenBy.name ?? "",
                                          style: TextStyle(
                                              color: Colors.amber, fontSize: 8),
                                        ),
                                        Text(
                                          time,
                                          style: TextStyle(
                                              color: Colors.amber, fontSize: 8),
                                        )
                                      ],
                                    ),
                                  ),


                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 2, vertical: 3),
                                    child: Text(item?.content??""),
                                  ),



                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                Container(
                  child: MessageBox(
                    messageManager: manager,
                    listScroll: scrollController,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class MessageBox extends StatefulWidget {
  final TopicsManager messageManager;
  final ScrollController listScroll;

  MessageBox({required this.messageManager, required this.listScroll});

  @override
  State<StatefulWidget> createState() =>
      _MessageBox(messageManager: messageManager,
      listScroll: listScroll);
}

class _MessageBox extends State<MessageBox> {
  final TopicsManager messageManager;
  final ScrollController listScroll;

  _MessageBox({required this.messageManager, required this.listScroll});

  final messageController = TextEditingController();
  @override
  void initState() {
    messageManager.refreshLatest.stream.listen((event) {
      if(event)
        listScroll.animateTo(0, duration: Duration(milliseconds: 10), curve: Curves.easeOut);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Colors.white24,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                  child: TextFormField(
                    maxLines: null,
                    controller: messageController,
                    style: TextStyle(
                        color: Colors.white
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
                onChanged: (text) {
                  messageManager.currentMessage = text;
                },
              )),
              IconButton(
                onPressed: () {
                  messageController.text = "";
                  messageManager.addMessage();
                },
                color: Colors.amber,
                icon: Icon(Icons.send),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
