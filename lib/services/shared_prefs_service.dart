import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  final Future<SharedPreferences> _sharedPreferences =
      SharedPreferences.getInstance();

  Future<bool> storeString(String key, String value) async {
    final prefs = await _sharedPreferences;
    return await prefs.setString(key, value);
  }

  Future<String?> readString(String key) async {
    final prefs = await _sharedPreferences;
    return prefs.getString(key);
  }
}
