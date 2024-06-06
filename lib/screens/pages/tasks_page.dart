// package imports

// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:rounded_background_text/rounded_background_text.dart';

//file imports
import '../../providers/friend_provider.dart';
import '../../providers/task_provider.dart';
import '../modals/modal_task_add.dart';
import '../modals/modal_task_notifications.dart';
import '../modals/modal_task_edit.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key, required this.title, required this.user});
  final String title;
  final User? user;

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  @override
  Widget build(BuildContext context) {
    // Current User's Field Values
    //final currentUser = widget.user;
    final currentUserDataFuture =
        context.read<FriendListProvider>().getUserData(widget.user!.uid);

    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          width: 250.0,
          child: DefaultTextStyle(
            style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 30,
                color: Colors.black,
                fontFamily: GoogleFonts.robotoMono().fontFamily),
            child: AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText("Tasks",
                    speed: const Duration(milliseconds: 200)),
                TypewriterAnimatedText(widget.title,
                    speed: const Duration(milliseconds: 500)),
              ],
              repeatForever: true,
              pause: const Duration(milliseconds: 10000),
              onTap: () {
                print("Tap Event");
              },
            ),
          ),
        ),
      ),
      body: Center(
          child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics()),
              child: FutureBuilder<Map<String, dynamic>?>(
                future: currentUserDataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else {
                    final currentUserData = snapshot.data;
                    final firstName = currentUserData?['firstName'];

                    return Column(children: [
                      // Active Tasks
                      Card(
                        margin: const EdgeInsets.fromLTRB(0, 80, 0, 5),
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
                                      child: Text('Active Tasks',
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              fontSize: 30)),
                                    )
                                  ],
                                ),
                                Card(
                                    elevation: 0,
                                    color: Colors.transparent,
                                    child: SizedBox(
                                      width: 500,
                                      //height: 250,
                                      child: StreamBuilder(
                                        stream: FirebaseFirestore.instance
                                            .collection("users")
                                            .doc(widget.user?.uid)
                                            .snapshots(),
                                        initialData: null,
                                        builder: (context, snapshot) {
                                          if (snapshot.hasError) {
                                            return Center(
                                              child: Text(
                                                  "Error encountered! ${snapshot.error}"),
                                            );
                                          } else if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          } else if (!snapshot.hasData) {
                                            return const Center(
                                              child: Padding(
                                                padding: EdgeInsets.all(10.0),
                                                child: Text("No Tasks Found"),
                                              ),
                                            );
                                          } else {
                                            final taskReferences =
                                                (snapshot.data?.get("tasks")
                                                        as List<dynamic>)
                                                    .cast<DocumentReference>();

                                            if (taskReferences.isEmpty) {
                                              return Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Text(
                                                      "$firstName has no task yet."),
                                                ),
                                              );
                                            }

                                            return ListView.separated(
                                                separatorBuilder:
                                                    (context, index) {
                                                  return const Divider(
                                                    color: Colors.transparent,
                                                    height: 0,
                                                  );
                                                },
                                                shrinkWrap: true,
                                                itemCount:
                                                    taskReferences.length,
                                                itemBuilder: ((context, index) {
                                                  final taskRef =
                                                      taskReferences[index];
                                                  return StreamBuilder<
                                                      DocumentSnapshot>(
                                                    stream: taskRef.snapshots(),
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
                                                            taskSnapshot.data
                                                                    ?.data()
                                                                as Map<String,
                                                                    dynamic>?;
                                                        final taskTitle =
                                                            taskData?['title']
                                                                as String?;
                                                        final taskDescription =
                                                            taskData?[
                                                                    'description']
                                                                as String?;

                                                        final taskStatus =
                                                            taskData?['status']
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
                                                                DateTime.now(),
                                                                taskDeadlinetoDateTime);

                                                        String
                                                            taskDeadlineFormatted =
                                                            DateFormat(
                                                                    'MMM dd, hh:mm a')
                                                                .format(
                                                                    taskDeadlinetoDateTime);

                                                        return Visibility(
                                                            visible: taskStatus ==
                                                                'In Progress',
                                                            child: Column(
                                                                children: [
                                                                  const SizedBox(
                                                                    height: 15,
                                                                  ),
                                                                  ListTile(
                                                                    isThreeLine:
                                                                        true,
                                                                    minVerticalPadding:
                                                                        0,
                                                                    shape: const RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(10))),
                                                                    tileColor:
                                                                        const Color.fromARGB(
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
                                                                    contentPadding:
                                                                        const EdgeInsets.fromLTRB(
                                                                            15,
                                                                            12,
                                                                            10,
                                                                            12),
                                                                    title: Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Flex(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            direction:
                                                                                Axis.horizontal,
                                                                            children: [
                                                                              Expanded(flex: 5, child: Padding(padding: const EdgeInsets.fromLTRB(5, 0, 0, 5), child: RoundedBackgroundText(outerRadius: 20.0, innerRadius: 20.0, taskStatus!, style: TextStyle(fontFamily: GoogleFonts.robotoMono().fontFamily, fontWeight: FontWeight.w900, fontSize: 13), backgroundColor: (taskStatus == 'Done') ? const Color.fromARGB(255, 198, 255, 27) : Colors.grey))),
                                                                              Wrap(
                                                                                children: [
                                                                                  Visibility(
                                                                                      visible: taskStatus == "In Progress",
                                                                                      child: Expanded(
                                                                                          child: IconButton(
                                                                                        onPressed: () async {
                                                                                          final taskProvider = context.read<TaskProvider>();
                                                                                          await taskProvider.updateTaskStatus(taskRef, 'Done');
                                                                                          print('Task status updated to "Done"');
                                                                                          showCustomSnackBar(context, 'Task accomplished');
                                                                                        },
                                                                                        icon: const Icon(Icons.done_rounded),
                                                                                        constraints: const BoxConstraints(),
                                                                                        padding: const EdgeInsets.only(left: 8),
                                                                                        splashRadius: 15,
                                                                                      ))),
                                                                                  (taskStatus == "In Progress")
                                                                                      ? Expanded(
                                                                                          child: IconButton(
                                                                                          onPressed: () async {
                                                                                            _showEditTaskDialog(taskRef, widget.user!);
                                                                                          },
                                                                                          icon: const Icon(Icons.edit),
                                                                                          constraints: const BoxConstraints(),
                                                                                          padding: const EdgeInsets.only(left: 8),
                                                                                          splashRadius: 15,
                                                                                        ))
                                                                                      : Expanded(
                                                                                          child: IconButton(
                                                                                          onPressed: () async {
                                                                                            final taskProvider = context.read<TaskProvider>();
                                                                                            await taskProvider.updateTaskStatus(taskRef, 'In Progress');
                                                                                            print('Task status updated to "Done"');
                                                                                          },
                                                                                          icon: const Icon(Icons.arrow_back),
                                                                                          constraints: const BoxConstraints(),
                                                                                          padding: const EdgeInsets.only(left: 8),
                                                                                          splashRadius: 15,
                                                                                        )),
                                                                                  Expanded(
                                                                                      child: IconButton(
                                                                                    onPressed: () async {
                                                                                      bool confirmDelete = await _showDeleteConfirmationDialog(context);
                                                                                      if (confirmDelete) {
                                                                                        try {
                                                                                          final taskDataSnapshot = await taskRef.get();
                                                                                          final taskData = taskDataSnapshot.data() as Map<String, dynamic>?;
                                                                                          final ownerRef = taskData?['owner'] as DocumentReference?;

                                                                                          if (ownerRef != null) {
                                                                                            await ownerRef.update({
                                                                                              'tasks': FieldValue.arrayRemove([taskRef])
                                                                                            });
                                                                                          }

                                                                                          await taskRef.delete();

                                                                                          print('Task deleted successfully');
                                                                                        } catch (e) {
                                                                                          print('Error deleting task: $e');
                                                                                        }
                                                                                      }
                                                                                    },
                                                                                    icon: const Icon(Icons.delete),
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
                                                                            direction:
                                                                                Axis.horizontal,
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
                                                                            direction:
                                                                                Axis.horizontal,
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
                                                                            height:
                                                                                0,
                                                                            color:
                                                                                Colors.black12,
                                                                            thickness:
                                                                                0.8,
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
                                    ))
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Inactive Tasks
                      Card(
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 80),
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
                                      child: Text('Inactive Tasks',
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              fontSize: 30)),
                                    )
                                  ],
                                ),
                                Card(
                                    elevation: 0,
                                    color: Colors.transparent,
                                    child: SizedBox(
                                      width: 500,
                                      //height: 250,
                                      child: StreamBuilder(
                                        stream: FirebaseFirestore.instance
                                            .collection("users")
                                            .doc(widget.user?.uid)
                                            .snapshots(),
                                        initialData: null,
                                        builder: (context, snapshot) {
                                          if (snapshot.hasError) {
                                            return Center(
                                              child: Text(
                                                  "Error encountered! ${snapshot.error}"),
                                            );
                                          } else if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          } else if (!snapshot.hasData) {
                                            return const Center(
                                              child: Padding(
                                                padding: EdgeInsets.all(10.0),
                                                child: Text("No Tasks Found"),
                                              ),
                                            );
                                          } else {
                                            final taskReferences =
                                                (snapshot.data?.get("tasks")
                                                        as List<dynamic>)
                                                    .cast<DocumentReference>();

                                            if (taskReferences.isEmpty) {
                                              return Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Text(
                                                      "$firstName has no task yet."),
                                                ),
                                              );
                                            }

                                            return ListView.separated(
                                                separatorBuilder:
                                                    (context, index) {
                                                  return const Divider(
                                                    color: Colors.transparent,
                                                    height: 0,
                                                  );
                                                },
                                                shrinkWrap: true,
                                                itemCount:
                                                    taskReferences.length,
                                                itemBuilder: ((context, index) {
                                                  final taskRef =
                                                      taskReferences[index];
                                                  return StreamBuilder<
                                                      DocumentSnapshot>(
                                                    stream: taskRef.snapshots(),
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
                                                            taskSnapshot.data
                                                                    ?.data()
                                                                as Map<String,
                                                                    dynamic>?;
                                                        final taskTitle =
                                                            taskData?['title']
                                                                as String?;
                                                        final taskDescription =
                                                            taskData?[
                                                                    'description']
                                                                as String?;

                                                        final taskStatus =
                                                            taskData?['status']
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
                                                                DateTime.now(),
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
                                                                    'Done',
                                                            child: Column(
                                                                children: [
                                                                  const SizedBox(
                                                                    height: 15,
                                                                  ),
                                                                  ListTile(
                                                                    isThreeLine:
                                                                        true,
                                                                    minVerticalPadding:
                                                                        0,
                                                                    shape: const RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(10))),
                                                                    tileColor:
                                                                        const Color.fromARGB(
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
                                                                    contentPadding:
                                                                        const EdgeInsets.fromLTRB(
                                                                            15,
                                                                            12,
                                                                            10,
                                                                            12),
                                                                    title: Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Flex(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            direction:
                                                                                Axis.horizontal,
                                                                            children: [
                                                                              Expanded(flex: 5, child: Padding(padding: const EdgeInsets.fromLTRB(5, 0, 0, 5), child: RoundedBackgroundText(outerRadius: 20.0, innerRadius: 20.0, taskStatus!, style: TextStyle(fontFamily: GoogleFonts.robotoMono().fontFamily, fontWeight: FontWeight.w900, fontSize: 13), backgroundColor: (taskStatus == 'Done') ? const Color.fromARGB(255, 198, 255, 27) : Colors.grey))),
                                                                              Wrap(
                                                                                children: [
                                                                                  (taskStatus == "In Progress")
                                                                                      ? Expanded(child: IconButton(onPressed: () {}, icon: const Icon(Icons.edit_rounded), constraints: const BoxConstraints(), padding: const EdgeInsets.only(left: 8), splashRadius: 15))
                                                                                      : Expanded(
                                                                                          child: IconButton(
                                                                                              onPressed: () async {
                                                                                                final taskProvider = context.read<TaskProvider>();
                                                                                                await taskProvider.updateTaskStatus(taskRef, 'In Progress');
                                                                                                print('Task status updated to "In Progress"');
                                                                                                showCustomSnackBar(context, 'Task back in progress');
                                                                                              },
                                                                                              icon: const Icon(Icons.undo_rounded),
                                                                                              constraints: const BoxConstraints(),
                                                                                              padding: const EdgeInsets.only(left: 8),
                                                                                              splashRadius: 15)),
                                                                                  Expanded(
                                                                                      child: IconButton(
                                                                                          onPressed: () async {
                                                                                            bool confirmDelete = await _showDeleteConfirmationDialog(context);
                                                                                            if (confirmDelete) {
                                                                                              try {
                                                                                                final taskDataSnapshot = await taskRef.get();
                                                                                                final taskData = taskDataSnapshot.data() as Map<String, dynamic>?;
                                                                                                final ownerRef = taskData?['owner'] as DocumentReference?;

                                                                                                if (ownerRef != null) {
                                                                                                  await ownerRef.update({
                                                                                                    'tasks': FieldValue.arrayRemove([taskRef])
                                                                                                  });
                                                                                                }

                                                                                                await taskRef.delete();

                                                                                                print('Task deleted successfully');
                                                                                              } catch (e) {
                                                                                                print('Error deleting task: $e');
                                                                                              }
                                                                                            }
                                                                                          },
                                                                                          icon: const Icon(Icons.delete),
                                                                                          constraints: const BoxConstraints(),
                                                                                          padding: const EdgeInsets.only(left: 8),
                                                                                          splashRadius: 15)),
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
                                                                                          splashRadius: 15)),
                                                                                ],
                                                                              )
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Text(taskTitle ?? "Unknown", maxLines: 2, style: TextStyle(color: (taskStatus == 'Done') ? Colors.black26 : Colors.black54, fontWeight: FontWeight.w900, fontSize: 18, wordSpacing: -3))
                                                                            ],
                                                                          )
                                                                        ]),
                                                                    subtitle:
                                                                        Column(
                                                                            children: [
                                                                          Flex(
                                                                            direction:
                                                                                Axis.horizontal,
                                                                            children: [
                                                                              Expanded(flex: -1, child: Padding(padding: const EdgeInsets.only(right: 5), child: Icon(Icons.access_alarm_rounded, size: 15, color: (taskStatus == 'Done') ? Colors.black12 : Colors.black54))),
                                                                              Expanded(
                                                                                child: Text(taskDeadlineFormatted, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: (taskStatus == 'Done') ? Colors.black12 : Colors.black54)),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Flex(
                                                                            direction:
                                                                                Axis.horizontal,
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
                                                                            height:
                                                                                0,
                                                                            color:
                                                                                Colors.black12,
                                                                            thickness:
                                                                                0.8,
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
                                    ))
                              ],
                            ),
                          ),
                        ),
                      )
                    ]);
                  }
                },
              ))),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(20),
        child: FloatingActionButton.extended(
          onPressed: () {
            _showAddTaskDialog(context, widget.user!.uid);
          },
          icon: const Icon(Icons.add_task_rounded),
          label: const Text("Add Task",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: Colors.black)),
        ),
      ),
    );
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  void _showAddTaskDialog(BuildContext context, String uid) {
    final friendRef = FirebaseFirestore.instance.collection("users").doc(uid);

    showAnimatedDialog(
        animationType: DialogTransitionType.slideFromBottomFade,
        curve: Curves.decelerate,
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) => TaskAddModal(friendRef: friendRef));
  }

  Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
    bool? result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this task?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
                showCustomSnackBar(context, 'Task deleted successfully');
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    return result ?? false; // Return false if result is null
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
      //     widget.user?.displayName ?? ''; // Replace with appropriate user info
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
          bottom: MediaQuery.of(context).size.height * 0.72,
          right: 40,
          left: 40,
        ),
      ),
    );
  }
}
