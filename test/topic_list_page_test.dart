import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_conversation_memo/topic_list_page.dart';
import 'widget_test_helper.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(wrapWithMaterial(TopicListPage()));

    expect(find.text('WIP'), findsOneWidget);
  });
}
