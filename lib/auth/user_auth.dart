import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } catch (e) {
      print("Sign Up Failed");
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } catch (e) {
      print("Login Failed");
    }
    return null;
  }

  Future<void> addUserDataToFirestore(
      String userId, String username, String email, String password) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        "uid": userId,
        'username': username,
        'email': email,
        'password': password,
      });
    } catch (e) {
      print("Error adding user data to Firestore: $e");
    }
  }
}
