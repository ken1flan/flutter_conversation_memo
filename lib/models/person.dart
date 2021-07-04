import 'package:hive/hive.dart';

part 'person.g.dart';

const int PersonTypeId = 1;

@HiveType(typeId: PersonTypeId)
class Person {
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

  static Future<void> initialize() async {
    Hive.registerAdapter(PersonAdapter());
    _box = await Hive.openBox<Person>(boxName);
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
}
