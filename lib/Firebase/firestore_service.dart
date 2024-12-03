import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveUserData(String username, String? imagePath) async {
    try {
      await _firestore.collection('users').add({
        'username': username,
        'imagePath': imagePath,
        'createdAt': FieldValue.serverTimestamp(),
      });
      print('ユーザー情報が保存されました');
    } catch (e) {
      print('エラー: $e');
      throw Exception('データの保存中にエラーが発生しました');
    }
  }
}
