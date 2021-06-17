import 'package:flutter_test/flutter_test.dart';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:flutter_conversation_memo/topic_page.dart';
import 'package:flutter_conversation_memo/topic.dart';
import '../widget_test_helper.dart';

void main() async {
  await initializeTest();

  testWidgets('Topicが指定されていないとき、新規作成ページが表示されていること',
      (WidgetTester tester) async {
    await initializeExample();
    await tester.pumpWidget(wrapWithMaterial(TopicPage()));

    expect(find.text('話題の新規作成 | 会話ネタ帳', skipOffstage: false), findsOneWidget);

    await finalizeExample();
  });

  testWidgets('Topicが指定されているとき、編集ページが表示されていること', (WidgetTester tester) async {
    await initializeExample();

    var box = Hive.box<Topic>(topicBoxName);
    await box.add(Topic('Summary', 'Memo', '', 1, 1));
    var index = 0;

    await tester.pumpWidget(wrapWithMaterial(TopicPage(index: index)));

    expect(find.text('話題の編集 | 会話ネタ帳', skipOffstage: false), findsOneWidget);

    await finalizeExample();
  });
}
