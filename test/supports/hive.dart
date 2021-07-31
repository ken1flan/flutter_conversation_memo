import 'dart:io';
import 'package:hive/hive.dart';
import 'package:flutter_conversation_memo/models/person.dart';
import 'package:flutter_conversation_memo/models/topic.dart';

Future<void> initializeHive() async {
  final path = Directory.current.path;

  Hive.init(path);
  await Topic.initialize(memory_box: true);
  await Person.initialize(memory_box: true);
}

Future<void> tearDownHive() async {
  await Topic.box().clear();
  await Person.box().clear();
}

void finalizeHive() async {
  await Hive.deleteFromDisk();
}
