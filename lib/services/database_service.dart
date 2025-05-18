import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance; // ✅ التعريف الناقص

  Future<void> saveUserData({
    required String uid,
    required String name,
    required String email,
    required String phone,
    required String governorate,
    String password = '', // ✅ اختيارية
  }) async {
    await _db.collection('users').doc(uid).set({
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'governorate': governorate,
      'password': password,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<DocumentSnapshot> getUserData() async {
    User? user = _auth.currentUser; // ✅ أصبح معرفًا الآن
    if (user != null) {
      return await _db.collection('users').doc(user.uid).get();
    } else {
      throw Exception('No user logged in');
    }
  }
}
