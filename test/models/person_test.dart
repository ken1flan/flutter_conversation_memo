import 'package:flutter_test/flutter_test.dart';

import '../supports/hive.dart';
import 'package:flutter_conversation_memo/models/person.dart';

void main() async {
  initializeHive();
  await Person.initialize();

  tearDown(() async {
    await Person.box().clear();
  });

  tearDownAll(() async {
    finalizeHive();
  });

  group('.getAt(index)', () {
    group('1件もないとき', () {
      test('存在しないindexを指定したとき、RangeErrorになること', () {
        expect(() => Person.getAt(999), throwsA(TypeMatcher<RangeError>()));
      });
    });

    group('1件あったとき', () {
      setUpAll(() {
        Person('yamada', 'memo\nmemo', 'tag1 tag2', null, null).save();
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
        Person('yamada', 'memo\nmemo', 'tag1 tag2', null, null).save();

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
        Person('yamada', 'memo\nmemo', 'tag1 tag2', null, null).save();
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
}
