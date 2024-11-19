import 'package:flutter/material.dart';
import 'package:flutter_application_1/Game/Game.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ShinjukuPage(),
    );
  }
}

class ShinjukuPage extends StatefulWidget {
  const ShinjukuPage({Key? key}) : super(key: key);

  @override
  _ShinjukuPageState createState() => _ShinjukuPageState();
}

class _ShinjukuPageState extends State<ShinjukuPage> {
  String selectedDifficulty = 'ハード';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('新宿エリア'),
        backgroundColor: Color.fromARGB(255, 192, 208, 237),
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
                  'assets/Map(1).png',
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
                          selectedDifficulty = 'ハード';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedDifficulty == 'ハード'
                            ? Colors.blue
                            : Colors.grey,
                      ),
                      child: Text(' ハード '),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // スタートボタンが押されたときに、3秒カウントダウンを開始してゲーム画面に遷移
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TimeTrialScreen(startCountdown: true),
                  ),
                );
              },
              child: Text('スタート'),
            ),
          ],
        ),
      ),
    );
  }
}
