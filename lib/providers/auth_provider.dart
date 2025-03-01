import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  AuthProvider() {
    _auth.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  User? get user => _user;
  bool get isAuthenticated => _user != null;

  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> signup(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw 'Failed to send password reset email. Please try again.';
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      notifyListeners();
    } catch (e) {
      throw 'Logout failed. Please try again.';
    }
  }

  Future<void> updateProfile(String name) async {
    try {
      await _auth.currentUser!.updateDisplayName(name);
      notifyListeners();
    } catch (e) {
      throw 'Failed to update profile. Please try again.';
    }
  }
}
