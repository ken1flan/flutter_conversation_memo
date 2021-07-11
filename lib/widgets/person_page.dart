import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
  String name = '';
  String memo = '';
  String tags_string = '';
  DateTime created_at;
  DateTime updated_at;

  _PersonPageState(index) {
    this.index = index;
    if (index != null) {
      var person = Person.getAt(index);
      name = person?.name;
      memo = person?.memo;
      tags_string = person?.tags_string;
    }
  }

  @override
  Widget build(BuildContext context) {
    final titleString = '人の新規作成 | 会話ネタ帳';
    final nameEditingController =
        TextEditingController.fromValue(TextEditingValue(
      text: name,
      selection: TextSelection.collapsed(offset: name.length),
    ));
    final memoEditingController =
        TextEditingController.fromValue(TextEditingValue(
      text: memo,
      selection: TextSelection.collapsed(offset: memo.length),
    ));
    final tagsStringEditingController =
        TextEditingController.fromValue(TextEditingValue(
      text: tags_string,
      selection: TextSelection.collapsed(offset: tags_string.length),
    ));
    final interestedTopics = Topic.box().toMap();

    return Scaffold(
        appBar: AppBar(
          title: Text(titleString),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                TextField(
                  controller: nameEditingController,
                  decoration: const InputDecoration(
                    labelText: '名前',
                  ),
                  onChanged: (value) {
                    setState(() {
                      name = value;
                    });
                  },
                ),
                TextField(
                  controller: memoEditingController,
                  decoration: const InputDecoration(
                    labelText: 'メモ',
                  ),
                  maxLines: 10,
                  onChanged: (value) {
                    setState(() {
                      memo = value;
                    });
                  },
                ),
                TextField(
                  controller: tagsStringEditingController,
                  decoration: const InputDecoration(
                    labelText: 'タグ',
                    hintText: 'スペースで区切って入力してください。',
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
                    child: Text('保存'),
                  ),
                ),
                Text('興味のありそうな話題'),
                ValueListenableBuilder(
                  valueListenable: Topic.box().listenable(),
                  builder: (context, Box<Topic> box, _) {
                    //if (box.values.isEmpty) {
                    return Center(
                      child: Text('まだありません。'),
                    );
                    //}
                    //
                  },
                ),
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
