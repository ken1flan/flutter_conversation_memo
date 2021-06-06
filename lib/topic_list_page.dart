import 'package:flutter/material.dart';
import 'package:flutter_conversation_memo/main.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_conversation_memo/topic_page.dart';
import 'package:flutter_conversation_memo/topic.dart';

class TopicListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('会話ネタ帳'),
        ),
        body: ValueListenableBuilder(
            valueListenable: Hive.box<Topic>(topicBoxName).listenable(),
            builder: (context, Box<Topic> box, _) {
              if (box.values.isEmpty) {
                return Center(
                  child: Text('まだありません。'),
                );
              }
              return ListView.builder(
                itemCount: box.values.length,
                itemBuilder: (context, index) {
                  Topic currentTopic = box.getAt(index);
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 5),
                            Text(currentTopic.summary),
                          ]),
                    ),
                  );
                },
              );
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _createNewTopic(context);
          },
          tooltip: 'Add new topic',
          child: Icon(Icons.add),
        ));
  }

  void _createNewTopic(BuildContext context) {
    // nop
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TopicPage(),
        ));
  }
}
