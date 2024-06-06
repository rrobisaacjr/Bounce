// package imports
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// file imports
import '../../providers/task_provider.dart';
import '../../providers/friend_provider.dart';

const double borderRadius = 25.0;

class TaskAddModal extends StatefulWidget {
  const TaskAddModal({Key? key, required this.friendRef}) : super(key: key);
  final DocumentReference friendRef; // Receive the friendRef

  @override
  State<TaskAddModal> createState() => TaskAddModalState();
}

class TaskAddModalState extends State<TaskAddModal> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

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
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Create new task',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 25,
                                    )),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: TextFormField(
                                    controller: _titleController,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      prefixIcon: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: Icon(
                                          Icons.title_rounded,
                                        ),
                                      ),
                                      hintStyle: const TextStyle(
                                          color: Colors.black54),
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText: "Title",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter a title.';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: TextFormField(
                                    controller: _descriptionController,
                                    maxLines: 4,
                                    keyboardType: TextInputType.multiline,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      prefixIcon: const Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(15, 0, 15, 60),
                                        child: Icon(
                                          Icons.subtitles_rounded,
                                        ),
                                      ),
                                      hintStyle: const TextStyle(
                                          color: Colors.black54),
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText: "Description",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter a description.';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    DateTime? selectedDate =
                                        await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(2101),
                                    );
                                    if (selectedDate != null) {
                                      _deadlineController.text =
                                          DateFormat('yyyy-MM-dd')
                                              .format(selectedDate);
                                    }
                                  },
                                  child: IgnorePointer(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: TextFormField(
                                        controller: _deadlineController,
                                        decoration: InputDecoration(
                                          isDense: true,
                                          prefixIcon: const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15),
                                            child: Icon(
                                              Icons.access_alarm_rounded,
                                            ),
                                          ),
                                          hintStyle: const TextStyle(
                                              color: Colors.black54),
                                          filled: true,
                                          fillColor: Colors.white,
                                          hintText: "Deadline",
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please set a deadline.';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          backgroundColor: const Color.fromARGB(
                                              255, 198, 255, 27)),
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          final friendRef = widget.friendRef;
                                          final String title =
                                              _titleController.text;
                                          final String description =
                                              _descriptionController.text;
                                          final Timestamp deadline =
                                              Timestamp.fromDate(DateTime.parse(
                                                  _deadlineController.text));
                                          final String datetoday =
                                              DateFormat.yMd()
                                                  .add_jm()
                                                  .format(DateTime.now());

                                          // Get the current user's data to obtain the user's firstName
                                          final Map<String, dynamic>?
                                              friendData = await context
                                                  .read<FriendListProvider>()
                                                  .getUserData(friendRef.id);
                                          final String user =
                                              friendData?['displayName'] ?? '';

                                          final String notifications =
                                              '[$datetoday] $user created the task';

                                          // Pass the friendRef directly to addTask method
                                          await context
                                              .read<TaskProvider>()
                                              .addTask(
                                                title: title,
                                                description: description,
                                                deadline: deadline,
                                                owner: friendRef,
                                                notifications: notifications,
                                              );
                                          showCustomSnackBar(context,
                                              'Task added successfully');

                                          Navigator.pop(context);
                                        } // Close the modal
                                      },
                                      child: const SizedBox(
                                          height: 40,
                                          child: Center(
                                              child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(right: 10),
                                                child: Icon(
                                                  Icons.add_rounded,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 10),
                                                  child: Text('Add Task',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        fontSize: 20,
                                                      )))
                                            ],
                                          ))),
                                    ))
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ])),
            );
          }
        },
      )),
    );
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
