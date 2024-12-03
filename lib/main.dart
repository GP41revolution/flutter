import 'package:flutter/material.dart';
import 'package:flutter_application_1/manual/Start_manual.dart';
import 'package:flutter_application_1/src/app.dart';
import 'package:flutter_application_1/manual/Start_manual.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  final widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized(); // アプリ起動時のスプラッシュ画面表示
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aqua Guardian',
      theme: ThemeData(primaryColor: Colors.blue[400]),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    // スプラッシュ画面を数秒間表示
    await Future.delayed(const Duration(seconds: 2));
    FlutterNativeSplash.remove(); // スプラッシュ画面を削除

    // StartManualPageに遷移
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => StartManualPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Image.asset(
          'assets/splash_image.jpg', // スプラッシュ画面の画像
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
