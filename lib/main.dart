import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/app.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  final widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized(); //アプリ起動時のスプラッシュ画面表示
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
