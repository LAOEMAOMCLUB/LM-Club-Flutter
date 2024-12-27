import 'package:lm_club/app/domain/local_storage/shared_pref_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefRepositoryImpl extends SharedPrefRepository {
  @override
  Future<String> fetchData(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(key)!;
    } catch (e) {
      return '';
    }
  }

  @override
  Future<bool> storeData(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }

  @override
  Future<bool> fetchBool(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(key)!;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> storeBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setBool(key, value);
  }

  @override
  Future<bool> removeAll() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.clear();
  }
}
