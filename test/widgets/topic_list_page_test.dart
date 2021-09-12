import 'package:flutter_test/flutter_test.dart';

import 'package:flutter/material.dart';
import 'package:flutter_conversation_memo/widgets/topic_list_page.dart';
import 'package:flutter_conversation_memo/models/topic.dart';
import '../supports/hive.dart';
import '../widget_test_helper.dart';

void main() async {
  setUpAll(() async {
    await initializeHive();
  });

  tearDown(() async {
    await tearDownHive();
  });

  group('Topicが0個のとき', () {
    testWidgets('Topicが0個のとき、ひとつもないことが表示されていること', (WidgetTester tester) async {
      await tester.pumpWidget(wrapWithMaterial(TopicListPage()));
      await tester.pumpAndSettle();

      expect(find.text('まだありません。'), findsOneWidget);
    });

    testWidgets('新規作成ボタンを押したとき、新規追加ページが開くこと', (WidgetTester tester) async {
      await tester.pumpWidget(wrapWithMaterial(TopicListPage()));
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      expect(find.text('話題の新規作成', skipOffstage: false), findsOneWidget);
    });
  });

  group('Topicが1個のとき', () {
    setUp(() async {
      await Topic('Summary', 'Memo', '', DateTime.now(), DateTime.now()).save();
    });

    testWidgets('表示されていること', (WidgetTester tester) async {
      await tester.pumpWidget(wrapWithMaterial(TopicListPage()));

      expect(find.text('Summary'), findsOneWidget);
    });

    testWidgets('タップしたとき、編集後、変更が反映されていること', (WidgetTester tester) async {
      await tester.pumpWidget(wrapWithMaterial(TopicListPage()));
      await tester.tap(find.text('Summary'));
      await tester.pumpAndSettle();

      expect(find.text('話題の編集', skipOffstage: false), findsOneWidget);

      var topic = Topic.internalBox.getAt(0);
      await tester.enterText(
          find.byKey(ValueKey('summaryTextField${topic.key.toString()}')),
          'サマリー');
      await tester.tap(find.text('保存'));
      await tester.pumpAndSettle();

      expect(find.text('サマリー'), findsOneWidget);
    });

    testWidgets('Topicを長くタップしたとき、削除ダイアログが表示され、Yesを押したら消えること',
        (WidgetTester tester) async {
      await tester.pumpWidget(wrapWithMaterial(TopicListPage()));
      await tester.longPress(find.text('Summary'));
      await tester.pump();

      await tester.tap(find.text('はい、削除します'));
      await tester.pump();

      expect(find.text('まだありません。'), findsOneWidget);
    });

    testWidgets('Topicを長くタップしたとき、削除ダイアログが表示され、Noを押したら消えること',
        (WidgetTester tester) async {
      await tester.pumpWidget(wrapWithMaterial(TopicListPage()));
      await tester.longPress(find.text('Summary'));
      await tester.pump();

      await tester.tap(find.text('いいえ'));
      await tester.pump();

      expect(find.text('Summary'), findsOneWidget);
    });
  });
}
