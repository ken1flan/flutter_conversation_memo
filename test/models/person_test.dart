import 'package:flutter_test/flutter_test.dart';

import '../supports/hive.dart';
import 'package:flutter_conversation_memo/models/person.dart';

void main() async {
  setUpAll(() {
    initializeHive();
  });

  tearDown(() async {
    await tearDownHive();
  });

  group('.getAt(index)', () {
    group('1件もないとき', () {
      test('存在しないindexを指定したとき、RangeErrorになること', () {
        expect(() => Person.getAt(999), throwsA(TypeMatcher<RangeError>()));
      });
    });

    group('1件あったとき', () {
      setUpAll(() {
        Person('yamada', 'memo\nmemo', 'tag1 tag2').save();
      });

      test('存在するindexを指定したとき、Personが取得できること', () {
        var person = Person.getAt(0);
        expect(person.name, equals('yamada'));
        expect(person.memo, equals('memo\nmemo'));
        expect(person.tags_string, equals('tag1 tag2'));
      });

      test('存在しないindexを指定したとき、RangeErrorになること', () {
        expect(() => Person.getAt(999), throwsA(TypeMatcher<RangeError>()));
      });
    });
  });

  group('#save()', () {
    group('新規作成', () {
      test('保存した内容が取得できること', () {
        Person('yamada', 'memo\nmemo', 'tag1 tag2').save();

        var person = Person.getAt(0);
        expect(person.name, equals('yamada'));
        expect(person.memo, equals('memo\nmemo'));
        expect(person.tags_string, equals('tag1 tag2'));
        expect(person.created_at, isInstanceOf<DateTime>());
        expect(person.updated_at, isInstanceOf<DateTime>());
        expect(person.updated_at, equals(person.created_at));
      });
    });

    group('更新', () {
      setUpAll(() {
        Person('yamada', 'memo\nmemo', 'tag1 tag2').save();
      });

      test('既存のレコードの内容を変更後、再取得したときに更新後のデータを取得できること', () {
        var person = Person.getAt(0);

        person.name = 'sato';
        person.memo = 'memo\nmemo\nmemo';
        person.tags_string = 'tag9 tag8';
        person.save();

        var updatedPerson = Person.getAt(0);
        expect(updatedPerson.name, equals('sato'));
        expect(updatedPerson.memo, equals('memo\nmemo\nmemo'));
        expect(updatedPerson.tags_string, equals('tag9 tag8'));
        expect(person.created_at, isInstanceOf<DateTime>());
        expect(person.updated_at, isInstanceOf<DateTime>());
        expect(person.updated_at.microsecondsSinceEpoch,
            greaterThan(person.created_at.microsecondsSinceEpoch));
      });
    });
  });

  group('.searchByTags', () {
    group('1件も登録されていないとき', () {
      test('空のリストを返すこと', () {
        var tags = ['tag'];
        expect(Person.searchByTags(tags), isEmpty);
      });
    });

    group('3件登録されているとき', () {
      setUp(() {
        Person('yamada', 'memo\nmemo', 'tag1 tag2').save();
        Person('sato', 'memo\nmemo', 'tag3 tag4').save();
        Person('tanaka', 'memo\nmemo', 'tag2 tag9').save();
      });

      test('タグに空の配列を指定したとき、空のリストを返すこと', () {
        var tags = <String>[];
        // expect(Person.searchByTags(tags), equals(Person.box().toMap()));
        expect(Person.searchByTags(tags), isEmpty);
      });

      test('存在しないタグを指定したとき、空のリストを返すこと', () {
        var tags = <String>['tagx', 'tagy'];
        expect(Person.searchByTags(tags), isEmpty);
      });

      test('1件ヒットするタグを指定したとき、1件のリストを返すこと', () {
        var tags = <String>['tag3', 'tagx'];
        var names = Person.searchByTags(tags)
            .values
            .map((person) => person.name)
            .toList();
        expect(names, contains('sato'));
        expect(names, isNot(contains('yamada')));
        expect(names, isNot(contains('tanaka')));
      });

      test('2件ヒットするタグを指定したとき、2件のリストを返すこと', () {
        var tags = <String>['tagx', 'tag2'];
        var names = Person.searchByTags(tags)
            .values
            .map((person) => person.name)
            .toList();
        expect(names, contains('yamada'));
        expect(names, contains('tanaka'));
        expect(names, isNot(contains('sato')));
      });

      test('1件ヒットするタグを2つ指定したとき、2件のリストを返すこと', () {
        var tags = <String>['tag1', 'tagx', 'tag3'];
        var names = Person.searchByTags(tags)
            .values
            .map((person) => person.name)
            .toList();
        expect(names, contains('yamada'));
        expect(names, contains('sato'));
        expect(names, isNot(contains('tanaka')));
      });
    });
  });

  group('#tags', () {
    group('tags_string = nullのとき', () {
      test('空のリストを返すこと', () {
        var person = Person('yamada', 'memo\nmemo', null);

        expect(person.tags(), isEmpty);
      });
    });

    group('tags_string = ""のとき', () {
      test('空のリストを返すこと', () {
        var person = Person('yamada', 'memo\nmemo', '');

        print(person.tags());
        expect(person.tags(), isEmpty);
      });
    });

    group('tags_string = "tag1"のとき', () {
      test('["tag1"]を返すこと', () {
        var person = Person('yamada', 'memo\nmemo', 'tag1');

        print(person.tags());
        expect(person.tags(), equals(['tag1']));
      });
    });

    group('tags_string = "tag1 tag2"のとき', () {
      test('["tag1", "tag2]を返すこと', () {
        var person = Person('yamada', 'memo\nmemo', 'tag1 tag2');

        print(person.tags());
        expect(person.tags(), equals(['tag1', 'tag2']));
      });
    });

    group('tags_string = " tag1  tag2 "のとき', () {
      test('["tag1", "tag2]を返すこと', () {
        var person = Person('yamada', 'memo\nmemo', ' tag1  tag2 ');

        print(person.tags());
        expect(person.tags(), equals(['tag1', 'tag2']));
      });
    });
  });
}
