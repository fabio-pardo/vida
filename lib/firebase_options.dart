// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
import 'firebase_options.dart';
/// // ...
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
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
    apiKey: 'AIzaSyDOIutz09mFPRP7QuBP72CmV9-vdMpH-pY',
    appId: '1:917175833848:web:e34ff900d1116abdd0d70d',
    messagingSenderId: '917175833848',
    projectId: 'vida-meals',
    authDomain: 'vida-meals.firebaseapp.com',
    storageBucket: 'vida-meals.appspot.com',
    measurementId: 'G-RSBZTM55WM',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAWNrsqCnMIpSuKb9NMt9GJrA1E5fEDfgc',
    appId: '1:917175833848:android:af11839f69252894d0d70d',
    messagingSenderId: '917175833848',
    projectId: 'vida-meals',
    storageBucket: 'vida-meals.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBJkBBlf9ibi0TxjZWJnZwPh7QaXKZaBYQ',
    appId: '1:917175833848:ios:e455d6f958f70e81d0d70d',
    messagingSenderId: '917175833848',
    projectId: 'vida-meals',
    storageBucket: 'vida-meals.appspot.com',
    iosBundleId: 'com.example.vida',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBJkBBlf9ibi0TxjZWJnZwPh7QaXKZaBYQ',
    appId: '1:917175833848:ios:cb301c879e0130d6d0d70d',
    messagingSenderId: '917175833848',
    projectId: 'vida-meals',
    storageBucket: 'vida-meals.appspot.com',
    iosBundleId: 'com.example.vida.RunnerTests',
  );
}
