import 'package:flutter/material.dart';
import 'package:flutter_application_1/Map/Kagurazaka.dart';
import 'package:flutter_application_1/Map/Ochiai.dart';
import 'package:flutter_application_1/Map/Shinjuku.dart';
import 'package:flutter_application_1/Map/Takada.dart';
import 'package:flutter_application_1/Map/Yotsuya.dart';
import 'package:flutter_application_1/manual/Menu_manual.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MapPageScreens(),
    );
  }
}

class MapPageScreens extends StatelessWidget {
  const MapPageScreens({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ゲーム',
          style: TextStyle(color: Color.fromARGB(255, 52, 152, 219)),
        ),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      body: Stack(
        children: [
          // 背景画像を設定
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/rank_back.jpg'), // 背景画像のパス
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: SizedBox(
              width: 380,
              height: 388,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Color.fromARGB(255, 52, 152, 219),
                        width: 2,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Text(
                      '新宿区',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 52, 152, 219),
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 89,
                    top: 196,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ShinjukuPage()));
                      },
                      child: Image.asset(
                        'assets/Map(1).png', //新宿
                        width: 140,
                        height: 140,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 215,
                    top: 111,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => KagurazakaPage()));
                      },
                      child: Image.asset(
                        'assets/Map(2).png', //神楽坂
                        width: 121,
                        height: 121,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 19,
                    top: 119,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OchiaiPage()));
                      },
                      child: Image.asset(
                        'assets/Map(3).png', //落合
                        width: 150,
                        height: 103,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 120,
                    top: 122,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TakadaPage()));
                      },
                      child: Image.asset(
                        'assets/Map(4).png', //高田馬場
                        width: 150,
                        height: 150,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 194,
                    top: 199,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => YotsuyaPage()));
                      },
                      child: Image.asset(
                        'assets/Map(5).png', //四谷
                        width: 135,
                        height: 150,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
