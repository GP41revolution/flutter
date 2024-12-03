import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/Map.dart';
import 'package:flutter_application_1/screen/Menu.dart';
import 'package:flutter_application_1/screen/Rank.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/user_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserProvider(), // UserProviderの提供
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Aqua Guardian',
        theme: ThemeData(primaryColor: Colors.blue[400]),
        home: const WelcomeScreen(),
      ),
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String username = "";
  String welcomeMessage = "ようこそ! Aqua Guardianへ!";
  File? _image; // 選択した画像ファイルを格納
  bool _showWarning = false; // 警告表示の状態

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Firestoreにユーザー名が存在するか確認
  Future<bool> _checkUserExists(String username) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print("Firestoreエラー: $e");
      return false;
    }
  }

  // Firestoreにユーザー情報を保存
  Future<void> _saveUserToFirestore(String username) async {
    try {
      await _firestore.collection('users').add({
        'username': username,
        'created_at': Timestamp.now(),
      });
      print("ユーザー情報を保存しました: $username");
    } catch (e) {
      print("Firestore保存エラー: $e");
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
              colors: [const Color.fromARGB(255, 89, 164, 226), Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                child: Container(
                  width: 80,
                  height: 80,
                  child: Center(
                    child: _image != null
                        ? Image.file(
                            _image!,
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/Enemy3.png',
                            width: 200,
                            height: 200,
                            fit: BoxFit.contain,
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                welcomeMessage,
                style:
                    const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    border: UnderlineInputBorder(),
                  ),
                  onChanged: (value) {
                    username = value.trim();
                  },
                ),
              ),
              if (_showWarning)
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    'ユーザーネームを入力してください',
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  if (username.isNotEmpty) {
                    final userExists = await _checkUserExists(username);
                    if (userExists) {
                      setState(() {
                        welcomeMessage = "おかえりなさい、$username!";
                        _showWarning = false;
                      });
                      // UserProviderでusernameを更新
                      Provider.of<UserProvider>(context, listen: false)
                          .setUsername(username);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyStatefulWidget(),
                        ),
                      );
                    } else {
                      await _saveUserToFirestore(username);
                      setState(() {
                        welcomeMessage = "ようこそ、$username!";
                        _showWarning = false;
                      });
                      // UserProviderでusernameを更新
                      Provider.of<UserProvider>(context, listen: false)
                          .setUsername(username);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyStatefulWidget(),
                        ),
                      );
                    }
                  } else {
                    setState(() {
                      _showWarning = true;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text('次へ'),
              ),
              const SizedBox(height: 20),
              const Text(
                'Aqua Guardian',
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  static final _screens = [
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
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.emoji_events), label: 'ランキング'),
          BottomNavigationBarItem(
              icon: Icon(Icons.sports_esports), label: 'ゲーム'),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'メニュー'),
        ],
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromARGB(255, 192, 208, 237),
      ),
    );
  }
}
