import 'package:flutter/material.dart';

class TopicListPage extends StatelessWidget {
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
              'WIP',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _nop,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  void _nop() {}
}
