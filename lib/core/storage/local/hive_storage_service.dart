import 'package:finney/core/storage/storage_interface.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveStorageService implements StorageService {
  final Map<String, Box> _boxes = {};
  bool _initialized = false;
  
  @override
  Future<void> init() async {
    if (_initialized) return;
    
    await Hive.initFlutter();
    _initialized = true;
  }
  
  Future<Box> _getBox(String boxName) async {
    if (!_boxes.containsKey(boxName)) {
      if (!Hive.isBoxOpen(boxName)) {
        _boxes[boxName] = await Hive.openBox(boxName);
      } else {
        _boxes[boxName] = Hive.box(boxName);
      }
    }
    return _boxes[boxName]!;
  }
  
  Future<Box<T>> _getTypedBox<T>(String boxName) async {
    if (!_boxes.containsKey(boxName)) {
      if (!Hive.isBoxOpen(boxName)) {
        _boxes[boxName] = await Hive.openBox<T>(boxName);
      } else {
        _boxes[boxName] = Hive.box<T>(boxName);
      }
    }
    return _boxes[boxName]! as Box<T>;
  }
  
  @override
  Future<T?> getValue<T>(String key, {String? boxName}) async {
    final box = await _getBox(boxName ?? 'default');
    return box.get(key) as T?;
  }
  
  @override
  Future<List<T>> getAll<T>({String? boxName}) async {
    final box = await _getBox(boxName ?? 'default');
    return box.values.toList().cast<T>();
  }
  
  @override
  Future<void> setValue<T>(String key, T value, {String? boxName}) async {
    final box = await _getBox(boxName ?? 'default');
    await box.put(key, value);
  }
  
  @override
  Future<void> removeValue(String key, {String? boxName}) async {
    final box = await _getBox(boxName ?? 'default');
    await box.delete(key);
  }
  
  @override
  Future<void> clear({String? boxName}) async {
    if (boxName != null) {
      final box = await _getBox(boxName);
      await box.clear();
    } else {
      for (var box in _boxes.values) {
        await box.clear();
      }
    }
  }
  
  @override
  Future<int> count({String? boxName}) async {
    final box = await _getBox(boxName ?? 'default');
    return box.length;
  }
  
  // Additional utility methods
  Future<bool> containsKey(String key, {String? boxName}) async {
    final box = await _getBox(boxName ?? 'default');
    return box.containsKey(key);
  }
  
  Future<void> addItem<T>(T item, {String? boxName}) async {
    final box = await _getTypedBox<T>(boxName ?? 'default');
    await box.add(item);
  }
  
  Future<Iterable<int>> addAllItems<T>(List<T> items, {String? boxName}) async {
    final box = await _getTypedBox<T>(boxName ?? 'default');
    return await box.addAll(items);
  }
}