import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_conversation_memo/models/person.dart';
import 'package:flutter_conversation_memo/models/topic.dart';
import 'package:flutter_conversation_memo/widgets/topic_card.dart';

class PersonPage extends StatefulWidget {
  final formKey = GlobalKey<FormState>();
  final int index;

  PersonPage({this.index});

  @override
  _PersonPageState createState() => _PersonPageState(index);
}

class _PersonPageState extends State<PersonPage> {
  int index;
  Person person;
  String name = '';
  String memo = '';
  String tags_string = '';
  DateTime created_at;
  DateTime updated_at;
  Map<dynamic, Topic> interestedTopics;

  _PersonPageState(index) {
    this.index = index;
    if (index != null) {
      person = Person.getAt(index);
      name = person?.name;
      memo = person?.memo;
      tags_string = person?.tags_string;

      interestedTopics = Topic.searchByTags(person.tags());
    }
  }

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    final titleString = index == null
        ? localizations.personPageTitleNew
        : localizations.personPageTitleEdit;

    return Scaffold(
        appBar: AppBar(
          title: Text(titleString),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                TextFormField(
                  initialValue: name,
                  decoration: InputDecoration(
                    labelText: localizations.personName,
                  ),
                  onChanged: (value) {
                    setState(() {
                      name = value;
                    });
                  },
                ),
                TextFormField(
                  initialValue: memo,
                  decoration: InputDecoration(
                    labelText: localizations.personMemo,
                  ),
                  maxLines: 10,
                  onChanged: (value) {
                    setState(() {
                      memo = value;
                    });
                  },
                ),
                TextFormField(
                  initialValue: tags_string,
                  decoration: InputDecoration(
                    labelText: localizations.personTagsString,
                    hintText: localizations.personTagsStringHint,
                  ),
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
                Text(localizations.personInterestingTopic),
                Builder(builder: (BuildContext context) {
                  if (interestedTopics == null) {
                    return Center(child: Text(localizations.notFound));
                  } else {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: interestedTopics.length,
                        itemBuilder: (context, index) {
                          var key = interestedTopics.keys.elementAt(index);
                          return TopicCard(context, key, interestedTopics[key]);
                        });
                  }
                }),
              ],
            )));
  }

  void onFormSubmit() {
    var person;
    if (index == null) {
      person = Person(name, memo, tags_string, created_at, updated_at);
    } else {
      person = Person.getAt(index);
      person.name = name;
      person.memo = memo;
      person.tags_string = tags_string;
    }
    person.save();
    Navigator.of(context).pop();
  }
}
