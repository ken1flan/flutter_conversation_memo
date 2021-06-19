import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive/hive.dart';

import 'package:flutter_conversation_memo/topic.dart';

const String topicBoxName = 'topicBox';

Widget wrapWithMaterial(Widget widget) {
  return MaterialApp(
    home: widget,
    localizationsDelegates: [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: [
      const Locale('ja', ''),
    ],
  );
}

Future<void> initializeTest() async {
  final path = Directory.current.path;

  Hive.init(path);
  Hive.registerAdapter(TopicAdapter(), override: true);

  await Hive.deleteFromDisk();
}

Future<void> initializeExample() async {
  await Hive.deleteFromDisk();
  await Hive.openBox<Topic>(topicBoxName, bytes: Uint8List(0));
}

Future<void> finalizeExample() async {
  await Hive.close();
}
