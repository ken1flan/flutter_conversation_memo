import 'dart:typed_data';
import 'package:hive/hive.dart';
part 'topic.g.dart';

const int TopicTypeId = 0;

@HiveType(typeId: TopicTypeId)
class Topic {
  static const String boxName = 'topicBox';
  static Box<Topic> _box;
  int index;

  @HiveField(0)
  String summary;
  @HiveField(1)
  String memo;
  @HiveField(2)
  String tags_string;
  @HiveField(3)
  DateTime created_at;
  @HiveField(4)
  DateTime updated_at;

  Topic(this.summary, this.memo, this.tags_string, this.created_at,
      this.updated_at);

  static Future<void> initialize({memory_box = false}) async {
    Hive.registerAdapter(TopicAdapter());
    var bytes = memory_box ? Uint8List(0) : null;
    _box = await Hive.openBox<Topic>(boxName, bytes: bytes);
  }

  static Box<Topic> box() {
    return _box;
  }
}
