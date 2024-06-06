// package imports
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//file imports

class FirebaseAuthAPI {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<User?> getUser() {
    return auth.authStateChanges().asyncMap((user) async {
      if (user != null) {
        final userDoc = await db.collection("users").doc(user.uid).get();
        if (userDoc.exists) {
          final userData = userDoc.data();
          final newDisplayName = userData?['displayName'] as String?;
          if (newDisplayName != null) {
            await user.updateDisplayName(newDisplayName);
          }
        }
      }
      return user;
    });
  }

  // void signIn(String email, String password) async {
  //   UserCredential credential;
  //   try {
  //     final credential = await auth.signInWithEmailAndPassword(
  //         email: email, password: password);
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'user-not-found') {
  //       //possible to return something more useful than just print an error message to improve UI/UX
  //       print('No user found for that email.');
  //     } else if (e.code == 'wrong-password') {
  //       print('Wrong password provided for that user.');
  //     }
  //   }
  // }

  Future<String> signIn(String email, String password) async {
    try {
      final credential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return 'Authentication successful';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else {
        return 'An error occurred: $e';
      }
    }
  }

  void signOut() async {
    Timer(const Duration(seconds: 3), () {
      auth.signOut();
    });
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
      final credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        final String fullName = '$firstName $lastName';
        await saveUserToFirestore(
          credential.user!.uid,
          firstName,
          lastName,
          birthDate,
          location,
          email,
          password,
          fullName,
          userName,
        );
        return true; // Sign-up successful
      } else {
        return false; // Sign-up failed
      }
    } catch (e) {
      print(e);
      return false; // Sign-up failed
    }
  }

  Future<void> saveUserToFirestore(
      String? uid,
      String firstName,
      String lastName,
      String birthDate,
      String location,
      String email,
      String password,
      String fullName,
      String userName) async {
    try {
      await db.collection("users").doc(uid).set({
        "firstName": firstName,
        "lastName": lastName,
        "location": location,
        "birthDate": birthDate,
        "email": email,
        "displayName": fullName,
        "userName": userName,
        "bio": "No bio yet.",
        "friends": [], // Initial empty array
        "sentFriendRequest": [], // Initial empty array
        "receivedFriendRequest": [], // Initial empty array
        "status": true, // Initial value
        "tasks": [], // Initial empty array
        "notifications": [] // Initial empty array
      });
    } catch (e) {
      print(e);
    }
  }

  // When user updates profile, not only the fields in the firestore
  // should be updated, but also the displayName from the authentication.
  Future<void> updateDisplayName(String uid, String newDisplayName) async {
    try {
      await auth.currentUser?.updateDisplayName(newDisplayName);
    } catch (e) {
      print('Error updating display name: $e');
    }
  }
}
