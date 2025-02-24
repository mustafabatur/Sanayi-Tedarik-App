// File generated by FlutterFire CLI.
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBdYFqqahm6i5bGDLFqLmgP1UbiRMmHTbw',
    appId: '1:504471949698:web:24fc46c0eb623e3dcdff9b',
    messagingSenderId: '504471949698',
    projectId: 'ted1-32c75',
    authDomain: 'ted1-32c75.firebaseapp.com',
    storageBucket: 'ted1-32c75.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDxGnCCoQs7dNEzdItAI5eh9hGoJ47H7uE',
    appId: '1:504471949698:android:01dcc9c849a751cecdff9b',
    messagingSenderId: '504471949698',
    projectId: 'ted1-32c75',
    storageBucket: 'ted1-32c75.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCe3BIFxBmjSScLb0exqkVxNZLlSnoZgfc',
    appId: '1:504471949698:ios:d36af63f23e881d2cdff9b',
    messagingSenderId: '504471949698',
    projectId: 'ted1-32c75',
    storageBucket: 'ted1-32c75.firebasestorage.app',
    iosBundleId: 'com.example.proje2',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBdYFqqahm6i5bGDLFqLmgP1UbiRMmHTbw',
    appId: '1:504471949698:web:99a966cbe99b4372cdff9b',
    messagingSenderId: '504471949698',
    projectId: 'ted1-32c75',
    authDomain: 'ted1-32c75.firebaseapp.com',
    storageBucket: 'ted1-32c75.firebasestorage.app',
  );
}
