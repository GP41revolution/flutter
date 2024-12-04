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
  String headerText = "ランキング";

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
            headerText = "イージー ランキング";
            break;
          case 1:
            headerText = "ノーマル ランキング";
            break;
          case 2:
            headerText = "ハード ランキング";
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
          title: Text('ランキング一覧 '),
          backgroundColor: const Color.fromARGB(255, 192, 208, 237),
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'イージー'),
              Tab(text: 'ノーマル'),
              Tab(text: 'ハード'),
            ],
          ),
        ),
        body: Column(
          children: [
            // 大きいランキングヘッダー
            Container(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              color: Colors.orangeAccent,
              child: Center(
                child: Text(
                  headerText,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
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
        backgroundColor: const Color.fromARGB(255, 218, 219, 211),
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
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.deepPurple[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: index == 0
                      ? Icon(Icons.emoji_events, color: Colors.amber, size: 30)
                      : CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Text(
                            "${index + 1}",
                            style:
                                TextStyle(fontSize: 20, color: Colors.deepPurple),
                          ),
                        ),
                  title: Text(
                    rankData[index]["username"],
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  trailing: Text(
                    "${rankData[index]["score"]}%",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
          );
  }
}
