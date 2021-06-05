import 'package:hive/hive.dart';

part 'topic.g.dart';

@HiveType(typeId: 0)
class Topic {
  @HiveField(0)
  String summary;
  @HiveField(1)
  String memo;
  @HiveField(2)
  String tags_string;
  @HiveField(3)
  int created_at;
  @HiveField(4)
  int updated_at;

  Topic(this.summary, this.memo, this.tags_string, this.created_at,
      this.updated_at);
}
