import 'package:flutter_test/flutter_test.dart';
import '../test_helper.dart';
import '../widget_test_helper.dart';

import 'package:flutter_conversation_memo/widgets/person_page.dart';
import 'package:flutter_conversation_memo/models/person.dart';

void main() async {
  setUpAll(() {
    TestHelper.setUpAll();
  });

  tearDown(() {
    TestHelper.tearDown();
  });

  group('Personが存在しないとき', () {
    testWidgets('Personが指定されていないとき、新規作成ページが表示されていること',
        (WidgetTester tester) async {
      await tester.pumpWidget(wrapWithMaterial(PersonPage()));

      expect(find.text('人の新規作成', skipOffstage: false), findsOneWidget);
    });
  });

  group('Personが存在するとき', () {
    setUp(() {
      Person('Yamada', 'Memo', '').save();
    });

    testWidgets('Personが指定されているとき、編集ページが表示されていること',
        (WidgetTester tester) async {
      var person = Person.getAt(0);

      await tester.pumpWidget(wrapWithMaterial(PersonPage(person: person)));

      expect(find.text('人の編集', skipOffstage: false), findsOneWidget);
    });
  });
}
