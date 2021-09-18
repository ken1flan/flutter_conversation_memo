import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_conversation_memo/widgets/topic_card.dart';
import 'package:flutter_conversation_memo/widgets/topic_page.dart';
import 'package:flutter_conversation_memo/models/topic.dart';
import 'package:flutter_conversation_memo/widgets/drawer.dart';

class TopicListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(localizations.topicList),
        ),
        drawer: createDrawer(context),
        body: ValueListenableBuilder(
            valueListenable: Topic.internalBox.listenable(),
            builder: (context, _box, _) {
              if (Topic.isEmpty()) {
                return Center(
                  child: Text(localizations.notFound),
                );
              }
              return ListView.builder(
                itemCount: Topic.count(),
                itemBuilder: (context, index) {
                  var currentTopic = Topic.getAt(index);
                  return TopicCard(context, currentTopic);
                },
              );
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _createNewTopic(context);
          },
          tooltip: localizations.topicListAdd,
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
