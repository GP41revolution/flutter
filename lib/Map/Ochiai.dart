import 'package:flutter/material.dart';
import 'package:flutter_application_1/Game/EasyGame.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OchiaiPage(),
    );
  }
}

class OchiaiPage extends StatefulWidget {
  const OchiaiPage({Key? key}) : super(key: key);

  @override
  _OchiaiPageState createState() => _OchiaiPageState();
}

class _OchiaiPageState extends State<OchiaiPage> {
  String selectedDifficulty = 'イージー';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('落合エリア'),
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
                  'assets/Map(3).png',
                  width: 150,
                  height: 150,
                ),
                SizedBox(width: 20),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedDifficulty = 'イージー';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedDifficulty == 'イージー'
                            ? Colors.blue
                            : Colors.grey,
                      ),
                      child: Text('イージー'),
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
                        builder: (context) => EasyGameScreen(
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
