/// ================================================
/// File    : firebase_options.dart
/// Module  : App
/// Desc    : Placeholder for Firebase options
/// Author  : AMOPS Dev Team
/// Date    : May 2026
/// ================================================

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    // This is a placeholder. Real options should be generated via flutterfire configure.
    return const FirebaseOptions(
      apiKey: 'dummy-api-key',
      appId: 'dummy-app-id',
      messagingSenderId: 'dummy-sender-id',
      projectId: 'dummy-project-id',
      storageBucket: 'dummy-bucket',
    );
  }
}
