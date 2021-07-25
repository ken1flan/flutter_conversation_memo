import 'package:flutter_test/flutter_test.dart';

import '../supports/hive.dart';
import 'package:flutter_conversation_memo/models/topic.dart';

void main() async {
  initializeHive();
  await Topic.initialize(memory_box: true);

  tearDown(() async {
    await Topic.box().clear();
  });

  group('.getAt(index)', () {
    group('1件もないとき', () {
      test('存在しないindexを指定したとき、RangeErrorになること', () {
        expect(() => Topic.getAt(999), throwsA(TypeMatcher<RangeError>()));
      });
    });

    group('1件あったとき', () {
      setUpAll(() {
        Topic('omoroikoto', 'memo\nmemo', 'tag1 tag2', null, null).save();
      });

      test('存在するindexを指定したとき、Topicが取得できること', () {
        var topic = Topic.getAt(0);
        expect(topic.summary, equals('omoroikoto'));
        expect(topic.memo, equals('memo\nmemo'));
        expect(topic.tags_string, equals('tag1 tag2'));
      });

      test('存在しないindexを指定したとき、RangeErrorになること', () {
        expect(() => Topic.getAt(999), throwsA(TypeMatcher<RangeError>()));
      });
    });
  });

  group('#save()', () {
    group('新規作成', () {
      test('保存した内容が取得できること', () {
        Topic('omoroikoto', 'memo\nmemo', 'tag1 tag2', null, null).save();

        var topic = Topic.getAt(0);
        expect(topic.summary, equals('omoroikoto'));
        expect(topic.memo, equals('memo\nmemo'));
        expect(topic.tags_string, equals('tag1 tag2'));
        expect(topic.created_at, isInstanceOf<DateTime>());
        expect(topic.updated_at, isInstanceOf<DateTime>());
        expect(topic.updated_at, equals(topic.created_at));
      });
    });

    group('更新', () {
      setUpAll(() {
        Topic('omoroikoto', 'memo\nmemo', 'tag1 tag2', null, null).save();
      });

      test('既存のレコードの内容を変更後、再取得したときに更新後のデータを取得できること', () {
        var topic = Topic.getAt(0);

        topic.summary = 'tanoshikattakoto';
        topic.memo = 'memo\nmemo\nmemo';
        topic.tags_string = 'tag9 tag8';
        topic.save();

        var updatedTopic = Topic.getAt(0);
        expect(updatedTopic.summary, equals('tanoshikattakoto'));
        expect(updatedTopic.memo, equals('memo\nmemo\nmemo'));
        expect(updatedTopic.tags_string, equals('tag9 tag8'));
        expect(topic.created_at, isInstanceOf<DateTime>());
        expect(topic.updated_at, isInstanceOf<DateTime>());
        expect(topic.updated_at.microsecondsSinceEpoch,
            greaterThan(topic.created_at.microsecondsSinceEpoch));
      });
    });
  });

  group('.searchByTags', () {
    group('1件も登録されていないとき', () {
      test('空のリストを返すこと', () {
        var tags = ['tag'];
        expect(Topic.searchByTags(tags), isEmpty);
      });
    });

    group('3件登録されているとき', () {
      setUp(() {
        Topic('omoroikoto', 'memo\nmemo', 'tag1 tag2', null, null).save();
        Topic('tanoshiikoto', 'memo\nmemo', 'tag3 tag4', null, null).save();
        Topic('iketerukoto', 'memo\nmemo', 'tag2 tag9', null, null).save();
      });

      test('タグに空の配列を指定したとき、空のリストを返すこと', () {
        var tags = <String>[];
        // expect(Topic.searchByTags(tags), equals(Topic.box().toMap()));
        expect(Topic.searchByTags(tags), isEmpty);
      });

      test('存在しないタグを指定したとき、空のリストを返すこと', () {
        var tags = <String>['tagx', 'tagy'];
        expect(Topic.searchByTags(tags), isEmpty);
      });

      test('1件ヒットするタグを指定したとき、1件のリストを返すこと', () {
        var tags = <String>['tag3', 'tagx'];
        var summaries = Topic.searchByTags(tags)
            .values
            .map((topic) => topic.summary)
            .toList();
        expect(summaries, contains('tanoshiikoto'));
        expect(summaries, isNot(contains('omoroikoto')));
        expect(summaries, isNot(contains('iketerukoto')));
      });

      test('2件ヒットするタグを指定したとき、2件のリストを返すこと', () {
        var tags = <String>['tagx', 'tag2'];
        var summaries = Topic.searchByTags(tags)
            .values
            .map((topic) => topic.summary)
            .toList();
        expect(summaries, contains('omoroikoto'));
        expect(summaries, contains('iketerukoto'));
        expect(summaries, isNot(contains('tanoshiikoto')));
      });

      test('1件ヒットするタグを2つ指定したとき、2件のリストを返すこと', () {
        var tags = <String>['tag1', 'tagx', 'tag3'];
        var summaries = Topic.searchByTags(tags)
            .values
            .map((topic) => topic.summary)
            .toList();
        expect(summaries, contains('omoroikoto'));
        expect(summaries, contains('tanoshiikoto'));
        expect(summaries, isNot(contains('iketerukoto')));
      });
    });
  });

  group('#tags', () {
    group('tags_string = nullのとき', () {
      test('空のリストを返すこと', () {
        var topic = Topic('omoroikoto', 'memo\nmemo', null, null, null);

        expect(topic.tags(), isEmpty);
      });
    });

    group('tags_string = ""のとき', () {
      test('空のリストを返すこと', () {
        var topic = Topic('omoroikoto', 'memo\nmemo', '', null, null);

        print(topic.tags());
        expect(topic.tags(), isEmpty);
      });
    });

    group('tags_string = "tag1"のとき', () {
      test('["tag1"]を返すこと', () {
        var topic = Topic('omoroikoto', 'memo\nmemo', 'tag1', null, null);

        print(topic.tags());
        expect(topic.tags(), equals(['tag1']));
      });
    });

    group('tags_string = "tag1 tag2"のとき', () {
      test('["tag1", "tag2]を返すこと', () {
        var topic = Topic('omoroikoto', 'memo\nmemo', 'tag1 tag2', null, null);

        print(topic.tags());
        expect(topic.tags(), equals(['tag1', 'tag2']));
      });
    });

    group('tags_string = " tag1  tag2 "のとき', () {
      test('["tag1", "tag2]を返すこと', () {
        var topic =
            Topic('omoroikoto', 'memo\nmemo', ' tag1  tag2 ', null, null);

        print(topic.tags());
        expect(topic.tags(), equals(['tag1', 'tag2']));
      });
    });
  });
}
