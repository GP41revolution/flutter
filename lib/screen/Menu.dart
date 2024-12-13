import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_application_1/manual/Menu_manual.dart';
import 'package:flutter_application_1/src/app.dart';

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
    const url = 'https://pensuke.web.app/';
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
        title: Text('Menu',style: TextStyle(color: Color.fromARGB(255, 52, 152, 219)),),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            child: ListTile(
              title: Text(
                'サポート',
                style: TextStyle(color: Color.fromARGB(255, 52, 152, 219), fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => IntroPage()));
            },
            child: ListTile(
              title: Text('遊び方マニュアル',style: TextStyle(color: Color.fromARGB(255, 52, 152, 219)),),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ),
          InkWell(
            onTap: _launchWebPage,
            child: ListTile(
              title: Text('ブラウザ版ページ表示',style: TextStyle(color: Color.fromARGB(255, 52, 152, 219)),),
              trailing: Icon(Icons.open_in_browser),
            ),
          ),
          InkWell(
            onTap: _launchGoogleForm,
            child: ListTile(
              title: Text('お問い合わせ (Google Form)',style: TextStyle(color: Color.fromARGB(255, 52, 152, 219)),),
              trailing: Icon(Icons.open_in_browser),
            ),
          ),
          // Logout button
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  // Navigate back to the WelcomeScreen
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => const WelcomeScreen()),
                    (Route<dynamic> route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'ログアウト',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Text('AquaGuardian',style: TextStyle(color: Color.fromARGB(255, 52, 152, 219)),),
          ),
        ],
      ),
    );
  }
}
