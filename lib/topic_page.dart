import 'package:flutter/material.dart';
import 'package:flutter_conversation_memo/main.dart';
import 'package:hive/hive.dart';
import 'package:flutter_conversation_memo/topic.dart';

class TopicPage extends StatefulWidget {
  final formKey = GlobalKey<FormState>();

  @override
  _TopicPageState createState() => _TopicPageState();
}

class _TopicPageState extends State<TopicPage> {
  String summary;
  String memo;
  String tags_string;
  int created_at;
  int updated_at;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('話題の新規作成 | 会話ネタ帳'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(children: [
            TextField(
              decoration: const InputDecoration(
                  labelText: 'いいたいこと', hintText: 'この話題で言いたいことを短くまとめましょう。'),
            ),
            TextField(
              decoration: const InputDecoration(
                  labelText: 'メモ',
                  hintText:
                      '話題を話すときにチラ見したいことを書きましょう。\n長くしすぎるとスクロールが入って見づらくなるかもしれません。'),
              maxLines: 10,
            ),
            TextField(
              decoration: const InputDecoration(
                  labelText: 'タグ', hintText: 'スペースで区切って入力してください。'),
            ),
            OutlinedButton(
              onPressed: onFormSubmit,
              child: Text('保存'),
            ),
          ])),
    );
  }

  void onFormSubmit() {
    Box<Topic> topicBox = Hive.box<Topic>(topicBoxName);
    topicBox.add(Topic(summary, memo, tags_string, created_at, updated_at));
    Navigator.of(context).pop();
  }
}
