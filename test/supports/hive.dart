import 'dart:io';
import 'package:hive/hive.dart';

Future<void> initializeHive() async {
  final path = Directory.current.path;

  Hive.init(path);
}

Future<void> tearDownHive() async {
  await Hive.deleteFromDisk();
}
