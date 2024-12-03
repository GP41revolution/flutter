import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore のインポート
import 'package:flutter_application_1/Game/Game.dart';
import 'package:flutter_application_1/screen/Rank.dart';

class EasyGameScreen extends StatefulWidget {
  final bool startCountdown;

  EasyGameScreen({Key? key, required this.startCountdown}) : super(key: key);

  @override
  _EasyGameScreenState createState() => _EasyGameScreenState();
}

class _EasyGameScreenState extends State<EasyGameScreen> {
  int countdown = 3;
  int gameTime = 30;
  double progress = 1.0;
  Color backgroundColor = Colors.white;
  String selectedLight = '';
  List<PollutionImage> pollutionImages = [];
  Random random = Random();
  int score = 0;
  int maxPollutionImages = 1;

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
      if (!mounted) return;
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
        timer.cancel();
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
          pollutionImages.addAll(generatePollutionImages());
        });
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

  void showResults() {
    if (mounted) {
      saveResultToFirestore(); // Firestore に結果を保存
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ResultScreen(scorePercentage: (score / maxPollutionImages) * 4.9),
        ),
      );
    }
  }

  Future<void> saveResultToFirestore() async {
    final firestore = FirebaseFirestore.instance;

    try {
      await firestore.collection('easy').add({
        'score': score,
        'timestamp': DateTime.now(),
      });
      print("Game result saved to Firestore.");
    } catch (e) {
      print("Error saving game result: $e");
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
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text("ゲーム画面"),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          if (countdown > 0)
            Center(
              child: Text(
                '$countdown',
                style: TextStyle(fontSize: 50),
              ),
            ),
          if (countdown == 0) ...[
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: Container(
                height: 10,
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
