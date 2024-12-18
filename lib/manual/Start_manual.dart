import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // SharedPreferencesから初回起動の確認
  final prefs = await SharedPreferences.getInstance();
  final bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

  runApp(MyApp(isFirstLaunch: isFirstLaunch));
}

class MyApp extends StatelessWidget {
  final bool isFirstLaunch;

  const MyApp({required this.isFirstLaunch});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isFirstLaunch ? StartManualPage() : WelcomeScreen(),
    );
  }
}

class StartManualPage extends StatefulWidget {
  @override
  _StartManualPageState createState() => _StartManualPageState();
}

class _StartManualPageState extends State<StartManualPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() async {
    //ボタンを押した時のページの遷移数
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // 初回起動状態を記録
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isFirstLaunch', false);

      // クリエイト画面に遷移
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => WelcomeScreen()),
      );
    }
  }

  // 「説明を飛ばす」ボタンが押されたとき
  void _skipIntro() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstLaunch', false);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => WelcomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                _buildPage(
                  title: 'AquaGurdianへようこそ!!',
                  description: 'アプリの使い方について',
                  color: const Color.fromARGB(255, 243, 124, 33),
                  imagePath: 'assets/CreateImage.jpg',
                  showSkipButton: true, // 最初のスライドで「説明を飛ばす」ボタンを表示
                ),
                _buildPage(
                  title: 'このアプリについて',
                  description: 'このゲームは除菌を行い、得点を挙げていくゲームです。',
                  color: Colors.blue,
                  imagePath: 'assets/splash_image.png',
                ),
                _buildPage(
                  title: '遊び方その１',
                  description: 'マップごとに難易度が分かれている為、マップを選択し、難易度の確認を行います。',
                  color: Colors.green,
                  imagePath: 'assets/Manual(1).png',
                  secondImagePath: 'assets/Manual(2).png',
                ),
                _buildPage(
                  title: '遊び方その２',
                  description:
                      'タップすることによって除菌を行うことができます。除菌を行い、得点を上げてランキング上位を目指しましょう！',
                  color: Colors.orange,
                  imagePath: 'assets/Manual(3).png',
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(7.0),
            child: Center(
              child: GestureDetector(
                onTap: _nextPage,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 11.0, horizontal: 120.0),
                  decoration: BoxDecoration(
                    color: Colors.red, // 赤いボタン
                    borderRadius: BorderRadius.circular(8.0), // ボタンの角を丸く
                  ),
                  child: Text(
                    _currentPage == 3 ? 'スタート！' : '次へ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // 「説明を飛ばす」ボタンを下部に配置
          if (_currentPage == 0)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Center(
                child: GestureDetector(
                  onTap: _skipIntro,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 4.5, horizontal: 23.0),
                    decoration: BoxDecoration(
                      color:
                          const Color.fromARGB(255, 91, 101, 109), // 青いボタンに変更
                      borderRadius: BorderRadius.circular(8.0), // ボタンの角を丸く
                    ),
                    child: Text(
                      '説明を飛ばす',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPage({
    required String title,
    required String description,
    required Color color,
    required String imagePath,
    String? secondImagePath,
    bool showSkipButton = false, // 「説明を飛ばす」ボタンの表示
  }) {
    return Container(
      color: color,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: 16),
              Text(
                description,
                style: TextStyle(fontSize: 18, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    imagePath,
                    height: 240,
                    width: 150,
                  ),
                  if (secondImagePath != null) ...[
                    SizedBox(height: 10),
                    Image.asset(
                      secondImagePath,
                      height: 240,
                      width: 150,
                    ),
                  ]
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
