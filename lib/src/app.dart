import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/Map.dart';
import 'package:flutter_application_1/screen/Menu.dart';
import 'package:flutter_application_1/screen/Rank.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:image_picker/image_picker.dart';

void main() {
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
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String text = "";
  String usernameText = "";
  File? _image; // 選択した画像ファイルを格納

  // Firestoreインスタンスの取得
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Firestoreにデータを保存するメソッド
  Future<void> _saveUserToFirestore(String username) async {
    try {
      await _firestore.collection('users').add({
        'username': username,
        'created_at': Timestamp.now(),
        'profile_image': _image != null ? _image!.path : null,
      });
      print("ユーザー情報を保存しました");
    } catch (e) {
      print("Firestoreエラー: $e");
    }
  }

  // 画像を選択するメソッド
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // 選択した画像のパスを格納
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 450,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color.fromARGB(255, 89, 164, 226)!, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _pickImage, // 画像選択メソッドを呼び出し
                child: Container(
                  width: 80,
                  height: 80,
                  child: Center(
                    child: _image != null
                        ? Image.file(
                            _image!, // 選択した画像を表示
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/Enemy3.png', // デフォルトの画像
                            width: 200,
                            height: 200,
                            fit: BoxFit.contain,
                          ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'ようこそ!Aqua Guardianへ!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: UnderlineInputBorder(),
                  ),
                  onChanged: (value) {
                    text = value;
                  },
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  if (text.isNotEmpty) {
                    await _saveUserToFirestore(text);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyStatefulWidget(),
                      ),
                    );
                    setState(() {
                      usernameText = text; // ボタン押下時にTextFieldの内容をセット
                    });
                  } else {
                    print("Usernameを入力してください");
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: Text('次へ'),
              ),
              SizedBox(height: 20),
              Text(
                'Aqua Guardian',
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove(); // 起動完了時にスプラッシュ画面を終わらせる
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  static var _screens = [
    // const TopPageScreens(),
    RankPageScreens(),
    const MapPageScreens(),
    const MenuPageScreens(),
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          //  BottomNavigationBarItem(icon: Icon(Icons.home), label: 'ホーム'),
          BottomNavigationBarItem(
              icon: Icon(Icons.emoji_events), label: 'ランキング'),
          BottomNavigationBarItem(
              icon: Icon(Icons.sports_esports), label: 'ゲーム'),

          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'メニュー'),
        ],
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color.fromARGB(255, 192, 208, 237),
      ),
    );
  }
}
