import 'dart:typed_data';
import 'package:hive/hive.dart';

part 'person.g.dart';

const int PersonTypeId = 1;

@HiveType(typeId: PersonTypeId)
class Person extends HiveObject {
  static const boxName = 'personBox';
  static const String TAG_SEPARATOR = ' ';

  static Box<Person> internalBox;
  int index;

  @HiveField(0)
  String name;
  @HiveField(1)
  String memo;
  @HiveField(2)
  String tags_string;
  @HiveField(3)
  DateTime created_at;
  @HiveField(4)
  DateTime updated_at;

  Person(this.name, this.memo, this.tags_string,
      [this.created_at, this.updated_at]);

  static Future<void> initialize({memory_box = false}) async {
    Hive.registerAdapter(PersonAdapter());
    var bytes = memory_box ? Uint8List(0) : null;
    internalBox = await Hive.openBox<Person>(boxName, bytes: bytes);
  }

  static bool isEmpty() {
    return internalBox.isEmpty;
  }

  static int count() {
    return internalBox.values.length;
  }

  static Person getAt(int index) {
    var person = internalBox.getAt(index);
    person.index = index;
    return person;
  }

  static List<Person> getAll() {
    if (isEmpty()) {
      return [];
    }

    return internalBox.toMap().values.toList();
  }

  static List<Person> searchByTags(List<String> tags) {
    var persons = internalBox.toMap();

    persons.removeWhere((index, person) {
      return !(person.tags().any((person_tag) {
        // Mapでwhere()が使えないので否定条件でremoveWhere()を使っています。
        return tags.any((tag) {
          return tag == person_tag;
        });
      }));
    });

    return persons.values.toList();
  }

  @override
  Future<void> save() {
    var box = Person.internalBox;
    updated_at = DateTime.now().toUtc();
    created_at ??= updated_at;

    if (key == null) {
      return box.add(this);
    } else {
      return super.save();
    }
  }

  List<String> tags() {
    if (tags_string == null) {
      return [];
    }
    var tags = <String>[];
    tags_string.split(TAG_SEPARATOR).forEach((element) {
      if (element != null && element != '') {
        tags.add(element);
      }
    });

    return tags;
  }
}
