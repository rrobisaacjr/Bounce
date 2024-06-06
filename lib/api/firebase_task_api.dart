// package imports
import 'package:cloud_firestore/cloud_firestore.dart';

//file imports

class FirebaseTaskAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> addTask({
    required String title,
    required String description,
    required Timestamp deadline,
    required DocumentReference owner,
    required String notifications,
  }) async {
    final taskData = {
      'title': title,
      'description': description,
      'deadline': deadline,
      'status': 'In Progress',
      'owner': owner,
      'notifications': [notifications],
    };

    final taskRef = await db.collection('tasks').add(taskData);

    // Update the current user's "tasks" array
    await updateUserTasksArray(owner, taskRef);
  }

  Future<void> updateUserTasksArray(
      DocumentReference owner, DocumentReference taskRef) async {
    final userData = await owner.get();
    final tasksArray = userData['tasks'] as List<dynamic>;
    tasksArray.add(taskRef);

    await owner.update({'tasks': tasksArray});
  }

  Future<void> deleteTask(
      DocumentReference taskRef, DocumentReference ownerRef) async {
    try {
      await ownerRef.update({
        'tasks': FieldValue.arrayRemove([taskRef])
      });

      await taskRef.delete();

      print('Task deleted from FirebaseTaskAPI');
    } catch (e) {
      print('Error deleting task from FirebaseTaskAPI: $e');
    }
  }

  Future<List<String>> getTaskNotifications(DocumentReference taskRef) async {
    final taskSnapshot = await taskRef.get();
    final taskData = taskSnapshot.data() as Map<String, dynamic>?;
    final notifications = taskData?['notifications'] as List<dynamic>?;
    return notifications?.cast<String>() ?? [];
  }

  Future<void> updateTaskStatus(
      DocumentReference taskRef, String newStatus) async {
    await taskRef.update({'status': newStatus});
  }

  Future<void> updateTask(DocumentReference taskRef,
      {String? title,
      String? description,
      String? deadline,
      List<dynamic>? notifications}) async {
    final Map<String, dynamic> updatedData = {};
    if (title != null) {
      updatedData['title'] = title;
    }
    if (description != null) {
      updatedData['description'] = description;
    }
    if (deadline != null) {
      updatedData['deadline'] = Timestamp.fromDate(DateTime.parse(deadline));
    }
    if (notifications != null) {
      updatedData['notifications'] = notifications;
    }
    await taskRef.update(updatedData);
  }
}
