import 'package:flutter/material.dart';

import 'app/app.dart';
import 'core/di/injection.dart';
import 'core/firebase/firebase_bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final bool cloudEnabled = await initializeFirebase();
  await configureDependencies(cloudEnabled: cloudEnabled);
  runApp(const NoelRaffleApp());
}
