import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ContentManagement {
  ContentManagement();

  final _storage = const FlutterSecureStorage();
  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
  final iosOptions =
      const IOSOptions(accessibility: KeychainAccessibility.first_unlock);

  /////////////////////////  Search History /////////////////////////
  Future cacheSearchHistory(dynamic data) async {
    _storage.write(
        key: 'SearchHistory',
        value: data,
        aOptions: _getAndroidOptions(),
        iOptions: iosOptions);
  }

  Future<String?> getCachedSearchHistory() async {
    return await _storage.read(
        key: "SearchHistory",
        iOptions: iosOptions,
        aOptions: _getAndroidOptions());
  }

  /////////////////////////  Notifications /////////////////////////
  Future cacheNotifications(dynamic data) async {
    _storage.write(
        key: 'Notifications',
        value: data,
        aOptions: _getAndroidOptions(),
        iOptions: iosOptions);
  }

  Future<String?> getCachedNotifications() async {
    return await _storage.read(
        key: "Notifications",
        iOptions: iosOptions,
        aOptions: _getAndroidOptions());
  }

  /////////////////////////  App Versions /////////////////////////
  Future cacheAppVersion(String data) async {
    _storage.write(
        key: 'AppVersion',
        value: data,
        aOptions: _getAndroidOptions(),
        iOptions: iosOptions);
  }

  Future<String?> getCachedAppVersion() async {
    return await _storage.read(
        key: "AppVersion",
        iOptions: iosOptions,
        aOptions: _getAndroidOptions());
  }

  ////////////////////// Clear All /////////////////
  Future clearAll() async {
    await _storage.deleteAll(
        iOptions: iosOptions, aOptions: _getAndroidOptions());
  }
}
