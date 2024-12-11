import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RankPageScreens(),
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
  String headerText = "RANKING";

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
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'イージー'),
              Tab(text: 'ノーマル'),
              Tab(text: 'ハード'),
            ],
            labelColor: const Color.fromARGB(255, 52, 152, 219), // 選択されたタブのテキストカラー
            unselectedLabelColor: const Color.fromARGB(255, 52, 152, 219), // 選択されていないタブのテキストカラー
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
                      // 白い縁取りのテキスト
                      Text(
                        headerText,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // 白い縁
                          shadows: [
                            Shadow(
                              blurRadius: 0.0, // 縁取りのためのぼかしを無効に
                              color: Colors.white, // 白い縁取り
                              offset: Offset(1, 1), // 縁取りの位置
                            ),
                            Shadow(
                              blurRadius: 0.0,
                              color: Colors.white,
                              offset: Offset(-1, -1),
                            ),
                            Shadow(
                              blurRadius: 0.0,
                              color: Colors.white,
                              offset: Offset(1, -1),
                            ),
                            Shadow(
                              blurRadius: 0.0,
                              color: Colors.white,
                              offset: Offset(-1, 1),
                            ),
                          ],
                        ),
                      ),
                      // 元のテキスト
                      Text(
                        headerText,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 20, 144, 226), // 元の色
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
        ? Center(child: Text("データがありません"))
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
                          colors: [Colors.orange, Colors.amber, Colors.orange], // 金色のグラデーション
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : index == 1
                          ? LinearGradient(
                              colors: [Colors.grey, Colors.white, Colors.grey], // 銀色のグラデーション
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : index == 2
                              ? LinearGradient(
                                  colors: [Colors.brown, Colors.orange, Colors.brown], // 銅色のグラデーション
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
                    color: const Color.fromARGB(255, 52, 152, 219), // 枠線の色を指定
                    width: 2, // 枠線の太さを指定
                  ),
                ),
                child: ListTile(
                  leading: _buildLeadingIcon(index),
                  title: Text(
                    rankData[index]["username"],
                    style: TextStyle(
                        color: const Color.fromARGB(255, 52, 152, 219), fontWeight: FontWeight.bold),
                  ),
                  trailing: Text(
                    "${rankData[index]["score"]}%",
                    style: TextStyle(
                        fontSize: 15, color: const Color.fromARGB(255, 52, 152, 219), fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
          );
  }

  Widget _buildLeadingIcon(int index) {
    if (index == 0) {
      // 金のトロフィー
      return Icon(Icons.emoji_events, color: Colors.amber, size: 30);
    } else if (index == 1) {
      // 銀のトロフィー
      return Icon(Icons.emoji_events, color: Colors.grey, size: 30);
    } else if (index == 2) {
      // 銅のトロフィー
      return Icon(Icons.emoji_events, color: Colors.brown, size: 30);
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
