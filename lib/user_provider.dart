import 'package:flutter/material.dart';
import 'package:flutter_application_1/manual/Start_manual.dart';

class UserProvider with ChangeNotifier {
  String _username = 'player01';

  // usernameのゲッター
  String get username => _username;

  // usernameのセッター
  void setUsername(String newUsername) {
    _username = newUsername;
    notifyListeners();  // 更新通知
  }
}
