import 'package:flutter_test/flutter_test.dart';

import 'package:flutter/material.dart';
import 'package:flutter_conversation_memo/topic_list_page.dart';
import 'widget_test_helper.dart';

void main() {
  testWidgets('ネタ一覧が表示されること', (WidgetTester tester) async {
    await tester.pumpWidget(wrapWithMaterial(TopicListPage()));

    expect(find.text('WIP'), findsOneWidget);
  });

  testWidgets('新規作成ボタンを押したとき、ネタ新規追加ページが開くこと', (WidgetTester tester) async {
    await tester.pumpWidget(wrapWithMaterial(TopicListPage()));

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('話題の新規作成 | 会話ネタ帳', skipOffstage: false), findsOneWidget);
  });
}
