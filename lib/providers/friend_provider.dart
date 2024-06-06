// package imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//file imports
import '../api/firebase_auth_api.dart';
import '../models/friend_model.dart';
import '../api/firebase_friend_api.dart';

class FriendListProvider with ChangeNotifier {
  late FirebaseFriendAPI firebaseService;
  late FirebaseAuthAPI authService; //only for the updateUserProfile
  late Stream<QuerySnapshot> _friendsStream;
  late Stream<QuerySnapshot> _userDocsStream;
  List<String> notifications = [];

  Friend? toUpdateFriend; // friend to edit or delete

  FriendListProvider() {
    firebaseService = FirebaseFriendAPI();
    authService = FirebaseAuthAPI();
    _friendsStream = firebaseService.getAllFriends();
    _userDocsStream = firebaseService.getAllUsers();
    fetchFriends();
  }

  Stream<QuerySnapshot> get friendsStream => _friendsStream;
  Stream<QuerySnapshot> get userDocsStream => _userDocsStream;

  void fetchFriends() {
    _friendsStream = firebaseService.getAllFriends();
    notifyListeners();
  }

  void setCurrentUserUid(String uid) {
    notifyListeners();
  }

  Future<void> addFriendRequest(String userUid, String friendUid) async {
    try {
      await firebaseService.addFriendRequest(userUid, friendUid);
      // Fetch updated friend list
      fetchFriends();
    } catch (e) {
      print("Error adding friend request: $e");
    }
  }

  Future<void> unfriendFromList(String userUid, String friendUid) async {
    try {
      await firebaseService.unfriendFromList(userUid, friendUid);
      // Fetch updated friend list
      fetchFriends();
    } catch (e) {
      print("Error deleting friend from list: $e");
    }
  }

  Future<void> cancelSentRequestFromList(
      String userUid, String friendUid) async {
    try {
      await firebaseService.cancelSentRequestFromList(userUid, friendUid);
      // Fetch updated friend list
      fetchFriends();
    } catch (e) {
      print("Error deleting friend from list: $e");
    }
  }

  Future<void> acceptFriendRequestFromList(
      String userUid, String friendUid) async {
    try {
      await firebaseService.acceptFriendRequestFromList(userUid, friendUid);
      // Fetch updated friend list
      fetchFriends();
    } catch (e) {
      print("Error deleting friend from list: $e");
    }
  }

  Future<void> rejectFriendRequestFromList(
      String userUid, String friendUid) async {
    try {
      await firebaseService.rejectFriendRequestFromList(userUid, friendUid);
      // Fetch updated friend list
      fetchFriends();
    } catch (e) {
      print("Error deleting friend from list: $e");
    }
  }

  Stream<QuerySnapshot> getUserFriendsStream(String userUid) {
    return firebaseService.getUserFriendsStream(userUid);
  }

  Future<Map<String, dynamic>?> getUserData(String userUid) async {
    return await firebaseService.getUserData(userUid);
  }

  Future<void> updateUserProfile({
    required String userId,
    required String updatedFirstName,
    required String updatedLastName,
    required String updatedLocation,
    required String updatedUserName,
    required String updatedBirthDate,
    required String updatedBio,
    required String updatedDisplayName,
  }) async {
    try {
      await firebaseService.updateUserProfile(
        userId: userId,
        updatedFirstName: updatedFirstName,
        updatedLastName: updatedLastName,
        updatedLocation: updatedLocation,
        updatedUserName: updatedUserName,
        updatedBirthDate: updatedBirthDate,
        updatedBio: updatedBio,
        updatedDisplayName: updatedDisplayName,
      );

      // Update the display name in Firebase Authentication
      await authService.updateDisplayName(userId, updatedDisplayName);

      // Notify listeners or perform any other necessary actions
      notifyListeners();
    } catch (e) {
      print('Error updating user profile: $e');
    }
  }

  Stream<List<dynamic>> getNotificationsStream(String userUid) {
    if (userUid != null) {
      return firebaseService.getNotifications(userUid);
    }
    return Stream.empty();
  }

  Future<void> deleteNotification(String userUid, String notification) async {
    try {
      // Remove the notification from Firestore
      await firebaseService.deleteNotification(userUid, notification);

      // Remove the notification from the local list
      notifications.remove(notification);

      // Notify listeners to update the UI
      notifyListeners();
    } catch (e) {
      print("Error deleting notification: $e");
    }
  }

  Future<void> checkAndSendNotifications(String userUid) async {
    try {
      await firebaseService.checkAndSendNotifications(userUid);
    } catch (e) {
      print("Error checking and sending notifications: $e");
    }
  }
}
