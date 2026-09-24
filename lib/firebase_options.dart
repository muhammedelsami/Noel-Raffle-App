// Placeholder so the app builds without a Firebase project.
//
// Run `flutterfire configure` to overwrite this file with your project's
// options (see README, "Firebase setup"). Until then the app runs fully
// offline and hides the online features.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform => throw UnsupportedError(
        'Firebase is not configured. Run `flutterfire configure`.',
      );
}
