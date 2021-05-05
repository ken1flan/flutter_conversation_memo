import 'package:flutter/material.dart';

class TopicPage extends StatelessWidget {
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
          ])),
    );
  }
}
