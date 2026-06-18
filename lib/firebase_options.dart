// lib/firebase_options.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        throw UnsupportedError('Android config not added yet');
      case TargetPlatform.iOS:
        throw UnsupportedError('iOS config not added yet');
      default:
        throw UnsupportedError('DefaultFirebaseOptions are not supported for this platform.');
    }
  }

  // 📝 FILL THESE IN FROM YOUR FIREBASE WEB APP CONFIG
  static final FirebaseOptions web = FirebaseOptions(
apiKey: "${dotenv.env['apiKey']}",
  authDomain: "${dotenv.env['authDomain']}",
  projectId: "${dotenv.env['projectId']}",
  storageBucket: "${dotenv.env['storageBucket']}",
  messagingSenderId: "${dotenv.env['messagingSenderId']}",
  appId: "${dotenv.env['appId']}",
  );
}