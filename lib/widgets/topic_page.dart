import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_conversation_memo/models/topic.dart';
import 'package:flutter_conversation_memo/models/person.dart';
import 'package:flutter_conversation_memo/widgets/person_card.dart';

class TopicPage extends StatefulWidget {
  final formKey = GlobalKey<FormState>();
  final Topic topic;

  TopicPage({this.topic});

  @override
  _TopicPageState createState() => _TopicPageState(topic);
}

class _TopicPageState extends State<TopicPage> {
  Topic topic;
  List<Person> interestedPersons;
  final picker = ImagePicker();

  _TopicPageState(topic) {
    this.topic = topic;
    this.topic ??= Topic('', '', '');

    interestedPersons = Person.searchByTags(this.topic.tags());
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
              initialValue: topic.summary,
              key: ValueKey('summaryTextField$indexString'),
              decoration: InputDecoration(
                  labelText: localizations.topicSummary,
                  hintText: localizations.topicSummaryHint),
              onChanged: (value) {
                setState(() {
                  topic.summary = value;
                });
              },
            ),
            TextFormField(
              initialValue: topic.memo,
              key: ValueKey('memoTextField$indexString'),
              decoration: InputDecoration(
                  labelText: localizations.topicMemo,
                  hintText: localizations.topicMemoHint),
              maxLines: 10,
              onChanged: (value) {
                setState(() {
                  topic.memo = value;
                });
              },
            ),
            TextFormField(
              initialValue: topic.tags_string,
              key: ValueKey('tagsStringTextField$indexString'),
              decoration: InputDecoration(
                  labelText: localizations.topicTagsString,
                  hintText: localizations.topicTagsStringHint),
              onChanged: (value) {
                setState(() {
                  topic.tags_string = value;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 32, bottom: 0),
              child: Container(
                width: 300,
                child: topic.image == null
                    ? Text(localizations.noImageSelected)
                    : Image.file(topic.image),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0, bottom: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OutlinedButton(
                      onPressed: getImageFromCamera,
                      style: OutlinedButton.styleFrom(shape: StadiumBorder()),
                      child: Icon(Icons.add_a_photo)),
                  OutlinedButton(
                      onPressed: getImageFromGallery,
                      style: OutlinedButton.styleFrom(shape: StadiumBorder()),
                      child: Icon(Icons.photo_library)),
                ],
              ),
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
                      var person = interestedPersons[index];
                      return PersonCard(context, person);
                    });
              }
            }),
          ])),
    );
  }

  void onFormSubmit() {
    topic.save();
    Navigator.of(context).pop();
  }

  void getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      topic.image = File(pickedFile.path);
    });
  }

  void getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      topic.image = File(pickedFile.path);
    });
  }
}
