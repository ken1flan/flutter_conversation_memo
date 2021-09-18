import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_conversation_memo/models/person.dart';
import 'package:flutter_conversation_memo/models/topic.dart';
import 'package:flutter_conversation_memo/widgets/topic_card.dart';

class PersonPage extends StatefulWidget {
  final formKey = GlobalKey<FormState>();
  final Person person;

  PersonPage({this.person});

  @override
  _PersonPageState createState() => _PersonPageState(person);
}

class _PersonPageState extends State<PersonPage> {
  Person person;
  Map<dynamic, Topic> interestedTopics;

  _PersonPageState(person) {
    this.person = person;
    this.person ??= Person('', '', '');

    interestedTopics = Topic.searchByTags(this.person.tags());
  }

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    final titleString = person.key == null
        ? localizations.personPageTitleNew
        : localizations.personPageTitleEdit;
    final indexString = person.key.toString();

    return Scaffold(
        appBar: AppBar(
          title: Text(titleString),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                TextFormField(
                  initialValue: person.name,
                  key: ValueKey('nameTextField$indexString'),
                  decoration: InputDecoration(
                    labelText: localizations.personName,
                  ),
                  onChanged: (value) {
                    setState(() {
                      person.name = value;
                    });
                  },
                ),
                TextFormField(
                  initialValue: person.memo,
                  key: ValueKey('memoTextField$indexString'),
                  decoration: InputDecoration(
                    labelText: localizations.personMemo,
                  ),
                  maxLines: 10,
                  onChanged: (value) {
                    setState(() {
                      person.memo = value;
                    });
                  },
                ),
                TextFormField(
                  initialValue: person.tags_string,
                  key: ValueKey('tagsStringTextField$indexString'),
                  decoration: InputDecoration(
                    labelText: localizations.personTagsString,
                    hintText: localizations.personTagsStringHint,
                  ),
                  onChanged: (value) {
                    setState(() {
                      person.tags_string = value;
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
                          var topic = interestedTopics.values.elementAt(index);
                          return TopicCard(context, topic);
                        });
                  }
                }),
              ],
            )));
  }

  void onFormSubmit() {
    person.save();
    Navigator.of(context).pop();
  }
}
