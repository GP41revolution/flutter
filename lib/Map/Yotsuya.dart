import 'package:flutter/material.dart';
import 'package:flutter_application_1/Game/NomarlGame.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: YotsuyaPage(),
    );
  }
}

class YotsuyaPage extends StatefulWidget {
  const YotsuyaPage({Key? key}) : super(key: key);

  @override
  _YotsuyaPageState createState() => _YotsuyaPageState();
}

class _YotsuyaPageState extends State<YotsuyaPage> {
  String selectedDifficulty = 'ノーマル';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('四谷エリア'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'User01', // ユーザーネームの表示
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                decorationThickness: 3,
              ),
            ),
            SizedBox(height: 20),
            Text(
              '$selectedDifficulty 選択中',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/Map(5).png',
                  width: 150,
                  height: 150,
                ),
                SizedBox(width: 20),
                Column(
                  children: [
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedDifficulty = 'ノーマル';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedDifficulty == 'ノーマル'
                            ? Colors.blue
                            : Colors.grey,
                      ),
                      child: Text('ノーマル'),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NormalGameScreen(
                              startCountdown: true,
                            )));
                print('$selectedDifficulty でゲーム開始');
              },
              child: Text('スタート'),
            ),
          ],
        ),
      ),
    );
  }
}
