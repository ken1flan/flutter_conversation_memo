import 'package:flutter_test/flutter_test.dart';

import 'package:flutter/material.dart';
import 'package:flutter_conversation_memo/widgets/person_list_page.dart';
import 'package:flutter_conversation_memo/models/person.dart';
import '../supports/hive.dart';
import '../widget_test_helper.dart';

void main() async {
  setUpAll(() async {
    await initializeHive();
  });

  tearDown(() async {
    await tearDownHive();
  });

  group('Personが0個のとき', () {
    testWidgets('ひとつもないことが表示されていること', (WidgetTester tester) async {
      await tester.pumpWidget(wrapWithMaterial(PersonListPage()));

      expect(find.text('まだありません。'), findsOneWidget);
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

    testWidgets('Topicを長くタップしたとき、削除ダイアログが表示され、Noを押したら消えること',
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
