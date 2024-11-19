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
        backgroundColor: Color.fromARGB(255, 192, 208, 237),
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
                  title: '機能紹介 1',
                  description: 'このアプリでは、○○の機能を使って○○ができます。',
                  color: Colors.blue,
                  imagePath: 'assets/splash_image.jpg',
                ),
                _buildPage(
                  title: '機能紹介 2',
                  description: '○○を利用して、○○も可能です。',
                  color: Colors.green,
                  imagePath: 'assets/splash_image.jpg',
                ),
                _buildPage(
                  title: 'ブッスー',
                  description: '下痢ポケモン。1日1回下痢をする。最近は腹の調子が良い。好きな言葉は「マンドリル」',
                  color: Colors.orange,
                  imagePath: 'assets/CreateImage.jpg',
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
  }) {
    return Container(
      color: color,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                width: 200,
                height: 150,
              ),
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
            ],
          ),
        ),
      ),
    );
  }
}
