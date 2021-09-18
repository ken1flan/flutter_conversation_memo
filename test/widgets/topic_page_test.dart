import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_conversation_memo/widgets/topic_page.dart';
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

  group('Topicが存在しないとき', () {
    testWidgets('Topicが指定されていないとき、新規作成ページが表示されていること',
        (WidgetTester tester) async {
      await tester.pumpWidget(wrapWithMaterial(TopicPage()));

      expect(find.text('話題の新規作成', skipOffstage: false), findsOneWidget);
    });
  });

  group('Topicが存在するとき', () {
    testWidgets('Topicが指定されているとき、編集ページが表示されていること', (WidgetTester tester) async {
      await Topic('Summary', 'Memo', '').save();
      var topic = Topic.getAt(0);

      await tester.pumpWidget(wrapWithMaterial(TopicPage(topic: topic)));

      expect(find.text('話題の編集', skipOffstage: false), findsOneWidget);
    });
  });
}
