// package imports
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

//file imports
import '../api/firebase_auth_api.dart';

class AuthProvider with ChangeNotifier {
  late FirebaseAuthAPI authService;
  User? userObj;

  AuthProvider() {
    authService = FirebaseAuthAPI();
    authService.getUser().listen((User? newUser) {
      userObj = newUser;
      print('AuthProvider - FirebaseAuth - onAuthStateChanged - $newUser');
      notifyListeners();
    }, onError: (e) {
      print('AuthProvider - FirebaseAuth - onAuthStateChanged - $e');
    });
  }

  User? get user => userObj;

  bool get isAuthenticated {
    return user != null;
  }

  // void signIn(String email, String password) {
  //   return authService.signIn(email, password);
  // }

  Future<String> signIn(String email, String password) async {
    final message = await authService.signIn(email, password);
    return message;
  }

  void signOut() {
    authService.signOut();
  }

  Future<bool> signUp(
      String firstName,
      String lastName,
      String birthDate,
      String location,
      String email,
      String password,
      String displayName,
      String userName) async {
    try {
      await authService.signUp(firstName, lastName, birthDate, location, email,
          password, displayName, userName);
      return true; // Sign-up successful
    } catch (e) {
      print(e);
      return false; // Sign-up failed
    }
  }

  Future<void> updateDisplayName(String uid, String newDisplayName) async {
    try {
      await authService.updateDisplayName(uid, newDisplayName);
    } catch (e) {
      print('Error updating display name: $e');
    }
  }
}
