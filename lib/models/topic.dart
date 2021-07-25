import 'dart:typed_data';
import 'package:hive/hive.dart';
part 'topic.g.dart';

const int TopicTypeId = 0;

@HiveType(typeId: TopicTypeId)
class Topic {
  static const String boxName = 'topicBox';
  static const String TAG_SEPARATOR = ' ';

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

  static Topic getAt(int index) {
    var topic = box().getAt(index);
    topic.index = index;
    return topic;
  }

  static Future<void> deleteAt(int index) async {
    return box().deleteAt(index);
  }

  static Map<dynamic, Topic> searchByTags(List<String> tags) {
    var topics = box().toMap();

    topics.removeWhere((index, topic) {
      return !(topic.tags().any((topic_tag) {
        // Mapでwhere()が使えないので否定条件でremoveWhere()を使っています。
        return tags.any((tag) {
          return tag == topic_tag;
        });
      }));
    });

    return topics;
  }

  void save() {
    var box = Topic.box();
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
    var tags = <String>[];
    tags_string.split(TAG_SEPARATOR).forEach((element) {
      if (element != null && element != '') {
        tags.add(element);
      }
    });

    return tags;
  }
}
