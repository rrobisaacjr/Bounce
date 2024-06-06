// package imports
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rounded_background_text/rounded_background_text.dart';

import '../../providers/task_provider.dart';
import 'modal_task_edit.dart';
import 'modal_task_notifications.dart'; // Import FirebaseFirestore

const double borderRadius = 25.0;

class FriendTaskModal extends StatefulWidget {
  const FriendTaskModal({Key? key, required this.friendRef, required this.user})
      : super(key: key);
  final DocumentReference friendRef; // Receive the friendRef
  final User? user; // This user is the currentUser

  @override
  State<FriendTaskModal> createState() => FriendTaskModalState();
}

class FriendTaskModalState extends State<FriendTaskModal> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
          child: FutureBuilder<DocumentSnapshot>(
        future: widget.friendRef.get(), // Fetch the friend's data
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("No Friend Data Found"));
          } else {
            final friendData = snapshot.data!.data() as Map<String, dynamic>?;

            final friendDisplayName = friendData?['displayName'];
            final friendUserName = friendData?['userName'];
            final friendFirstName = friendData?['firstName'] ?? 'User';
            final friendTasks = friendData?['tasks'];
            final friendUid = widget.friendRef.id;

            return Card(
              color: Colors.black87,
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: Column(children: [
                    SizedBox(
                      width: 300,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              constraints: const BoxConstraints(),
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white,
                              ))
                        ],
                      ),
                    ),
                    Card(
                      child: SizedBox(
                        width: 300,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Dashboard Greeting and Time Text
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text('Friend\'s Tasks',
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w900,
                                            fontSize: 30,
                                            wordSpacing: -3)),
                                  )
                                ],
                              ),

                              Card(
                                  elevation: 0,
                                  color: Colors.transparent,
                                  child: SizedBox(
                                    width: 500,
                                    //height: 250,
                                    child: Card(
                                        elevation: 0,
                                        color: Colors.transparent,
                                        child: SizedBox(
                                          width: 500,
                                          //height: 250,
                                          child: StreamBuilder(
                                            stream: FirebaseFirestore.instance
                                                .collection("users")
                                                .doc(friendUid)
                                                .snapshots(),
                                            initialData: null,
                                            builder: (context, snapshot) {
                                              if (snapshot.hasError) {
                                                return Center(
                                                  child: Text(
                                                      "Error encountered! ${snapshot.error}"),
                                                );
                                              } else if (snapshot
                                                      .connectionState ==
                                                  ConnectionState.waiting) {
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              } else if (!snapshot.hasData) {
                                                return const Center(
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.all(10.0),
                                                    child:
                                                        Text("No Tasks Found"),
                                                  ),
                                                );
                                              } else {
                                                final taskReferences = (snapshot
                                                            .data
                                                            ?.get("tasks")
                                                        as List<dynamic>)
                                                    .cast<DocumentReference>();

                                                if (taskReferences.isEmpty) {
                                                  return Center(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: Text(
                                                          "$friendFirstName has no task yet."),
                                                    ),
                                                  );
                                                }

                                                return ListView.separated(
                                                    separatorBuilder:
                                                        (context, index) {
                                                      return const Divider(
                                                        color:
                                                            Colors.transparent,
                                                        height: 0,
                                                      );
                                                    },
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        taskReferences.length,
                                                    itemBuilder:
                                                        ((context, index) {
                                                      final taskRef =
                                                          taskReferences[index];
                                                      return StreamBuilder<
                                                          DocumentSnapshot>(
                                                        stream:
                                                            taskRef.snapshots(),
                                                        initialData: null,
                                                        builder: (context,
                                                            taskSnapshot) {
                                                          if (taskSnapshot
                                                                  .connectionState ==
                                                              ConnectionState
                                                                  .waiting) {
                                                            return const CircularProgressIndicator();
                                                          } else if (taskSnapshot
                                                              .hasError) {
                                                            return Text(
                                                                "Error: ${taskSnapshot.error}");
                                                          } else {
                                                            final taskData =
                                                                taskSnapshot
                                                                        .data
                                                                        ?.data()
                                                                    as Map<
                                                                        String,
                                                                        dynamic>?;
                                                            final taskTitle =
                                                                taskData?[
                                                                        'title']
                                                                    as String?;
                                                            final taskDescription =
                                                                taskData?[
                                                                        'description']
                                                                    as String?;

                                                            final taskStatus =
                                                                taskData?[
                                                                        'status']
                                                                    as String?;

                                                            final taskDeadline =
                                                                taskData?[
                                                                        'deadline']
                                                                    as Timestamp?;

                                                            final DateTime
                                                                taskDeadlinetoDateTime =
                                                                DateTime.parse(
                                                                    taskDeadline!
                                                                        .toDate()
                                                                        .toString());

                                                            final taskElapsed =
                                                                daysBetween(
                                                                    DateTime
                                                                        .now(),
                                                                    taskDeadlinetoDateTime);

                                                            String
                                                                taskDeadlineFormatted =
                                                                DateFormat(
                                                                        'MMM dd, hh:mm a')
                                                                    .format(
                                                                        taskDeadlinetoDateTime);

                                                            return Visibility(
                                                                visible:
                                                                    taskStatus ==
                                                                        'In Progress',
                                                                child: Column(
                                                                    children: [
                                                                      const SizedBox(
                                                                        height:
                                                                            15,
                                                                      ),
                                                                      ListTile(
                                                                        isThreeLine:
                                                                            true,
                                                                        minVerticalPadding:
                                                                            0,
                                                                        shape: const RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.all(Radius.circular(10))),
                                                                        tileColor: const Color.fromARGB(
                                                                            117,
                                                                            240,
                                                                            240,
                                                                            240),
                                                                        dense:
                                                                            false,
                                                                        horizontalTitleGap:
                                                                            20,
                                                                        visualDensity: const VisualDensity(
                                                                            horizontal:
                                                                                0,
                                                                            vertical:
                                                                                -4),
                                                                        contentPadding: const EdgeInsets.fromLTRB(
                                                                            15,
                                                                            12,
                                                                            10,
                                                                            12),
                                                                        title: Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Flex(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                direction: Axis.horizontal,
                                                                                children: [
                                                                                  Expanded(flex: 5, child: Padding(padding: const EdgeInsets.fromLTRB(5, 0, 0, 5), child: RoundedBackgroundText(outerRadius: 20.0, innerRadius: 20.0, taskStatus!, style: TextStyle(fontFamily: GoogleFonts.robotoMono().fontFamily, fontWeight: FontWeight.w900, fontSize: 13), backgroundColor: (taskStatus == 'Done') ? const Color.fromARGB(255, 198, 255, 27) : Colors.grey))),
                                                                                  Wrap(
                                                                                    children: [
                                                                                      Expanded(
                                                                                          child: IconButton(
                                                                                        onPressed: () async {
                                                                                          _showEditTaskDialog(taskRef, widget.user!);
                                                                                        },
                                                                                        icon: const Icon(Icons.edit),
                                                                                        constraints: const BoxConstraints(),
                                                                                        padding: const EdgeInsets.only(left: 8),
                                                                                        splashRadius: 15,
                                                                                      )),
                                                                                      Expanded(
                                                                                          child: IconButton(
                                                                                        onPressed: () async {
                                                                                          final notifications = await context.read<TaskProvider>().getTaskNotifications(taskRef);

                                                                                          showDialog(
                                                                                            context: context,
                                                                                            builder: (BuildContext context) {
                                                                                              return NotificationsModal(notifications: notifications);
                                                                                            },
                                                                                          );
                                                                                        },
                                                                                        icon: const Icon(Icons.history),
                                                                                        constraints: const BoxConstraints(),
                                                                                        padding: const EdgeInsets.only(left: 8),
                                                                                        splashRadius: 15,
                                                                                      )),
                                                                                    ],
                                                                                  )
                                                                                ],
                                                                              ),
                                                                              Row(
                                                                                children: [
                                                                                  Text(taskTitle ?? "Unknown", maxLines: 2, style: TextStyle(color: (taskStatus == 'Done') ? Colors.black26 : Colors.black87, fontWeight: FontWeight.w900, fontSize: 18, wordSpacing: -3))
                                                                                ],
                                                                              )
                                                                            ]),
                                                                        subtitle:
                                                                            Column(
                                                                                children: [
                                                                              Flex(
                                                                                direction: Axis.horizontal,
                                                                                children: [
                                                                                  Expanded(
                                                                                      flex: -1,
                                                                                      child: Padding(
                                                                                          padding: const EdgeInsets.only(right: 5),
                                                                                          child: Icon(
                                                                                            Icons.access_alarm_rounded,
                                                                                            size: 15,
                                                                                            color: (taskStatus == 'Done') ? Colors.black12 : Colors.black54,
                                                                                          ))),
                                                                                  Expanded(
                                                                                    child: Text(taskDeadlineFormatted, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: (taskStatus == 'Done') ? Colors.black12 : Colors.black54)),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              Flex(
                                                                                direction: Axis.horizontal,
                                                                                children: [
                                                                                  Expanded(flex: -1, child: Padding(padding: const EdgeInsets.fromLTRB(0, 0, 5, 5), child: Icon(Icons.calendar_month_rounded, size: 15, color: (taskStatus == 'Done') ? Colors.black12 : Colors.black54))),
                                                                                  Expanded(
                                                                                      child: Padding(
                                                                                    padding: const EdgeInsets.only(bottom: 5),
                                                                                    child: Text(
                                                                                        (taskElapsed > 1)
                                                                                            ? "$taskElapsed days left"
                                                                                            : (taskElapsed == 1)
                                                                                                ? "$taskElapsed day left"
                                                                                                : (taskElapsed == 0)
                                                                                                    ? "Today is the deadline"
                                                                                                    : (taskElapsed == -1)
                                                                                                        ? "${taskElapsed * -1} day overdue"
                                                                                                        : "${taskElapsed * -1} days overdue",
                                                                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: (taskStatus == 'Done') ? Colors.black12 : Colors.black54)),
                                                                                  )),
                                                                                ],
                                                                              ),
                                                                              const Divider(
                                                                                height: 0,
                                                                                color: Colors.black12,
                                                                                thickness: 0.8,
                                                                              ),
                                                                              Row(
                                                                                children: [
                                                                                  Flexible(
                                                                                      child: Padding(
                                                                                    padding: const EdgeInsets.only(top: 5),
                                                                                    child: Text(taskDescription ?? "Unknown", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: (taskStatus == 'Done') ? Colors.black12 : Colors.black54)),
                                                                                  ))
                                                                                ],
                                                                              )
                                                                            ]),
                                                                      )
                                                                    ]));
                                                          }
                                                        },
                                                      );
                                                    }));
                                              }
                                            },
                                          ),
                                        )),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ])),
            );
          }
        },
      )),
    );
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  void _showEditTaskDialog(DocumentReference taskRef, User user) async {
    final taskDataSnapshot = await taskRef.get();
    final taskData = taskDataSnapshot.data() as Map<String, dynamic>?;
    final String originalTitle = taskData?['title'] ?? '';
    final String originalDescription = taskData?['description'] ?? '';
    final Timestamp? originalDeadline = taskData?['deadline'] as Timestamp?;

    final editedData = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (BuildContext context) {
        return EditTaskModal(
          originalTitle: originalTitle,
          originalDescription: originalDescription,
          originalDeadline: originalDeadline,
        );
      },
    );

    if (editedData != null) {
      final updatedNotifications =
          taskData?['notifications'] as List<dynamic>? ?? [];
      final String datetoday =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
      // final String user =
      //     friendDisplayName ?? ''; // Replace with appropriate user info
      final String userDisplayName = user.displayName ?? '';

      final String notificationMessage =
          '[$datetoday] $userDisplayName updated the task';
      updatedNotifications.add(notificationMessage);

      final taskProvider = context.read<TaskProvider>();

      await taskProvider.updateTaskAndNotifyOwner(
        taskRef: taskRef,
        title: editedData['title'],
        description: editedData['description'],
        deadline: editedData['deadline'],
        notifications: updatedNotifications,
        userDisplayName: userDisplayName,
      );

      print('Task updated successfully');
      showCustomSnackBar(context, 'Task updated successfully');
    }
  }

  void showCustomSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.black87,
        content: Row(
          children: [
            Expanded(
              child: Text(
                message,
                style:
                    TextStyle(fontFamily: GoogleFonts.robotoMono().fontFamily),
              ),
            ),
            IconButton(
              padding: EdgeInsets.zero,
              color: Colors.white,
              constraints: const BoxConstraints(),
              icon: const Icon(Icons.close),
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 140,
          right: 40,
          left: 40,
        ),
      ),
    );
  }
}
