import 'package:flutter/material.dart';

class TopicPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('会話ネタ帳'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'ネタ新規追加',
            ),
          ],
        ),
      ),
    );
  }
}
