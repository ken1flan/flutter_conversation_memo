import 'package:flutter/material.dart';
import 'package:flutter_conversation_memo/main.dart';
import 'package:hive/hive.dart';
import 'package:flutter_conversation_memo/models/topic.dart';

class TopicPage extends StatefulWidget {
  final formKey = GlobalKey<FormState>();
  final int index;

  TopicPage({this.index});

  @override
  _TopicPageState createState() => _TopicPageState(index);
}

class _TopicPageState extends State<TopicPage> {
  Box<Topic> box = Hive.box<Topic>(topicBoxName);
  int index;
  String summary = '';
  String memo = '';
  String tags_string = '';
  DateTime created_at;
  DateTime updated_at;

  _TopicPageState(index) {
    this.index = index;
    if (index != null) {
      var topic = box.getAt(index);
      summary = topic?.summary;
      memo = topic?.memo;
      tags_string = topic?.tags_string;
    }
  }

  @override
  Widget build(BuildContext context) {
    final titleString = index == null ? '話題の新規作成 | 会話ネタ帳' : '話題の編集 | 会話ネタ帳';
    final indexString = index.toString();
    final summaryEditingController =
        TextEditingController.fromValue(TextEditingValue(
      text: summary,
      selection: TextSelection.collapsed(offset: summary.length),
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

    return Scaffold(
      appBar: AppBar(
        title: Text(titleString),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(children: [
            Text('summaryTextField$indexString'),
            TextField(
              key: ValueKey('summaryTextField$indexString'),
              controller: summaryEditingController,
              decoration: const InputDecoration(
                  labelText: 'いいたいこと', hintText: 'この話題で言いたいことを短くまとめましょう。'),
              onChanged: (value) {
                setState(() {
                  summary = value;
                });
              },
            ),
            TextField(
              key: ValueKey('memoTextField$indexString'),
              controller: memoEditingController,
              decoration: const InputDecoration(
                  labelText: 'メモ',
                  hintText:
                      '話題を話すときにチラ見したいことを書きましょう。\n長くしすぎるとスクロールが入って見づらくなるかもしれません。'),
              maxLines: 10,
              onChanged: (value) {
                setState(() {
                  memo = value;
                });
              },
            ),
            TextField(
              key: ValueKey('tagsStringTextField$indexString'),
              controller: tagsStringEditingController,
              decoration: const InputDecoration(
                  labelText: 'タグ', hintText: 'スペースで区切って入力してください。'),
              onChanged: (value) {
                setState(() {
                  tags_string = value;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 32),
              child: ElevatedButton(
                key: Key('saveButton'),
                onPressed: onFormSubmit,
                child: Text('保存'),
              ),
            ),
          ])),
    );
  }

  void onFormSubmit() {
    var topicBox = Hive.box<Topic>(topicBoxName);
    if (index == null) {
      topicBox.add(Topic(summary, memo, tags_string, DateTime.now().toUtc(),
          DateTime.now().toUtc()));
    } else {
      var topic = box.getAt(index);
      topic.summary = summary;
      topic.memo = memo;
      topic.tags_string = tags_string;
      topic.updated_at = DateTime.now().toUtc();
      topicBox.putAt(index, topic);
    }
    Navigator.of(context).pop();
  }
}
