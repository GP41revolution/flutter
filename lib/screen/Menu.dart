import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_application_1/manual/manual.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MenuPageScreens(),
    );
  }
}

class MenuPageScreens extends StatelessWidget {
  const MenuPageScreens({Key? key}) : super(key: key);

  // Googleフォームを開くための関数
  void _launchGoogleForm() async {
    const url =
        'https://docs.google.com/forms/d/e/1FAIpQLSd8uoWHwwP1DK--wHNWhJver8TZDpwry0hYfBJxay1hvxzFXg/viewform';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _launchWebPage() async {
    const url = 'http://localhost/revo/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
        backgroundColor: Color.fromARGB(255, 192, 208, 237),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            child: ListTile(
              title: Text(
                'サポート',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ManualPage()));
            },
            child: ListTile(
              title: Text('遊び方マニュアル'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ),
          InkWell(
            onTap: _launchWebPage,
            child: ListTile(
              title: Text('ブラウザ版ページ表示'),
              trailing: Icon(Icons.open_in_browser),
            ),
          ),
          InkWell(
            onTap: _launchGoogleForm,
            child: ListTile(
              title: Text('お問い合わせ (Google Form)'),
              trailing: Icon(Icons.open_in_browser),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Text('AquaGuardian'),
          ),
        ],
      ),
    );
  }
}
