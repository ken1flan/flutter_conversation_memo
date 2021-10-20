import 'package:path_provider/path_provider.dart';

void clearDocumentDirectory() async {
  final directory = await getApplicationDocumentsDirectory();
  if (directory.existsSync()) {
    directory.deleteSync(recursive: true);
  }
}
