import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_conversation_memo/main.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_conversation_memo/widgets/topic_summary.dart';
import 'package:flutter_conversation_memo/widgets/topic_page.dart';
import 'package:flutter_conversation_memo/models/topic.dart';
import 'package:flutter_conversation_memo/widgets/drawer.dart';

class TopicListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(localizations.appTitle),
        ),
        drawer: createDrawer(context),
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
                  var currentTopic = box.getAt(index);
                  return TopicSummary(context, index, currentTopic);
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
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TopicPage(),
        ));
  }
}
