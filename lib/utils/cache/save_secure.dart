import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:savyminds/models/auth/app_user.dart';
import 'package:savyminds/utils/enums/auth_eums.dart';

const _storage = FlutterSecureStorage();
AndroidOptions _getAndroidOptions() => const AndroidOptions(
      encryptedSharedPreferences: true,
    );
const iosOptions =
    IOSOptions(accessibility: KeychainAccessibility.first_unlock);

Future clearStorageData() async {
  _storage.deleteAll();
}

Future userSecureStorage(
    AppUser user, bool? keepLoggedIn, dynamic response) async {
  if (response != null) {
    _storage.write(
        key: 'credentials',
        value: jsonEncode(response),
        aOptions: _getAndroidOptions(),
        iOptions: iosOptions);
  }
  _storage.write(
      key: 'accessToken',
      value: '${user.accessToken}',
      aOptions: _getAndroidOptions(),
      iOptions: iosOptions);
  _storage.write(
      key: 'refreshToken',
      value: '${user.refreshToken}',
      aOptions: _getAndroidOptions(),
      iOptions: iosOptions);
  _storage.write(
      key: 'tokenExpireDate',
      value: '${user.aTokenExpireDate}',
      aOptions: _getAndroidOptions(),
      iOptions: iosOptions);
  _storage.write(
      key: 'keepMeLoggedIn',
      value: 'true',
      aOptions: _getAndroidOptions(),
      iOptions: iosOptions);
  _storage.write(
      key: 'authType',
      value: AuthType.api.name,
      aOptions: _getAndroidOptions(),
      iOptions: iosOptions);
}

Future fcmTokenSecureStorage(String? token) async {
  _storage.write(
      key: 'fcmToken',
      value: token,
      aOptions: _getAndroidOptions(),
      iOptions: iosOptions);
}

Future storeUserDetailsStorage(String user) async {
  _storage.write(
      key: 'credentials',
      value: user,
      aOptions: _getAndroidOptions(),
      iOptions: iosOptions);
}

Future<Map<String, String>> allSecureStorage() async {
  return await _storage.readAll(
      iOptions: iosOptions, aOptions: _getAndroidOptions());
}

Future<String?> getUserDetailsStorage() async {
  return await _storage.read(
      key: "credentials", iOptions: iosOptions, aOptions: _getAndroidOptions());
}

Future<String?> accessTokenStorage() async {
  return await _storage.read(
      key: "accessToken", iOptions: iosOptions, aOptions: _getAndroidOptions());
}

Future<String?> refreshTokenStorage() async {
  return await _storage.read(
      key: "refreshToken",
      iOptions: iosOptions,
      aOptions: _getAndroidOptions());
}

Future<String?> fcmTokenStorage() async {
  return await _storage.read(
      key: "fcmToken", iOptions: iosOptions, aOptions: _getAndroidOptions());
}

Future saveAuthType(AuthType type) async {
  _storage.write(
      key: 'authType',
      value: type.name,
      aOptions: _getAndroidOptions(),
      iOptions: iosOptions);
}
