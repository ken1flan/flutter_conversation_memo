import 'package:flutter_test/flutter_test.dart';
import '../test_helper.dart';

import 'dart:io';
import 'package:flutter_conversation_memo/models/topic.dart';

void main() async {
  setUpAll(() {
    TestHelper.setUpAll();
  });

  tearDown(() {
    TestHelper.tearDown();
  });

  group('.getAt(index)', () {
    group('1件もないとき', () {
      test('存在しないindexを指定したとき、RangeErrorになること', () {
        expect(() => Topic.getAt(999), throwsA(TypeMatcher<RangeError>()));
      });
    });

    group('1件あったとき', () {
      setUpAll(() async {
        await Topic('omoroikoto', 'memo\nmemo', 'tag1 tag2').save();
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
        Topic('omoroikoto', 'memo\nmemo', 'tag1 tag2').save();

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
        Topic('omoroikoto', 'memo\nmemo', 'tag1 tag2').save();
      });

      test('既存のレコードの内容を変更後、再取得したときに更新後のデータを取得できること', () async {
        var topic = Topic.getAt(0);

        topic.summary = 'tanoshikattakoto';
        topic.memo = 'memo\nmemo\nmemo';
        topic.tags_string = 'tag9 tag8';
        topic.image = File('test/fixtures/images/480x320.png');
        await topic.save();

        var updatedTopic = Topic.getAt(0);
        expect(updatedTopic.summary, equals('tanoshikattakoto'));
        expect(updatedTopic.memo, equals('memo\nmemo\nmemo'));
        expect(updatedTopic.tags_string, equals('tag9 tag8'));
        expect(updatedTopic.image.path,
            equals('${updatedTopic.imageDir}/${updatedTopic.image_file_name}'));
        expect(updatedTopic.image.existsSync(), isTrue);
        expect(topic.created_at, isInstanceOf<DateTime>());
        expect(topic.updated_at, isInstanceOf<DateTime>());
        expect(topic.updated_at.microsecondsSinceEpoch,
            greaterThan(topic.created_at.microsecondsSinceEpoch));
      });
    });
  });

  group('.getAll', () {
    group('1件も登録されていないとき', () {
      test('空のリストを返すこと', () {
        expect(Topic.getAll(), isEmpty);
      });
    });

    group('3件登録されているとき', () {
      setUp(() {
        Topic('omoroikoto', 'memo\nmemo', 'tag1 tag2').save();
        Topic('tanoshiikoto', 'memo\nmemo', 'tag3 tag4').save();
        Topic('iketerukoto', 'memo\nmemo', 'tag2 tag9').save();
      });

      test('3件のリストを返すこと', () {
        var summaries = Topic.getAll().map((topic) => topic.summary).toList();
        expect(summaries, contains('tanoshiikoto'));
        expect(summaries, contains('omoroikoto'));
        expect(summaries, contains('iketerukoto'));
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
        Topic('omoroikoto', 'memo\nmemo', 'tag1 tag2').save();
        Topic('tanoshiikoto', 'memo\nmemo', 'tag3 tag4').save();
        Topic('iketerukoto', 'memo\nmemo', 'tag2 tag9').save();
      });

      test('タグに空の配列を指定したとき、空のリストを返すこと', () {
        var tags = <String>[];
        expect(Topic.searchByTags(tags), isEmpty);
      });

      test('存在しないタグを指定したとき、空のリストを返すこと', () {
        var tags = <String>['tagx', 'tagy'];
        expect(Topic.searchByTags(tags), isEmpty);
      });

      test('1件ヒットするタグを指定したとき、1件のリストを返すこと', () {
        var tags = <String>['tag3', 'tagx'];
        var summaries =
            Topic.searchByTags(tags).map((topic) => topic.summary).toList();
        expect(summaries, contains('tanoshiikoto'));
        expect(summaries, isNot(contains('omoroikoto')));
        expect(summaries, isNot(contains('iketerukoto')));
      });

      test('2件ヒットするタグを指定したとき、2件のリストを返すこと', () {
        var tags = <String>['tagx', 'tag2'];
        var summaries =
            Topic.searchByTags(tags).map((topic) => topic.summary).toList();
        expect(summaries, contains('omoroikoto'));
        expect(summaries, contains('iketerukoto'));
        expect(summaries, isNot(contains('tanoshiikoto')));
      });

      test('1件ヒットするタグを2つ指定したとき、2件のリストを返すこと', () {
        var tags = <String>['tag1', 'tagx', 'tag3'];
        var summaries =
            Topic.searchByTags(tags).map((topic) => topic.summary).toList();
        expect(summaries, contains('omoroikoto'));
        expect(summaries, contains('tanoshiikoto'));
        expect(summaries, isNot(contains('iketerukoto')));
      });
    });
  });

  group('#tags', () {
    group('tags_string = nullのとき', () {
      test('空のリストを返すこと', () {
        var topic = Topic('omoroikoto', 'memo\nmemo', null);

        expect(topic.tags(), isEmpty);
      });
    });

    group('tags_string = ""のとき', () {
      test('空のリストを返すこと', () {
        var topic = Topic('omoroikoto', 'memo\nmemo', '');

        print(topic.tags());
        expect(topic.tags(), isEmpty);
      });
    });

    group('tags_string = "tag1"のとき', () {
      test('["tag1"]を返すこと', () {
        var topic = Topic('omoroikoto', 'memo\nmemo', 'tag1');

        print(topic.tags());
        expect(topic.tags(), equals(['tag1']));
      });
    });

    group('tags_string = "tag1 tag2"のとき', () {
      test('["tag1", "tag2]を返すこと', () {
        var topic = Topic('omoroikoto', 'memo\nmemo', 'tag1 tag2');

        print(topic.tags());
        expect(topic.tags(), equals(['tag1', 'tag2']));
      });
    });

    group('tags_string = " tag1  tag2 "のとき', () {
      test('["tag1", "tag2]を返すこと', () {
        var topic = Topic('omoroikoto', 'memo\nmemo', ' tag1  tag2 ');

        print(topic.tags());
        expect(topic.tags(), equals(['tag1', 'tag2']));
      });
    });
  });

  group('#imageDir', () {
    group('保存されていないとき', () {
      var topic = Topic('omoroikoto', 'memo\nmemo', 'tag1 tag2');

      test('NULLを返すこと', () {
        expect(topic.imageDir, isNull);
      });
    });

    group('保存されているとき', () {
      setUp(() async {
        await Topic('omoroikoto', 'memo\nmemo', 'tag1 tag2').save();
      });

      test('NULLを返すこと', () {
        var topic = Topic.getAt(0);
        expect(topic.imageDir.contains('topics/${topic.key}'), isTrue);
      });
    });
  });

  group('#image= / #image', () {
    group('保存されていないとき', () {
      test('保存されていないとき、未保存のファイルを返すこと', () {
        var topic = Topic('omoroikoto', 'memo\nmemo', 'tag1 tag2');
        topic.image = File('test/fixtures/images/480x320.png');

        expect(topic.image.path, equals('test/fixtures/images/480x320.png'));
      });

      test('アプリのドキュメントディレクトリに保存されたファイルを返すこと', () async {
        var topic = Topic('omoroikoto', 'memo\nmemo', 'tag1 tag2');
        topic.image = File('test/fixtures/images/480x320.png');
        await topic.save();

        expect(topic.image.path.contains('topics/${topic.key}/480x320.png'),
            isTrue);
      });
    });

    group('保存されているとき', () {
      setUp(() async {
        var topic = Topic('omoroikoto', 'memo\nmemo', 'tag1 tag2');
        topic.image = File('test/fixtures/images/480x320.png');
        await topic.save();
      });

      test('アプリのドキュメントディレクトリに保存されたファイルを返すこと', () {
        var topic = Topic.getAt(0);

        expect(topic.image.path.contains('topics/${topic.key}/480x320.png'),
            isTrue);
      });

      test('新たにファイルを設定したとき、アプリのドキュメントディレクトリに保存されたファイルを返すこと', () {
        var topic = Topic.getAt(0);
        topic.image = File('test/fixtures/images/480x320.jpg');

        expect(topic.image.path, equals('test/fixtures/images/480x320.jpg'));
      });

      test('新たにファイルを設定して保存したとき、アプリのドキュメントディレクトリに保存されたファイルを返すこと', () async {
        var topic = Topic.getAt(0);
        topic.image = File('test/fixtures/images/480x320.jpg');
        await topic.save();

        expect(topic.image.path.contains('topics/${topic.key}/480x320.jpg'),
            isTrue);
      });
    });
  });
}
