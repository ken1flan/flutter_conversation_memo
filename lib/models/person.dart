import 'dart:typed_data';
import 'package:hive/hive.dart';

part 'person.g.dart';

const int PersonTypeId = 1;

@HiveType(typeId: PersonTypeId)
class Person {
  String TAG_SEPARATOR = ' ';

  static Box<Person> _box;
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

  Person(
      this.name, this.memo, this.tags_string, this.created_at, this.updated_at);

  static const boxName = 'personBox';

  static Future<void> initialize({memory_box = false}) async {
    Hive.registerAdapter(PersonAdapter());
    var bytes = memory_box ? Uint8List(0) : null;
    _box = await Hive.openBox<Person>(boxName, bytes: bytes);
  }

  static Box<Person> box() {
    return _box;
  }

  static Person getAt(int index) {
    var person = box().getAt(index);
    person.index = index;
    return person;
  }

  static Future<void> deleteAt(int index) async {
    return box().deleteAt(index);
  }

  static Map<dynamic, Person> searchByTags(List<String> tags) {
    var persons = box().toMap();

    persons.removeWhere((index, person) {
      return !(person.tags().any((person_tag) {
        // Mapでwhere()が使えないので否定条件でremoveWhere()を使っています。
        return tags.any((tag) {
          return tag == person_tag;
        });
      }));
    });

    return persons;
  }

  void save() {
    var box = Person.box();
    updated_at = DateTime.now().toUtc();

    if (index == null) {
      created_at = updated_at;
      box.add(this);
    } else {
      box.putAt(index, this);
    }
  }

  List<String> tags() {
    if (tags_string == null) {
      return [];
    }
    List<String> tags = [];
    tags_string.split(TAG_SEPARATOR).forEach((element) {
      if (element != null && element != '') {
        tags.add(element);
      }
    });

    return tags;
  }
}
