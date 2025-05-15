abstract class StorageService {
  Future<void> init();
  Future<T?> getValue<T>(String key, {String? boxName});
  Future<List<T>> getAll<T>({String? boxName});
  Future<void> setValue<T>(String key, T value, {String? boxName});
  Future<void> removeValue(String key, {String? boxName});
  Future<void> clear({String? boxName});
  Future<int> count({String? boxName});
}