import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SettingsService {
  static const _storage = FlutterSecureStorage();
  static const String key_theme = "key_light_theme";
  static Future<void> saveDarkTheme(bool value) async {
    await _storage.write(key: key_theme, value: value.toString());
  }

  static Future<void> saveLightTheme(bool value) async {
    await _storage.write(key: key_theme, value: value.toString());
  }

  static Future<bool> loadDarkTheme() async {
    String? value = await _storage.read(key: key_theme);
    return value == "true";
  }
}
