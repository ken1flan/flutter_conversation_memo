import 'package:flutter_test/flutter_test.dart';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:flutter_conversation_memo/topic_list_page.dart';
import 'package:flutter_conversation_memo/topic.dart';
import '../widget_test_helper.dart';

void main() async {
  await initializeTest();
  testWidgets('Topicが0個のとき、ひとつもないことが表示されていること', (WidgetTester tester) async {
    await initializeExample();
    await tester.pumpWidget(wrapWithMaterial(TopicListPage()));

    expect(find.text('まだありません。'), findsOneWidget);

    await finalizeExample();
  });

  testWidgets('Topicが1個のとき、表示されていること', (WidgetTester tester) async {
    await initializeExample();

    var box = Hive.box<Topic>(topicBoxName);
    await box.add(Topic('Summary', 'Memo', '', 1, 1));

    await tester.pumpWidget(wrapWithMaterial(TopicListPage()));

    expect(find.text('Summary'), findsOneWidget);

    await finalizeExample();
  });

  testWidgets('新規作成ボタンを押したとき、新規追加ページが開くこと', (WidgetTester tester) async {
    await initializeExample();
    await tester.pumpWidget(wrapWithMaterial(TopicListPage()));
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('話題の新規作成 | 会話ネタ帳', skipOffstage: false), findsOneWidget);

    await finalizeExample();
  });

  testWidgets('Topicをタップしたとき、編集後、変更が反映されていること', (WidgetTester tester) async {
    await initializeExample();

    var box = Hive.box<Topic>(topicBoxName);
    await box.add(Topic('Summary', 'Memo', '', 1, 1));
    final index = 0;

    await tester.pumpWidget(wrapWithMaterial(TopicListPage()));
    await tester.tap(find.text('Summary'));
    await tester.pumpAndSettle();

    expect(find.text('話題の編集 | 会話ネタ帳', skipOffstage: false), findsOneWidget);

    await tester.enterText(
        find.byKey(ValueKey('summaryTextField${index.toString()}')), 'サマリー');
    await tester.tap(find.text('保存'));
    await tester.pumpAndSettle();

    expect(find.text('サマリー'), findsOneWidget);

    await finalizeExample();
  });

  testWidgets('Topicを長くタップしたとき、削除ダイアログが表示され、Yesを押したら消えること',
      (WidgetTester tester) async {
    await initializeExample();

    var box = Hive.box<Topic>(topicBoxName);
    await box.add(Topic('Summary', 'Memo', '', 1, 1));

    await tester.pumpWidget(wrapWithMaterial(TopicListPage()));
    await tester.longPress(find.text('Summary'));
    await tester.pump();

    await tester.tap(find.text('Yes'));
    await tester.pump();

    expect(find.text('まだありません。'), findsOneWidget);

    await finalizeExample();
  });

  testWidgets('Topicを長くタップしたとき、削除ダイアログが表示され、Noを押したら消えること',
      (WidgetTester tester) async {
    await initializeExample();

    var box = Hive.box<Topic>(topicBoxName);
    await box.add(Topic('Summary', 'Memo', '', 1, 1));

    await tester.pumpWidget(wrapWithMaterial(TopicListPage()));
    await tester.longPress(find.text('Summary'));
    await tester.pump();

    await tester.tap(find.text('No'));
    await tester.pump();

    expect(find.text('Summary'), findsOneWidget);

    await finalizeExample();
  });
}
