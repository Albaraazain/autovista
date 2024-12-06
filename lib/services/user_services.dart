import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registerUser(String name, String email, String location) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'name': name,
        'email': email,
        'location': location,
        'createdAt': DateTime.now(),
      });
    }
  }

  Future<Map<String, dynamic>> getUserData(String uid) async {
    DocumentSnapshot snapshot = await _firestore.collection('users').doc(uid).get();
    return snapshot.data() as Map<String, dynamic>;
  }
}
