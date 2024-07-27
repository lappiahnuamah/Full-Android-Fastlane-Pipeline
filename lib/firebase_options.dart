// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD68GNMgxKFiSmy8-HWz6Uhsu50yc3oXRg',
    appId: '1:642728101123:web:fa41b9eb453cfabba65536',
    messagingSenderId: '642728101123',
    projectId: 'savyminds-c4f53',
    authDomain: 'savyminds-c4f53.firebaseapp.com',
    storageBucket: 'savyminds-c4f53.appspot.com',
    measurementId: 'G-E4VZ30QTD9',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAaP1V39X9-KDPLWOOhAI2zEUR3EDqoiz4',
    appId: '1:642728101123:android:1ba5a595ee796655a65536',
    messagingSenderId: '642728101123',
    projectId: 'savyminds-c4f53',
    storageBucket: 'savyminds-c4f53.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAOZycZsH9O3EPPEGK_80-vxB2cLVDtTqE',
    appId: '1:642728101123:ios:3a1b64a1b80c7a11a65536',
    messagingSenderId: '642728101123',
    projectId: 'savyminds-c4f53',
    storageBucket: 'savyminds-c4f53.appspot.com',
    iosBundleId: 'com.terateck.games.savyminds',
  );
}
