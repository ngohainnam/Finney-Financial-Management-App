// File generated by FlutterFire CLI
// ignore_for_file: type=lint
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
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyDseemP_P5H6Z8Hj4-e19QhpyShfKQTbdE',
    appId: '1:560045957556:web:3f7944c50ad1a59a8052e1',
    messagingSenderId: '560045957556',
    projectId: 'finneyauth',
    authDomain: 'finneyauth.firebaseapp.com',
    storageBucket: 'finneyauth.firebasestorage.app',
    measurementId: 'G-DSR1HLFXN0',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAlDrqMlG3kUWXmG3PgWe2eIWcFy__MfJI',
    appId: '1:560045957556:android:1f6142223ecb63968052e1',
    messagingSenderId: '560045957556',
    projectId: 'finneyauth',
    storageBucket: 'finneyauth.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA0bd_fiDNNrHlYZNObBu_0qZZeC13iGQY',
    appId: '1:560045957556:ios:1c1fa9fffb22f1c18052e1',
    messagingSenderId: '560045957556',
    projectId: 'finneyauth',
    storageBucket: 'finneyauth.firebasestorage.app',
    iosBundleId: 'com.example.finney',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA0bd_fiDNNrHlYZNObBu_0qZZeC13iGQY',
    appId: '1:560045957556:ios:1c1fa9fffb22f1c18052e1',
    messagingSenderId: '560045957556',
    projectId: 'finneyauth',
    storageBucket: 'finneyauth.firebasestorage.app',
    iosBundleId: 'com.example.finney',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDseemP_P5H6Z8Hj4-e19QhpyShfKQTbdE',
    appId: '1:560045957556:web:24526b8c2cde76448052e1',
    messagingSenderId: '560045957556',
    projectId: 'finneyauth',
    authDomain: 'finneyauth.firebaseapp.com',
    storageBucket: 'finneyauth.firebasestorage.app',
    measurementId: 'G-6P2H2Q2YLS',
  );
}
