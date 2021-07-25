import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_conversation_memo/widgets/person_page.dart';
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

  group('Personが存在しないとき', () {
    testWidgets('Personが指定されていないとき、新規作成ページが表示されていること',
        (WidgetTester tester) async {
      await tester.pumpWidget(wrapWithMaterial(PersonPage()));

      expect(find.text('人の新規作成 | 会話ネタ帳', skipOffstage: false), findsOneWidget);
    });
  });

  group('Personが存在するとき', () {
    setUp(() {
      Person('Yamada', 'Memo', '', null, null).save();
    });

    testWidgets('Personが指定されているとき、編集ページが表示されていること',
        (WidgetTester tester) async {
      var index = 0;

      await tester.pumpWidget(wrapWithMaterial(PersonPage(index: index)));

      expect(find.text('人の編集 | 会話ネタ帳', skipOffstage: false), findsOneWidget);
    });
  });
}
