// package imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//file imports
import '../api/firebase_task_api.dart';

class TaskProvider extends ChangeNotifier {
  final FirebaseTaskAPI taskAPI = FirebaseTaskAPI();

  Future<void> addTask({
    required String title,
    required String description,
    required Timestamp deadline,
    required DocumentReference owner,
    required String notifications,
  }) async {
    await taskAPI.addTask(
      title: title,
      description: description,
      deadline: deadline,
      owner: owner,
      notifications: notifications,
    );
  }

  Future<void> deleteTask(
      DocumentReference taskRef, DocumentReference ownerRef) async {
    try {
      await taskAPI.deleteTask(taskRef, ownerRef);
      print('Task deleted from provider');
    } catch (e) {
      print('Error deleting task from provider: $e');
    }
  }

  Future<List<String>> getTaskNotifications(DocumentReference taskRef) async {
    try {
      final taskSnapshot = await taskRef.get();
      final taskData = taskSnapshot.data() as Map<String, dynamic>?;
      final notifications = taskData?['notifications'] as List<dynamic>?;
      return notifications?.cast<String>() ?? [];
    } catch (e) {
      print('Error getting task notifications: $e');
      return [];
    }
  }

  Future<void> updateTaskStatus(
      DocumentReference taskRef, String newStatus) async {
    await taskAPI.updateTaskStatus(taskRef, newStatus);
  }

  Future<void> updateTaskAndNotifyOwner({
    required DocumentReference taskRef,
    required String title,
    required String description,
    required String deadline,
    required List<dynamic> notifications,
    required String userDisplayName,
  }) async {
    final taskDataSnapshot = await taskRef.get();
    final taskData = taskDataSnapshot.data() as Map<String, dynamic>?;
    final ownerRef = taskData?['owner'] as DocumentReference?;

    if (ownerRef != null) {
      final ownerSnapshot = await ownerRef.get();
      final ownerData = ownerSnapshot.data() as Map<String, dynamic>?;

      final List<dynamic> updatedOwnerNotifications =
          List.from(ownerData?['notifications'] ?? []);

      final String datetoday =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

      String ownerNotificationMessage;

      if (ownerData?['displayName'] == userDisplayName) {
        ownerNotificationMessage = '[$datetoday] You edited a task';
      } else {
        ownerNotificationMessage =
            '[$datetoday] $userDisplayName updated your task';
      }

      updatedOwnerNotifications.add(ownerNotificationMessage);

      await ownerRef.update({
        'notifications': updatedOwnerNotifications,
      });
    }

    await taskAPI.updateTask(
      taskRef,
      title: title,
      description: description,
      deadline: deadline,
      notifications: notifications,
    );
  }
}
