import 'package:flutter_test/flutter_test.dart';
import '../test_helper.dart';
import '../widget_test_helper.dart';

import 'package:flutter/material.dart';
import 'package:flutter_conversation_memo/widgets/person_list_page.dart';
import 'package:flutter_conversation_memo/models/person.dart';

void main() async {
  setUpAll(() {
    TestHelper.setUpAll();
  });

  tearDown(() {
    TestHelper.tearDown();
  });

  group('Personが0個のとき', () {
    testWidgets('ひとつもないことが表示されていること', (WidgetTester tester) async {
      await tester.pumpWidget(wrapWithMaterial(PersonListPage()));

      expect(find.text('まだありません。'), findsOneWidget);
    });

    testWidgets('新規作成ボタンを押したとき、新規追加ページが開くこと', (WidgetTester tester) async {
      await tester.pumpWidget(wrapWithMaterial(PersonListPage()));
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      expect(find.text('人の新規作成', skipOffstage: false), findsOneWidget);
    });
  });

  group('Personが1個のとき', () {
    setUp(() {
      Person('Yamada', 'memo\nmemo', '', null, null).save();
    });

    testWidgets('Topicが1個のとき、表示されていること', (WidgetTester tester) async {
      await tester.pumpWidget(wrapWithMaterial(PersonListPage()));

      expect(find.text('Yamada'), findsOneWidget);
    });

    testWidgets('タップしたとき、編集後、変更が反映されていること', (WidgetTester tester) async {
      await tester.pumpWidget(wrapWithMaterial(PersonListPage()));
      await tester.tap(find.text('Yamada'));
      await tester.pumpAndSettle();

      expect(find.text('人の編集', skipOffstage: false), findsOneWidget);

      final index = 0;
      await tester.enterText(
          find.byKey(ValueKey('nameTextField${index.toString()}')), '山田');
      await tester.tap(find.text('保存'));
      await tester.pumpAndSettle();

      expect(find.text('山田'), findsOneWidget);
    });

    testWidgets('新規作成ボタンを押したとき、新規追加ページが開くこと', (WidgetTester tester) async {
      await tester.pumpWidget(wrapWithMaterial(PersonListPage()));
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      expect(find.text('人の新規作成', skipOffstage: false), findsOneWidget);
    });

    testWidgets('Personを長くタップしたとき、削除ダイアログが表示され、Yesを押したら消えること',
        (WidgetTester tester) async {
      await tester.pumpWidget(wrapWithMaterial(PersonListPage()));
      await tester.longPress(find.text('Yamada'));
      await tester.pump();

      await tester.tap(find.text('はい、削除します'));
      await tester.pump();

      expect(find.text('まだありません。'), findsOneWidget);
    });

    testWidgets('Personを長くタップしたとき、削除ダイアログが表示され、Noを押したら消えること',
        (WidgetTester tester) async {
      await tester.pumpWidget(wrapWithMaterial(PersonListPage()));
      await tester.longPress(find.text('Yamada'));
      await tester.pump();

      await tester.tap(find.text('いいえ'));
      await tester.pump();

      expect(find.text('Yamada'), findsOneWidget);
    });
  });
}
