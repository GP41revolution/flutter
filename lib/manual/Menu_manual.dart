import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/Menu.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: IntroPage(),
    );
  }
}

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // MenuPageScreensに戻る
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('遊び方マニュアル'),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
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
                  title: 'このアプリについて',
                  description: 'このゲームは除菌を行い、得点を挙げていくゲームです。',
                  color: Colors.blue,
                  imagePath: 'assets/splash_image.jpg',
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
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < 3; i++)
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.0),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == i ? Colors.blue : Colors.grey,
                    ),
                  ),
                Spacer(),
                GestureDetector(
                  onTap: _nextPage,
                  child: Text(
                    _currentPage == 2 ? '終わり' : '次へ',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
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
    String? secondImagePath, //2つ目の画像を入れるコード(オプション)
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
                    SizedBox(height: 10), //２枚目の画像とのスペース
                    Image.asset(
                      secondImagePath,
                      height: 240,
                      width: 150,
                    ), //２枚目の画像パス
                  ]
                ],
              ),
            ],
          ),
        )));
  }
}
