import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app/app.dart';
import 'core/di/injection.dart';
import 'core/firebase/firebase_bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Draw behind transparent system bars; the theme picks their icon colors.
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  final bool cloudEnabled = await initializeFirebase();
  await configureDependencies(cloudEnabled: cloudEnabled);
  runApp(const NoelRaffleApp());
}
