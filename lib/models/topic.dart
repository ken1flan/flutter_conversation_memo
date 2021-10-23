import 'dart:io';
import 'dart:typed_data';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
part 'topic.g.dart';

const int TopicTypeId = 0;

@HiveType(typeId: TopicTypeId)
class Topic extends HiveObject {
  static const String boxName = 'topicBox';
  static const String TAG_SEPARATOR = ' ';

  static Box<Topic> internalBox;
  static String imageBasePath;
  int index;
  File imageFile;

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
  @HiveField(5)
  String image_file_name;

  Topic(this.summary, this.memo, this.tags_string,
      [this.created_at, this.updated_at, this.image_file_name]);

  static Future<void> initialize({memory_box = false}) async {
    Hive.registerAdapter(TopicAdapter());
    var bytes = memory_box ? Uint8List(0) : null;
    internalBox = await Hive.openBox<Topic>(boxName, bytes: bytes);

    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    imageBasePath = '$path/topics';
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
  Future<void> save() async {
    var box = Topic.internalBox;
    updated_at = DateTime.now().toUtc();
    created_at ??= updated_at;

    if (key == null) {
      await box.add(this);
    } else {
      await super.save();
    }
    // 画像保存
    var imageFilePath = imageFile == null ? null : imageFile.path;
    if (imageFile != null && imageFilePath != imagePath) {
      final dir = Directory(imageDir);
      if (imageDir != null && dir.existsSync()) {
        dir.deleteSync(recursive: true);
      }
      dir.createSync(recursive: true);
      image_file_name = imageFilePath.split('/').last;
      var file = File('$imageDir/$image_file_name');
      file.writeAsBytesSync(await imageFile.readAsBytes());
      imageFile = file;
      await super.save();
    }

    return Future.value(null);
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

  set image(File imageFile) {
    this.imageFile = imageFile;
  }

  String get imageDir {
    if (key == null) {
      return null;
    } else {
      return '$imageBasePath/$key';
    }
  }

  String get imagePath {
    return image_file_name == null ? null : '$imageDir/$image_file_name';
  }

  File get image {
    if (imageFile != null) {
      return imageFile;
    }

    if (image_file_name == null) {
      return null;
    } else {
      final imagePath = '$imageBasePath/$key/$image_file_name';
      final _image = File(imagePath);
      return _image;
    }
  }
}
