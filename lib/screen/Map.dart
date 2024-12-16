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
                    left: 112,
                    top: 205,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ShinjukuPage()));
                      },
                      child: Image.asset(
                        'assets/Map(1).png', //新宿
                        width: 99,
                        height: 142,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 219,
                    top: 122,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => KagurazakaPage()));
                      },
                      child: Image.asset(
                        'assets/Map(2).png', //神楽坂
                        width: 126,
                        height: 117,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    top: 128,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OchiaiPage()));
                      },
                      child: Image.asset(
                        'assets/Map(3).png', //落合
                        width: 149,
                        height: 102,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 120,
                    top: 142,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TakadaPage()));
                      },
                      child: Image.asset(
                        'assets/Map(4).png', //高田馬場
                        width: 156,
                        height: 130,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 195,
                    top: 231,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => YotsuyaPage()));
                      },
                      child: Image.asset(
                        'assets/Map(5).png', //四谷
                        width: 145,
                        height: 112,
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
