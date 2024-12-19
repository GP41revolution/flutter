import 'package:flutter/material.dart';
import 'package:flutter_application_1/Game/EasyGame.dart';
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
      home: KagurazakaPage(),
    );
  }
}

class KagurazakaPage extends StatefulWidget {
  const KagurazakaPage({Key? key}) : super(key: key);

  @override
  _KagurazakaPageState createState() => _KagurazakaPageState();
}

class _KagurazakaPageState extends State<KagurazakaPage> {
  String selectedDifficulty = 'イージー';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('神楽坂エリア', style: TextStyle(color: Color.fromARGB(255, 52, 152, 219))),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Color.fromARGB(255, 52, 152, 219),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
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
              style: TextStyle(fontSize: 16, color: const Color.fromARGB(255, 52, 152, 219)),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/Map(2).png',
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
                  'assets/easy_enemy_red.png',
                  width: 50,
                  height: 50,
                ),
                SizedBox(width: 20),
                Image.asset(
                  'assets/easy_enemy_blue.png',
                  width: 50,
                  height: 50,
                ),
                SizedBox(width: 20),
                Image.asset(
                  'assets/easy_enemy_green.png',
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
                        builder: (context) => EasyGameScreen(
                              startCountdown: true,
                            )));
                print('$selectedDifficulty でゲーム開始');
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 52, 152, 219), // テキストを青に
                backgroundColor: Colors.white, // 背景を白に
                side: BorderSide(color: Color.fromARGB(255, 52, 152, 219), width: 2), // 枠線を青に
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // 角を丸くする
                ),
              ),
              child: Text('スタート'),
            ),
          ],
        ),
      ),
    );
  }
}
