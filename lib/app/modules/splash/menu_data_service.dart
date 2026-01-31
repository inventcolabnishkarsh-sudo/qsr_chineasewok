import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class MenuDataService extends GetxService {
  static const _fileName = 'menu_data.json';

  Map<String, dynamic>? _menuData;

  bool get hasData => _menuData != null;
  Map<String, dynamic>? get rawData => _menuData;

  /// 🔹 Extract GROUPS safely
  List<Map<String, dynamic>> get groups {
    if (_menuData == null) return [];

    final groupsNode = _menuData!['Groups'];
    if (groupsNode == null || groupsNode['\$values'] == null) return [];

    return List<Map<String, dynamic>>.from(groupsNode['\$values']);
  }

  /// 📂 Get local file path
  Future<File> _getLocalFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_fileName');
  }

  /// 🖨️ PRINT where the file is stored
  Future<void> printStoragePath() async {
    final file = await _getLocalFile();
    print('📂 Menu data file stored at: ${file.path}');
  }

  /// 💾 Save API response to FILE
  Future<void> setData(Map<String, dynamic> data) async {
    _menuData = data;
    final file = await _getLocalFile();
    await file.writeAsString(jsonEncode(data), flush: true);

    // 👇 print path after saving
    print('✅ Menu data saved at: ${file.path}');
  }

  /// 📥 Load from FILE on app start
  Future<void> loadFromFile() async {
    final file = await _getLocalFile();

    // 👇 print path on load
    print('📂 Loading menu data from: ${file.path}');

    if (await file.exists()) {
      final content = await file.readAsString();
      _menuData = jsonDecode(content);
    }
  }

  /// 🧹 Clear cached file
  Future<void> clear() async {
    _menuData = null;
    final file = await _getLocalFile();
    if (await file.exists()) {
      await file.delete();
      print('🗑 Menu data file deleted from: ${file.path}');
    }
  }
}
