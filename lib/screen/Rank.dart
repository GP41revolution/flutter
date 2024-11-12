import 'package:flutter/material.dart';

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
  final List<Map<String, dynamic>> rankData = [
    {"username": "User01", "score": 9564},
    {"username": "User02", "score": 8564},
    {"username": "User03", "score": 5564},
    {"username": "User04", "score": 4564},
    {"username": "User05", "score": 3564},
    {"username": "User06", "score": 1564},
  ];

  late TabController _tabController;
  String headerText = "ランキング";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // 難易度ごとのランキング名
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

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    rankData.sort((a, b) => b['score'].compareTo(a['score']));

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Ranking'),
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
            //でかいランキングヘッダー
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
                  RankList(rankData: rankData),
                  RankList(rankData: rankData),
                  RankList(rankData: rankData),
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
    return ListView.builder(
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
                      style: TextStyle(fontSize: 20, color: Colors.deepPurple),
                    ),
                  ),
            title: Text(
              rankData[index]["username"],
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            trailing: Text(
              "${rankData[index]["score"]}",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }
}
