abstract class SharedPrefRepository {
  Future<bool> storeData(String key, String value);
  Future<bool> storeBool(String key, bool value);
  Future<String> fetchData(String key);
  Future<bool> fetchBool(String key);
  Future<bool> removeAll();
}
