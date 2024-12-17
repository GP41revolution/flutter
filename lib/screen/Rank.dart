import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: Color.fromARGB(255, 52, 152, 219)),
          foregroundColor: Color.fromARGB(255, 52, 152, 219),
        ),
      ),
    );
  }
}

class RankPageScreens extends StatefulWidget {
  @override
  _RankPageScreensState createState() => _RankPageScreensState();
}

class _RankPageScreensState extends State<RankPageScreens>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String headerText = "EASY RANKING";

  // 各難易度のランキングデータ
  List<Map<String, dynamic>> easyRankData = [];
  List<Map<String, dynamic>> normalRankData = [];
  List<Map<String, dynamic>> hardRankData = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Firestoreからデータを取得
    fetchRankData();

    // タブ変更時にヘッダーを更新
    _tabController.addListener(() {
      setState(() {
        switch (_tabController.index) {
          case 0:
            headerText = "EASY RANKING";
            break;
          case 1:
            headerText = "NORMAL RANKING";
            break;
          case 2:
            headerText = "HARD RANKING";
            break;
        }
      });
    });
  }

  Future<void> fetchRankData() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // 各難易度ごとのデータを取得
      var easySnapshot = await firestore.collection('easy').get();
      var normalSnapshot = await firestore.collection('normal').get();
      var hardSnapshot = await firestore.collection('hard').get();

      // データをリストに格納
      setState(() {
        easyRankData = easySnapshot.docs.map((doc) {
          return {
            'username': doc['username'],
            'score': double.tryParse(doc['score'].toString()) ?? 0.0, // 数値に変換
          };
        }).toList();

        normalRankData = normalSnapshot.docs.map((doc) {
          return {
            'username': doc['username'],
            'score': double.tryParse(doc['score'].toString()) ?? 0.0, // 数値に変換
          };
        }).toList();

        hardRankData = hardSnapshot.docs.map((doc) {
          return {
            'username': doc['username'],
            'score': double.tryParse(doc['score'].toString()) ?? 0.0, // 数値に変換
          };
        }).toList();

        // 各リストをスコア順にソート
        easyRankData.sort((a, b) => b['score'].compareTo(a['score']));
        normalRankData.sort((a, b) => b['score'].compareTo(a['score']));
        hardRankData.sort((a, b) => b['score'].compareTo(a['score']));
      });
    } catch (e) {
      print('Error fetching rank data: $e');
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'ランキング一覧',
            style: TextStyle(
              color: const Color.fromARGB(255, 52, 152, 219), // タイトルのテキストカラーを指定
            ),
          ),
          iconTheme: IconThemeData(
            color: Color.fromARGB(255, 52, 152, 219), // 矢印を青に設定
          ),
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'イージー'),
              Tab(text: 'ノーマル'),
              Tab(text: 'ハード'),
            ],
            labelColor: const Color.fromARGB(255, 52, 152, 219),
            unselectedLabelColor: const Color.fromARGB(255, 52, 152, 219),
            indicatorColor: const Color.fromARGB(255, 52, 152, 219),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/rank_back.jpg'), // 背景画像を指定
              fit: BoxFit.cover, // 画面全体に画像をフィットさせる
            ),
          ),
          child: Column(
            children: [
              // 大きいランキングヘッダー
              Container(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        headerText,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 255, 255, 255),
                          shadows: [
                            Shadow(
                              blurRadius: 20.0,
                              color: const Color.fromARGB(255, 52, 152, 219).withOpacity(0.8),
                              offset: Offset(0, 0),
                            ),
                            Shadow(
                              blurRadius: 30.0,
                              color: const Color.fromARGB(255, 52, 152, 219).withOpacity(0.5),
                              offset: Offset(0, 0),
                            ),
                            Shadow(
                              blurRadius: 40.0,
                              color: const Color.fromARGB(255, 52, 152, 219).withOpacity(0.3),
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // ランキングリスト
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    RankList(rankData: easyRankData),
                    RankList(rankData: normalRankData),
                    RankList(rankData: hardRankData),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RankList extends StatelessWidget {
  final List<Map<String, dynamic>> rankData;

  RankList({required this.rankData});

  @override
  Widget build(BuildContext context) {
    return rankData.isEmpty
        ? Center(
        child: Text("データがありません",style: TextStyle(color: Color.fromARGB(255, 52, 152, 219))))
        : ListView.builder(
            itemCount: rankData.length,
            itemBuilder: (context, index) {
              // グラデーションの背景を順位に応じて設定
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  // 順位によって異なるグラデーションを設定
                  gradient: index == 0
                      ? LinearGradient(
                          colors: [const Color(0xFF6e5101), const Color(0xFF6e5101), Colors.amber, Colors.amber, const Color(0xFF6e5101)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : index == 1
                          ? LinearGradient(
                              colors: [const Color(0xFF485763), const Color(0xFF485763), const Color(0xFFAFAFAF), const Color(0xFFAFAFAF), const Color(0xFF485763)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : index == 2
                              ? LinearGradient(
                                  colors: [const Color(0xFF743107), const Color(0xFF743107), Colors.orange, Colors.orange, const Color(0xFF743107)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : LinearGradient(
                                  colors: [Colors.white, Colors.white], // 通常順位の背景
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: index < 3
                          ? const Color.fromARGB(255, 30, 30, 30)
                          : const Color.fromARGB(255, 52, 152, 219),
                    width: 2, // 枠線の太さを指定
                  ),
                ),
                child: ListTile(
                  leading: _buildLeadingIcon(index),
                  title: Text(
                    rankData[index]["username"],
                    style: TextStyle(
                      color: index < 3 // 1〜3位の場合は白、それ以外は青
                          ? Colors.white
                          : const Color.fromARGB(255, 52, 152, 219),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Text(
                    "${rankData[index]["score"]}%",
                    style: TextStyle(
                      fontSize: 20,
                      color: index < 3 // 1〜3位の場合は白、それ以外は青
                          ? Colors.white
                          : const Color.fromARGB(255, 52, 152, 219),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          );
  }

  Widget _buildLeadingIcon(int index) {
    if (index == 0) {
      // 金のトロフィー画像
      return Image.asset(
        'assets/gold_medal.png', // 金のトロフィー画像のパス
        width: 40,
        height: 40,
      );
    } else if (index == 1) {
      // 銀のトロフィー画像
      return Image.asset(
        'assets/silver_medal.png', // 銀のトロフィー画像のパス
        width: 40,
        height: 40,
      );
    } else if (index == 2) {
      // 銅のトロフィー画像
      return Image.asset(
        'assets/bronze_medal.png', // 銅のトロフィー画像のパス
        width: 40,
        height: 40,
      );
    } else {
      // 通常の順位アイコン
      return CircleAvatar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        child: Text(
          "${index + 1}",
          style: TextStyle(
            fontSize: 20,
            color: const Color.fromARGB(255, 52, 152, 219),
          ),
        ),
      );
    }
  }
}
