// File generated for Firebase project autos-app-634d8.
// Ignore for file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAFfFfCyr4fB2utkCKJ4wwQEIkFPeQBQUE',
    appId: '1:198583765464:android:87822e91760675c3558aad',
    messagingSenderId: '198583765464',
    projectId: 'autos-app-634d8',
    storageBucket: 'autos-app-634d8.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAzz47s7nzn3VaV3mq5pRCMPiGFJcgp0yY',
    appId: '1:198583765464:ios:28529b339c24bae9558aad',
    messagingSenderId: '198583765464',
    projectId: 'autos-app-634d8',
    storageBucket: 'autos-app-634d8.firebasestorage.app',
    iosBundleId: 'com.autocare.autocareManager',
  );
}
