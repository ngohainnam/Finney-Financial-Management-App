import '../firebase_storage_service.dart';

class SettingsCloudService {
  final FirebaseStorageService _storage;
  final String _collection = 'settings';
  final String _documentId = 'user_settings';
  
  SettingsCloudService(this._storage);
  
  // Get all user settings
  Future<Map<String, dynamic>> getAllSettings() async {
    final document = await _storage.getDocument(_collection, _documentId);
    return document ?? {};
  }
  
  // Stream settings for real-time updates
  Stream<Map<String, dynamic>> streamSettings() {
    return _storage.streamDocument(_collection, _documentId)
      .map((data) => data ?? {});
  }
  
  // Get a single setting value
  Future<T?> getSetting<T>(String key) async {
    final settings = await getAllSettings();
    return settings[key] as T?;
  }
  
  // Update settings
  Future<void> updateSettings(Map<String, dynamic> settings) async {
    await _storage.setDocument(
      _collection,
      _documentId,
      settings,
      merge: true,
    );
  }
  
  // Language settings
  Future<String> getLanguage() async {
    return await getSetting<String>('language') ?? 'en';
  }
  
  Future<void> setLanguage(String languageCode) async {
    await updateSettings({'language': languageCode});
  }
  
  // Theme settings
  Future<bool> isDarkMode() async {
    return await getSetting<bool>('darkMode') ?? false;
  }
  
  Future<void> setDarkMode(bool isDark) async {
    await updateSettings({'darkMode': isDark});
  }
  
  // Currency settings
  Future<String> getCurrency() async {
    return await getSetting<String>('currency') ?? 'USD';
  }
  
  Future<void> setCurrency(String currency) async {
    await updateSettings({'currency': currency});
  }
  
  // Notification settings
  Future<bool> areNotificationsEnabled() async {
    return await getSetting<bool>('notifications') ?? true;
  }
  
  Future<void> setNotificationsEnabled(bool enabled) async {
    await updateSettings({'notifications': enabled});
  }
  
  // Reset all settings to defaults
  Future<void> resetSettings() async {
    await _storage.setDocument(
      _collection,
      _documentId,
      {
        'language': 'en',
        'darkMode': false,
        'currency': 'USD',
        'notifications': true,
      },
    );
  }
}