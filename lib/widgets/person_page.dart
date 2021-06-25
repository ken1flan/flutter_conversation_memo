import 'package:flutter/material.dart';

class PersonPage extends StatefulWidget {
  @override
  _PersonPageState createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('人'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: '名前',
                  ),
                ),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'メモ',
                  ),
                  maxLines: 10,
                ),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'タグ',
                    hintText: 'スペースで区切って入力してください。',
                  ),
                ),
              ],
            )));
  }
}
