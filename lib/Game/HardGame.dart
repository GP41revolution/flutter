import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/Rank.dart';

class HardGame extends StatefulWidget {
  final bool startCountdown;

  HardGame({Key? key, required this.startCountdown}) : super(key: key);
  @override
  _HardGame createState() => _HardGame();
}

class _HardGame extends State<HardGame> {
  int countdown = 3;
  int gameTime = 30;
  double progress = 1.0;
  Color backgroundColor = Colors.white;
  String selectedLight = '';
  List<PollutionImage> pollutionImages = [];
  Random random = Random();
  int score = 0;
  int maxPollutionImages = 4; //ばい菌が秒ごとに出る数
  bool debugMode = true; // デバッグモードを有効にするフラグ
  double debugAreaTopOffset = 100; // 生成エリアの上部オフセット
  double debugAreaHeight = 300; // 生成エリアの高さ
  double debugAreaWidth = 300; // 生成エリアの幅
  Timer? countdownTimer;
  Timer? gameTimer;

  @override
  void initState() {
    super.initState();
    if (widget.startCountdown) {
      startGameCountdown();
    }
  }

  void startGameCountdown() {
    setState(() {
      countdown = 3; // 初期値
    });

    countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) return; // mounted チェック
      setState(() {
        countdown--;
      });

      if (countdown == 0) {
        countdownTimer?.cancel();
        startGame();
      }
    });
  }

  void startGame() {
    setState(() {
      gameTime = 30; // ゲーム時間をリセット
      progress = 1.0; // 進捗バーをリセット
      score = 0; // スコアリセット
      pollutionImages = generatePollutionImages();
      backgroundColor = Colors.white;
    });

    final startTime = DateTime.now();

    gameTimer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      if (!mounted) {
        timer.cancel(); // ウィジェットが破棄されている場合はタイマーを停止
        return;
      }
      setState(() {
        final elapsed = DateTime.now().difference(startTime).inMilliseconds;
        final totalTime = gameTime * 1000; // ゲーム時間をミリ秒換算
        progress = 1.0 - (elapsed / totalTime);

        if (elapsed >= totalTime) {
          progress = 0.0;
          timer.cancel();
          showResults();
        }
      });
    });

    Timer.periodic(Duration(seconds: 1), (timer) {
      if (gameTime <= 0 || !mounted) {
        timer.cancel();
      } else {
        setState(() {
          // 残り時間が1秒を切った場合は生成しない
          if (gameTime > 1) {
            pollutionImages.addAll(generatePollutionImages());
          }
        });
      }

      if (gameTime <= 0) {
        timer.cancel();
        showResults();
      }
    });
  }

  List<PollutionImage> generatePollutionImages() {
    List<PollutionImage> images = [];
    for (int i = 0; i < maxPollutionImages; i++) {
      double top = 100 + random.nextDouble() * 300;
      double left = random.nextDouble() * 300;
      Color color = [Colors.red, Colors.blue, Colors.green][random.nextInt(3)];
      images.add(PollutionImage(
        key: UniqueKey(),
        color: color,
        onRemove: () {
          if (color == getSelectedColor()) {
            setState(() {
              score++;
              pollutionImages =
                  pollutionImages.where((image) => image != images[i]).toList();
            });
          }
        },
        top: top,
        left: left,
      ));
    }
    return images;
  }

  Color getSelectedColor() {
    switch (selectedLight) {
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      default:
        return Colors.white;
    }
  }

  // static final FirebaseFirestore db = FirebaseFirestore.instance;
  // static final CollectionReference User01 = db.collection('User01');

  // void addScoreData() async {
  //   await User01.add({'Easy': 'score'});
  // }

  void showResults() {
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
              scorePercentage: (score / maxPollutionImages) * 3.332),
        ),
      );
    }
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    gameTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text("ゲーム画面"),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          if (countdown > 0)
            Center(child: Text('$countdown', style: TextStyle(fontSize: 50))),
          if (countdown == 0) ...[
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: Container(
                height: 10, // 元の2倍の高さ
                child: LinearProgressIndicator(value: progress),
              ),
            ),
            Stack(children: pollutionImages.cast<Widget>()),
            Positioned(
              bottom: 30,
              left: 30,
              right: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  LightIcon(
                    imagePath: 'assets/red-light.png',
                    onTap: () => setState(() {
                      selectedLight = 'red';
                      backgroundColor =
                          const Color.fromARGB(255, 245, 179, 175);
                    }),
                  ),
                  LightIcon(
                    imagePath: 'assets/blue-light.png',
                    onTap: () => setState(() {
                      selectedLight = 'blue';
                      backgroundColor =
                          const Color.fromARGB(255, 177, 212, 242);
                    }),
                  ),
                  LightIcon(
                    imagePath: 'assets/green-light.png',
                    onTap: () => setState(() {
                      selectedLight = 'green';
                      backgroundColor =
                          const Color.fromARGB(255, 163, 230, 165);
                    }),
                  ),
                ],
              ),
            ),

            // デバッグボタンを追加
            // Positioned(
            //   top: 70,
            //   right: 20,
            //   child: ElevatedButton(
            //     onPressed: () {
            //       setState(() {
            //         int removedCount = pollutionImages.length; // 消去したばい菌の数を取得
            //         score += removedCount; // スコアに加算
            //         pollutionImages.clear(); // すべてのばい菌を消去
            //       });
            //     },
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: Colors.grey,
            //     ),
            //     child: Text(
            //       "デバッグ: 全消去",
            //       style: TextStyle(fontSize: 14),
            //     ),
            //   ),
            // ),
          ],
        ],
      ),
    );
  }
}

class PollutionImage extends StatelessWidget {
  final Color color;
  final VoidCallback onRemove;
  final double top;
  final double left;

  const PollutionImage({
    Key? key,
    required this.color,
    required this.onRemove,
    required this.top,
    required this.left,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String imagePath;
    if (color == Colors.red) {
      imagePath = 'assets/Enemy1.png';
    } else if (color == Colors.blue) {
      imagePath = 'assets/Enemy2.png';
    } else if (color == Colors.green) {
      imagePath = 'assets/Enemy3.png';
    } else {
      imagePath = '';
    }

    return Positioned(
      top: top,
      left: left,
      child: GestureDetector(
        onTap: onRemove,
        child: Image.asset(
          imagePath,
          width: 50,
          height: 50,
        ),
      ),
    );
  }
}

class LightIcon extends StatelessWidget {
  final String imagePath;
  final VoidCallback onTap;

  const LightIcon({Key? key, required this.imagePath, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        imagePath,
        width: 50,
        height: 50,
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final double scorePercentage;

  const ResultScreen({Key? key, required this.scorePercentage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("結果"),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("除去率: ${scorePercentage.toStringAsFixed(1)}%",
                style: TextStyle(fontSize: 30)),
            SizedBox(height: 20),
            TextButton(
              style: TextButton.styleFrom(
                fixedSize: const Size(180, 55),
                foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                backgroundColor: const Color.fromARGB(255, 167, 209, 244),
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RankPageScreens()));
              },
              child: Text('ランキング'),
            ),
            SizedBox(
              height: 10, //ボタンとの間に空白
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(180, 55), // サイズをランキングボタンと同じに
                foregroundColor: const Color.fromARGB(255, 0, 0, 0), // テキスト色
                backgroundColor:
                    const Color.fromARGB(255, 195, 213, 237), // 背景色
              ),
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Text('マップに戻る'),
            ),
          ],
        ),
      ),
    );
  }
}
