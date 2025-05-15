import '../hive_storage_service.dart';

class SettingsLocalService {
  final HiveStorageService _storage;
  final String _boxName = 'settings';

  SettingsLocalService(this._storage);

  Future<void> init() async {
    await _storage.getValue('init', boxName: _boxName);
  }

  // Language settings
  Future<String> getLanguage() async {
    return await _storage.getValue<String>('language', boxName: _boxName) ?? 'en';
  }

  Future<void> setLanguage(String languageCode) async {
    await _storage.setValue('language', languageCode, boxName: _boxName);
  }

  // Theme settings
  Future<bool> isDarkMode() async {
    return await _storage.getValue<bool>('darkMode', boxName: _boxName) ?? false;
  }

  Future<void> setDarkMode(bool isDark) async {
    await _storage.setValue('darkMode', isDark, boxName: _boxName);
  }

  // Currency settings
  Future<String> getCurrency() async {
    return await _storage.getValue<String>('currency', boxName: _boxName) ?? 'USD';
  }

  Future<void> setCurrency(String currency) async {
    await _storage.setValue('currency', currency, boxName: _boxName);
  }
  
  // Notification settings
  Future<bool> areNotificationsEnabled() async {
    return await _storage.getValue<bool>('notifications', boxName: _boxName) ?? true;
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    await _storage.setValue('notifications', enabled, boxName: _boxName);
  }

  // Reset settings
  Future<void> resetSettings() async {
    await _storage.clear(boxName: _boxName);
  }
}