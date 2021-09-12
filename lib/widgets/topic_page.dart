import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive/hive.dart';
import 'package:flutter_conversation_memo/main.dart';
import 'package:flutter_conversation_memo/models/topic.dart';
import 'package:flutter_conversation_memo/models/person.dart';
import 'package:flutter_conversation_memo/widgets/person_card.dart';

class TopicPage extends StatefulWidget {
  final formKey = GlobalKey<FormState>();
  final Topic topic;

  TopicPage(this.topic);

  @override
  _TopicPageState createState() => _TopicPageState(topic);
}

class _TopicPageState extends State<TopicPage> {
  Topic topic;
  String summary = '';
  String memo = '';
  String tags_string = '';
  DateTime created_at;
  DateTime updated_at;
  Map<dynamic, Person> interestedPersons;

  _TopicPageState(topic) {
    this.topic = topic;
    summary = topic?.summary;
    memo = topic?.memo;
    tags_string = topic?.tags_string;

    interestedPersons = Person.searchByTags(topic.tags());
  }

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    final titleString = topic.key == null
        ? localizations.topicPageTitleNew
        : localizations.topicPageTitleEdit;
    final indexString = topic.key.toString();

    return Scaffold(
      appBar: AppBar(
        title: Text(titleString),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(children: [
            TextFormField(
              initialValue: summary,
              key: ValueKey('summaryTextField$indexString'),
              decoration: InputDecoration(
                  labelText: localizations.topicSummary,
                  hintText: localizations.topicSummaryHint),
              onChanged: (value) {
                setState(() {
                  summary = value;
                });
              },
            ),
            TextFormField(
              initialValue: memo,
              key: ValueKey('memoTextField$indexString'),
              decoration: InputDecoration(
                  labelText: localizations.topicMemo,
                  hintText: localizations.topicMemoHint),
              maxLines: 10,
              onChanged: (value) {
                setState(() {
                  memo = value;
                });
              },
            ),
            TextFormField(
              initialValue: tags_string,
              key: ValueKey('tagsStringTextField$indexString'),
              decoration: InputDecoration(
                  labelText: localizations.topicTagsString,
                  hintText: localizations.topicTagsStringHint),
              onChanged: (value) {
                setState(() {
                  tags_string = value;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 32, bottom: 32),
              child: ElevatedButton(
                key: Key('saveButton'),
                onPressed: onFormSubmit,
                child: Text(localizations.save),
              ),
            ),
            Text(localizations.topicInterestedPerson),
            Builder(builder: (BuildContext context) {
              if (interestedPersons == null) {
                return Center(child: Text(localizations.notFound));
              } else {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: interestedPersons.length,
                    itemBuilder: (context, index) {
                      var key = interestedPersons.keys.elementAt(index);
                      return PersonCard(context, key, interestedPersons[key]);
                    });
              }
            }),
          ])),
    );
  }

  void onFormSubmit() {
    topic.summary = summary;
    topic.memo = memo;
    topic.tags_string = tags_string;
    topic.updated_at = DateTime.now().toUtc();
    topic.save();

    Navigator.of(context).pop();
  }
}
