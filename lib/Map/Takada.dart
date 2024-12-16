import 'package:flutter/material.dart';
import 'package:flutter_application_1/Game/HardGame.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/user_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(), // UserProviderを提供
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TakadaPage(),
    );
  }
}

class TakadaPage extends StatefulWidget {
  const TakadaPage({Key? key}) : super(key: key);

  @override
  _TakadaPageState createState() => _TakadaPageState();
}

class _TakadaPageState extends State<TakadaPage> {
  String selectedDifficulty = 'ハード';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('高田馬場エリア',style: TextStyle(color: Color.fromARGB(255, 52, 152, 219)),),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ユーザー名をProviderから取得して表示
            Consumer<UserProvider>(
              builder: (context, userProvider, child) {
                return Text(
                  userProvider.username, // ユーザー名を表示
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    decorationThickness: 3,
                  ),
                );
              },
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
                  'assets/Map(4).png',
                  width: 150,
                  height: 150,
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/hard_enemy_red.png',
                  width: 50,
                  height: 50,
                ),
                SizedBox(width: 20),
                Image.asset(
                  'assets/hard_enemy_blue.png',
                  width: 50,
                  height: 50,
                ),
                SizedBox(width: 20),
                Image.asset(
                  'assets/hard_enemy_green.png',
                  width: 50,
                  height: 50,
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HardGame(startCountdown: true)));
                print('$selectedDifficulty でゲーム開始');
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 52, 152, 219),
              ),
              child: Text('スタート'),
            ),
          ],
        ),
      ),
    );
  }
}
