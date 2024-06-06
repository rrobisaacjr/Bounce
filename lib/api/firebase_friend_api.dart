import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FirebaseFriendAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> addFriendRequest(String userUid, String friendUid) async {
    try {
      final currentDate = DateTime.now();

      // Get the current user's firstName
      final currentUserSnapshot =
          await db.collection("users").doc(userUid).get();
      final currentUserData = currentUserSnapshot.data();
      final currentUserFirstName = currentUserData?['firstName'];

      // Create the notification with the current user's firstName
      final notification =
          "[$currentDate] $currentUserFirstName sent you a friend request";

      // Add the friend to the current user's sentFriendRequest array
      await db.collection("users").doc(userUid).update({
        "sentFriendRequest":
            FieldValue.arrayUnion([db.doc("users/$friendUid")]),
      });

      // Add the current user to the friend's receivedFriendRequest array and notification
      await db.collection("users").doc(friendUid).update({
        "receivedFriendRequest":
            FieldValue.arrayUnion([db.doc("users/$userUid")]),
        "notifications": FieldValue.arrayUnion([notification]),
      });
    } catch (e) {
      print("Error adding friend request: $e");
    }
  }

  Future<void> unfriendFromList(String userUid, String friendUid) async {
    try {
      // Delete the friend from the current user's friends array
      await db.collection("users").doc(userUid).update({
        "friends": FieldValue.arrayRemove([db.doc("users/$friendUid")]),
      });

      // Delete the current user from the friend's friends array
      await db.collection("users").doc(friendUid).update({
        "friends": FieldValue.arrayRemove([db.doc("users/$userUid")]),
      });
    } catch (e) {
      print("Error unfriending friend reference: $e");
    }
  }

  Future<void> cancelSentRequestFromList(
      String userUid, String friendUid) async {
    try {
      // Delete the friend from the current user's sentFriendRequest array
      await db.collection("users").doc(userUid).update({
        "sentFriendRequest":
            FieldValue.arrayRemove([db.doc("users/$friendUid")]),
      });

      // Delete the current user from the friend's receivedFriendRequest array
      await db.collection("users").doc(friendUid).update({
        "receivedFriendRequest":
            FieldValue.arrayRemove([db.doc("users/$userUid")]),
      });
    } catch (e) {
      print("Error canceling sent friend request reference: $e");
    }
  }

  Future<void> acceptFriendRequestFromList(
      String userUid, String friendUid) async {
    try {
      final currentDate = DateTime.now();

      // Get the first names of both users
      final userSnapshot = await db.collection("users").doc(userUid).get();
      final friendSnapshot = await db.collection("users").doc(friendUid).get();
      final userFirstName = userSnapshot.data()?['firstName'];
      final friendFirstName = friendSnapshot.data()?['firstName'];

      // Create notifications for both users
      final userNotification =
          "[$currentDate] You are now friends with $friendFirstName";
      final friendNotification =
          "[$currentDate] You are now friends with $userFirstName";

      // Delete the friend from the current user's receivedFriendRequest array
      await db.collection("users").doc(userUid).update({
        "receivedFriendRequest":
            FieldValue.arrayRemove([db.doc("users/$friendUid")]),
        "notifications": FieldValue.arrayUnion([userNotification]),
      });

      // Delete the current user from the friend's sentFriendRequest array
      await db.collection("users").doc(friendUid).update({
        "sentFriendRequest": FieldValue.arrayRemove([db.doc("users/$userUid")]),
        "notifications": FieldValue.arrayUnion([friendNotification]),
      });

      // Add the friend to the current user's friends array
      await db.collection("users").doc(userUid).update({
        "friends": FieldValue.arrayUnion([db.doc("users/$friendUid")]),
      });

      // Add the current user to the friend's friend array
      await db.collection("users").doc(friendUid).update({
        "friends": FieldValue.arrayUnion([db.doc("users/$userUid")]),
      });
    } catch (e) {
      print("Error accepting friend request reference: $e");
    }
  }

  Future<void> rejectFriendRequestFromList(
      String userUid, String friendUid) async {
    try {
      // Delete the friend from the current user's receivedFriendRequest array
      await db.collection("users").doc(userUid).update({
        "receivedFriendRequest":
            FieldValue.arrayRemove([db.doc("users/$friendUid")]),
      });

      // Delete the current user from the friend's sentFriendRequest array
      await db.collection("users").doc(friendUid).update({
        "sentFriendRequest": FieldValue.arrayRemove([db.doc("users/$userUid")]),
      });
    } catch (e) {
      print("Error rejecting friend request reference: $e");
    }
  }

  Stream<QuerySnapshot> getAllFriends() {
    return db.collection("friends").snapshots();
  }

  Stream<QuerySnapshot> getAllUsers() {
    return db.collection('users').snapshots();
  }

  Stream<DocumentSnapshot> getUser(String userUid) {
    return db.collection('users').doc(userUid).snapshots();
  }

  Future<Map<String, dynamic>?> getUserData(String userUid) async {
    final userDoc = await db.collection("users").doc(userUid).get();
    return userDoc.data();
  }

  Stream<QuerySnapshot> getUserFriendsStream(String userUid) {
    return db
        .collection("friends")
        .doc(userUid)
        .collection("userFriends")
        .snapshots();
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
      await db.collection("users").doc(userId).update({
        'firstName': updatedFirstName,
        'lastName': updatedLastName,
        'location': updatedLocation,
        'userName': updatedUserName,
        'birthDate': updatedBirthDate,
        'bio': updatedBio,
        'displayName': updatedDisplayName,
      });

      final DateTime editDateTime = DateTime.now();
      final String formattedDateTime = editDateTime.toString();

      // Include the date and time in the notification message
      final String notificationMessage =
          '[$formattedDateTime] You edited your profile';

      // Append the notification message to the user's notifications array
      await db.collection("users").doc(userId).update({
        'notifications': FieldValue.arrayUnion([notificationMessage]),
      });
    } catch (e) {
      print('Error updating user profile: $e');
    }
  }

  Stream<List<dynamic>> getNotifications(String userUid) {
    final userRef = db.collection("users").doc(userUid);
    return userRef.snapshots().map((snapshot) {
      final notifications = snapshot.data()?['notifications'];
      print("Received notifications: $notifications");
      return (notifications as List<dynamic>?) ?? [];
    }).map((notifications) => notifications);
  }

  Future<void> deleteNotification(String userUid, String notification) async {
    try {
      // Remove the notification from the user's notifications array
      await db.collection("users").doc(userUid).update({
        "notifications": FieldValue.arrayRemove([notification]),
      });
    } catch (e) {
      print("Error deleting notification: $e");
    }
  }

  Future<void> checkAndSendNotifications(String userUid) async {
    try {
      // Get the current user's document reference
      final userRef = db.collection("users").doc(userUid);

      // Get the current date and time
      final currentDateTime = DateTime.now();

      // Get the date for tomorrow
      final tomorrowDate = currentDateTime.add(Duration(days: 1));

      // Format the current date and time in the desired format
      final formattedDateTime =
          '[${DateFormat('yyyy-MM-dd HH:mm:ss').format(currentDateTime)}]';

      // Query tasks that meet the criteria
      final querySnapshot = await db
          .collection("tasks")
          .where("owner", isEqualTo: userRef)
          .where("status", isEqualTo: "In Progress")
          .get();

      final matchingTasks = querySnapshot.docs;

      // Filter tasks based on deadline
      final validTasks = matchingTasks.where((task) {
        final deadline = (task["deadline"] as Timestamp).toDate();
        return deadline.isAfter(tomorrowDate) ||
            deadline.isAtSameMomentAs(tomorrowDate);
      }).toList();

      if (validTasks.isNotEmpty) {
        // Extract task titles
        final taskTitles =
            validTasks.map((task) => task["title"] as String).join(", ");

        // Create a notification message with the formatted date, time, and task titles
        final notificationMessage =
            '$formattedDateTime You have in progress tasks with due tomorrow, namely: "$taskTitles"';

        // Add the notification to the user's notifications array
        await userRef.update({
          "notifications":
              FieldValue.arrayUnion([notificationMessage as dynamic]),
        });
      }
    } catch (e) {
      print("Error checking and sending notifications: $e");
    }
  }
}
