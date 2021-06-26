import 'package:hive/hive.dart';

part 'person.g.dart';

@HiveType(typeId: 1)
class Person {
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
  static bool initialized = false;

  static void initialize() async {
    Hive.registerAdapter(PersonAdapter());
    await Hive.openBox<Person>('personBox');
    initialized = true;
  }

  static Box<Person> box() {
    if (!initialized) {
      initialize();
    }

    return Hive.box<Person>(boxName);
  }

  static Person getAt(index) {
    var person = box().getAt(index);
    person.index = index;
    return person;
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
