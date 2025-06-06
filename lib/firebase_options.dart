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
    apiKey: 'AIzaSyA_p6oh21sUJAT6cRYM1h7rMxWgdaPL_54',
    appId: '1:141125428871:web:f22303ed9b6ae200867a22',
    messagingSenderId: '141125428871',
    projectId: 'boviframe',
    authDomain: 'boviframe.firebaseapp.com',
    databaseURL: 'https://boviframe-default-rtdb.firebaseio.com',
    storageBucket: 'boviframe.firebasestorage.app',
    measurementId: 'G-VYRFTYTM13',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCEv4Pwc9-aS0eHJp_Z-RiifBiPFxBmgMs',
    appId: '1:141125428871:android:6794ee38ae3cdd6a867a22',
    messagingSenderId: '141125428871',
    projectId: 'boviframe',
    databaseURL: 'https://boviframe-default-rtdb.firebaseio.com',
    storageBucket: 'boviframe.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDZGVSedEIhGkv32pGBffUjylN1iCQdEVc',
    appId: '1:141125428871:ios:40292f74fb5b049b867a22',
    messagingSenderId: '141125428871',
    projectId: 'boviframe',
    databaseURL: 'https://boviframe-default-rtdb.firebaseio.com',
    storageBucket: 'boviframe.firebasestorage.app',
    iosClientId: '141125428871-7jfclrtqvp72khqjrbsi6qnm6fhtkuj8.apps.googleusercontent.com',
    iosBundleId: 'com.example.boviframe',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDZGVSedEIhGkv32pGBffUjylN1iCQdEVc',
    appId: '1:141125428871:ios:40292f74fb5b049b867a22',
    messagingSenderId: '141125428871',
    projectId: 'boviframe',
    databaseURL: 'https://boviframe-default-rtdb.firebaseio.com',
    storageBucket: 'boviframe.firebasestorage.app',
    iosClientId: '141125428871-7jfclrtqvp72khqjrbsi6qnm6fhtkuj8.apps.googleusercontent.com',
    iosBundleId: 'com.example.boviframe',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA_p6oh21sUJAT6cRYM1h7rMxWgdaPL_54',
    appId: '1:141125428871:web:bf96a4801dd90f78867a22',
    messagingSenderId: '141125428871',
    projectId: 'boviframe',
    authDomain: 'boviframe.firebaseapp.com',
    databaseURL: 'https://boviframe-default-rtdb.firebaseio.com',
    storageBucket: 'boviframe.firebasestorage.app',
    measurementId: 'G-TEWP71MZHX',
  );

}