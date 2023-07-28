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
    apiKey: 'AIzaSyBkDaL54VjANRCwvKdnO-mWDWhhtkvSduA',
    appId: '1:185269629456:web:0288d9900e40b00cab1095',
    messagingSenderId: '185269629456',
    projectId: 'movieapp-b7e62',
    authDomain: 'movieapp-b7e62.firebaseapp.com',
    storageBucket: 'movieapp-b7e62.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDZPlGEs2-AaOZBvvf5WuKSREe0WincouY',
    appId: '1:185269629456:android:cf1072bb0431e544ab1095',
    messagingSenderId: '185269629456',
    projectId: 'movieapp-b7e62',
    storageBucket: 'movieapp-b7e62.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD0bsA1IuS8AqvoymyQBiQE-PPdN9eYvYU',
    appId: '1:185269629456:ios:1b316a2ba1779393ab1095',
    messagingSenderId: '185269629456',
    projectId: 'movieapp-b7e62',
    storageBucket: 'movieapp-b7e62.appspot.com',
    androidClientId: '185269629456-42c59p986eqe0cfs5t9bf1lpbgmg9k67.apps.googleusercontent.com',
    iosClientId: '185269629456-m8ra6pnpafv9krpvfrfbkatrsptbcvj5.apps.googleusercontent.com',
    iosBundleId: 'com.movie.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD0bsA1IuS8AqvoymyQBiQE-PPdN9eYvYU',
    appId: '1:185269629456:ios:7569729f4bf853f7ab1095',
    messagingSenderId: '185269629456',
    projectId: 'movieapp-b7e62',
    storageBucket: 'movieapp-b7e62.appspot.com',
    androidClientId: '185269629456-42c59p986eqe0cfs5t9bf1lpbgmg9k67.apps.googleusercontent.com',
    iosClientId: '185269629456-kf03pe63dnidv1hi475n6oiiufdkv8gk.apps.googleusercontent.com',
    iosBundleId: 'com.movie.app.movieApp',
  );
}
