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
      var person = Person(null, null, null, null, null);
      await tester.pumpWidget(wrapWithMaterial(PersonPage(person)));

      expect(find.text('人の新規作成', skipOffstage: false), findsOneWidget);
    });
  });

  group('Personが存在するとき', () {
    setUp(() {
      Person('Yamada', 'Memo', '', null, null).save();
    });

    testWidgets('Personが指定されているとき、編集ページが表示されていること',
        (WidgetTester tester) async {
      var person = Person.internalBox.getAt(0);

      await tester.pumpWidget(wrapWithMaterial(PersonPage(person)));

      expect(find.text('人の編集', skipOffstage: false), findsOneWidget);
    });
  });
}
