import 'package:flutter/material.dart';
import 'package:flutter_application_1/Map/Kagurazaka.dart';
import 'package:flutter_application_1/Map/Ochiai.dart';
import 'package:flutter_application_1/Map/Shinjuku.dart';
import 'package:flutter_application_1/Map/Takada.dart';
import 'package:flutter_application_1/Map/Yotsuya.dart';
import 'package:flutter_application_1/manual/manual.dart';

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
        title: Text('マップ'),
        backgroundColor: Color.fromARGB(255, 192, 208, 237),
      ),
      body: Stack(
        children: [
          // 背景画像を設定
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/splash_image.jpg'), // 背景画像のパス
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
                      color: const Color.fromARGB(255, 165, 246, 249),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.blue),
                    ),
                    child: Text(
                      '新宿区',
                      style: TextStyle(fontSize: 44),
                    ),
                  ),
                  Positioned(
                    left: 90,
                    top: 183,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ShinjukuPage()));
                      },
                      child: Image.asset(
                        'assets/Map(1).png',
                        width: 120,
                        height: 120,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 186,
                    top: 92,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => KagurazakaPage()));
                      },
                      child: Image.asset(
                        'assets/Map(2).png',
                        width: 160,
                        height: 120,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 10,
                    top: 102,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OchiaiPage()));
                      },
                      child: Image.asset(
                        'assets/Map(3).png',
                        width: 150,
                        height: 100,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 114,
                    top: 118,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TakadaPage()));
                      },
                      child: Image.asset(
                        'assets/Map(4).png',
                        width: 150,
                        height: 120,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 186,
                    top: 200,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => YotsuyaPage()));
                      },
                      child: Image.asset(
                        'assets/Map(5).png',
                        width: 120,
                        height: 100,
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
