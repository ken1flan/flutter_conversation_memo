import 'dart:typed_data';
import 'package:hive/hive.dart';
part 'topic.g.dart';

const int TopicTypeId = 0;

@HiveType(typeId: TopicTypeId)
class Topic extends HiveObject {
  static const String boxName = 'topicBox';
  static const String TAG_SEPARATOR = ' ';

  static Box<Topic> internalBox;
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

  Topic(this.summary, this.memo, this.tags_string,
      [this.created_at, this.updated_at]);

  static Future<void> initialize({memory_box = false}) async {
    Hive.registerAdapter(TopicAdapter());
    var bytes = memory_box ? Uint8List(0) : null;
    internalBox = await Hive.openBox<Topic>(boxName, bytes: bytes);
  }

  static bool isEmpty() {
    return internalBox.isEmpty;
  }

  static int count() {
    return internalBox.values.length;
  }

  static Topic getAt(int index) {
    var topic = internalBox.getAt(index);
    topic.index = index;
    return topic;
  }

  static List<Topic> getAll() {
    if (isEmpty()) {
      return [];
    }

    var topics = internalBox.toMap().values.toList();
    topics.sort((a, b) => b.updated_at.compareTo(a.updated_at));

    return topics;
  }

  static List<Topic> searchByTags(List<String> tags) {
    return getAll().where((topic) {
      return (topic.tags().any((topic_tag) {
        return tags.any((tag) {
          return tag == topic_tag;
        });
      }));
    }).toList();
  }

  @override
  Future<void> save() {
    var box = Topic.internalBox;
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
