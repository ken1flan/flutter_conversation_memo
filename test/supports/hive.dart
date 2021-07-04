import 'dart:io';
import 'package:hive/hive.dart';

void initializeHive() {
  final path = Directory.current.path;

  Hive.init(path);
}

void finalizeHive() async {
  await Hive.deleteFromDisk();
}
