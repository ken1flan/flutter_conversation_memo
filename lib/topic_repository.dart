import 'package:flutter_conversation_memo/database_helper.dart';
import 'package:flutter_conversation_memo/topic.dart';
import 'package:sqflite/sqlite_api.dart';

class TopicRepository {
  Future insert(Topic topic) async {
    final database = await DatabaseHelper().database;
    var map = topic.toMap();
    map['created_at'] = map['updated_at'] = DateTime.now().microsecond;
    return database.insert(
      'topics',
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Topic>> all() async {
    final database = await DatabaseHelper().database;

    final List<Map<String, dynamic>> maps = await database.query('topics');

    return List.generate(maps.length, (i) {
      var map = maps[i];
      return Topic(
        id: map['id'],
        summary: map['summary'],
        memo: map['memo'],
        tags_string: map['tags_string'],
        created_at: map['created_at'],
        updated_at: map['updated_at'],
      );
    });
  }
}
