import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/Rank.dart';

class TimeTrialScreen extends StatefulWidget {
  @override
  _TimeTrialScreenState createState() => _TimeTrialScreenState();
}

class _TimeTrialScreenState extends State<TimeTrialScreen> {
  int countdown = 2;
  int gameTime = 30;
  double progress = 1.0;
  Color backgroundColor = Colors.white;
  String selectedLight = '';
  List<PollutionImage> pollutionImages = [];
  Random random = Random();
  int score = 0;
  int maxPollutionImages = 4; //細菌が秒ごとに増える数の値(1個)

  Timer? countdownTimer;
  Timer? gameTimer;

  void startGame() {
    setState(() {
      countdown = 2;
      progress = 1.0;
      score = 0;
      pollutionImages = generatePollutionImages();
      backgroundColor = Colors.white;
    });

    countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          countdown--;
        });
      }

      if (countdown == 0) {
        countdownTimer?.cancel();
        startTimer();
      }
    });
  }

  void startTimer() {
    gameTimer = Timer.periodic(Duration(seconds: 2), (timer) {
      // インターバルを2秒に変更
      if (mounted) {
        setState(() {
          gameTime--;
          progress = gameTime / 30;
          pollutionImages.addAll(generatePollutionImages()); // 2秒ごとに新しい細菌を追加
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
      double top = random.nextDouble() * 300;
      double left = random.nextDouble() * 400;
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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ResultScreen(scorePercentage: (score / maxPollutionImages) * 2.5),
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
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(title: Text("")),
      body: Stack(
        children: [
          if (countdown > 0)
            Center(child: Text('$countdown', style: TextStyle(fontSize: 50))),
          if (countdown == 0) ...[
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: LinearProgressIndicator(value: progress),
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
                    imagePath: 'assets/red-right.png',
                    onTap: () => setState(() {
                      selectedLight = 'red';
                      backgroundColor = Colors.red.withOpacity(0.3);
                    }),
                  ),
                  LightIcon(
                    imagePath: 'assets/blue-right.png',
                    onTap: () => setState(() {
                      selectedLight = 'blue';
                      backgroundColor = Colors.blue.withOpacity(0.3);
                    }),
                  ),
                  LightIcon(
                    imagePath: 'assets/green-right.png',
                    onTap: () => setState(() {
                      selectedLight = 'green';
                      backgroundColor = Colors.green.withOpacity(0.3);
                    }),
                  ),
                ],
              ),
            ),
          ],
          if (countdown > 0)
            Center(
              child: ElevatedButton(
                onPressed: startGame,
                child: Text("スタート"), //これいらないかもaaaaaas
              ),
            ),
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
      imagePath = ''; //imagePathの空白を入れておかないとエラーが出る。
    }

    return Positioned(
      top: top,
      left: left,
      child: GestureDetector(
        onTap: () {
          if (color ==
              context
                  .findAncestorStateOfType<_TimeTrialScreenState>()
                  ?.getSelectedColor()) {
            onRemove();
          }
        },
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
      appBar: AppBar(title: Text("結果")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("除去率: ${scorePercentage.toStringAsFixed(1)}%",
                style: TextStyle(fontSize: 30)),
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(
                    context,
                    (route) => route
                        .isFirst); // This goes back to the first screen in the stack.
              },
              child: Text('マップに戻る'),
            ),
          ],
        ),
      ),
    );
  }
}
