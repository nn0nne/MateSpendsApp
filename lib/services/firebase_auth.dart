import 'package:matespendsapp/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:matespendsapp/pages/auth/signin_page.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  User? get user => _user;

  AuthService() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  bool get isLoggedIn => _user != null;

  Future<bool> signIn(
      String email, String password, BuildContext context) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      // Restart app to reflect changes in auth state
      _restartApp(context);
      return true;
    } catch (e) {
      throw Exception('Sign-in failed: ${e.toString()}');
    }
  }

  Future<void> signUp(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String userId = userCredential.user!.uid;
      String username = email.split('@')[0];

      await FirebaseFirestore.instance.collection('Users').doc(userId).set({
        'email': email,
        'username': username,
        // 'createdAt': FieldValue.serverTimestamp(),
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignIn()),
      );
      // Restart app to reflect changes in auth state
      //_restartApp(context);
    } catch (e) {
      print('Error during sign up: $e');
    }
  }

  Future<void> signOut(BuildContext context) async {
    await _auth.signOut();
    _user = null; // Reset user
    notifyListeners(); // Notify listeners
    // Restart app to reflect changes in auth state
    _restartApp(context);
  }

  void _restartApp(BuildContext context) {
    RestartWidget.restartApp(context); // Trigger app restart
  }
}
