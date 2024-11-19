import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/app.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() {
  final widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized(); //アプリ起動時のスプラッシュ画面表示
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, //firebase
  );
  runApp(const MyApp());
}
