import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'supports/document_directory.dart';
import 'supports/path_provider.dart';
import 'supports/hive.dart';

class TestHelper {
  static void setUpAll() async {
    PathProviderPlatform.instance = FakePathProviderPlatform();
    await initializeHive();
  }

  static void tearDown() async {
    clearDocumentDirectory();
    await tearDownHive();
  }
}
