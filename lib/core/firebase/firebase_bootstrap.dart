import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../../firebase_options.dart';

/// Initializes Firebase and reports whether the online features can be used.
///
/// Firebase is optional: without a configured project (see
/// `lib/firebase_options.dart`) or when initialization fails, the app keeps
/// working offline.
Future<bool> initializeFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    return true;
  } catch (error) {
    debugPrint('Firebase disabled, running offline: $error');
    return false;
  }
}
