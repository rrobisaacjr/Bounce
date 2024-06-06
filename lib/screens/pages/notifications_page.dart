// package imports
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:rounded_background_text/rounded_background_text.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

//file imports
import '../../providers/friend_provider.dart';
import '../modals/modal_friend.dart';
import '../modals/modal_profile.dart';
import '../modals/modal_profile_edit.dart';
import '../modals/modal_task_friend.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key, required this.title, required this.user})
      : super(key: key);

  final String title;
  final User? user;

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  DateTime? startDate;
  DateTime? endDate;
  String dateRangeText = 'Select Date Range';

  // Define a timer variable
  late Timer _notificationTimer;

  DateTime extractDateTime(String notification) {
    final match = RegExp(r'\[(.*?)\]').firstMatch(notification);
    if (match != null) {
      final dateString = match.group(1);
      return DateTime.parse(dateString!);
    }
    // Return a default date if no match is found (this can be adjusted as needed).
    return DateTime.now();
  }

  @override
  void initState() {
    super.initState();
    final currentDate = DateTime.now();

    // Set the endDate to the current date.
    endDate = currentDate;

    // Calculate the startDate as one month ago from the current date.
    startDate = currentDate.subtract(const Duration(days: 30));

    // Initialize and start the notification timer
    _notificationTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      // Check and send notifications periodically (adjust the interval as needed)
      FriendListProvider().checkAndSendNotifications(widget.user!.uid);
      // Trigger a rebuild of the widget tree
      setState(() {});
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the page is disposed
    _notificationTimer.cancel();
    super.dispose();
  }

  Future<void> showDateTimeRangePicker(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(start: startDate!, end: endDate!),
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end;
        dateRangeText =
            'Selected Date Range: \n${DateFormat('MMM dd, yy').format(startDate!)} - ${DateFormat('MMM dd, yy').format(endDate!)}';
      });
    }
  }

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
                          margin: const EdgeInsets.fromLTRB(0, 80, 0, 80),
                          child: SizedBox(
                            width: 300,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Dashboard Greeting and Time Text
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Text(
                                            '$firstName\'s \nNotifications',
                                            maxLines: 2,
                                            softWrap: false,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w900,
                                                fontSize: 30)),
                                      ),
                                    ],
                                  ),

                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                            child: InkWell(
                                                onTap: () =>
                                                    showDateTimeRangePicker(
                                                        context),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10),
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                      color: Colors.black,
                                                      border:
                                                          Border.all(width: 1),
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  10)),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        const Icon(
                                                            Icons.date_range,
                                                            color:
                                                                Colors.white),
                                                        const SizedBox(
                                                            width: 8),
                                                        Flexible(
                                                          child: Text(
                                                            dateRangeText,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .white),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                )))
                                      ]),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Card(
                                              elevation: 0,
                                              color: Colors.transparent,
                                              child: SizedBox(
                                                  // width: 500,
                                                  child: StreamBuilder<
                                                          List<dynamic>>(
                                                      stream: FriendListProvider()
                                                          .getNotificationsStream(
                                                              widget.user!.uid),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          return const Center(
                                                              child:
                                                                  CircularProgressIndicator());
                                                        } else if (snapshot
                                                            .hasError) {
                                                          return Center(
                                                              child: Text(
                                                                  "Error: ${snapshot.error}"));
                                                        } else if (!snapshot
                                                                .hasData ||
                                                            snapshot.data!
                                                                .isEmpty) {
                                                          return const Center(
                                                              child: Text(
                                                                  "No Notifications Found"));
                                                        } else {
                                                          final notifications =
                                                              snapshot.data!;
                                                          return ListView
                                                              .separated(
                                                                  separatorBuilder:
                                                                      (context,
                                                                          index) {
                                                                    return const Divider(
                                                                      color: Colors
                                                                          .transparent,
                                                                      height: 0,
                                                                    );
                                                                  },
                                                                  shrinkWrap:
                                                                      true,
                                                                  itemCount:
                                                                      notifications
                                                                          .length,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index) {
                                                                    final reversedIndex =
                                                                        notifications.length -
                                                                            1 -
                                                                            index;
                                                                    final notification =
                                                                        notifications[
                                                                            reversedIndex];
                                                                    final notificationDateTime =
                                                                        extractDateTime(
                                                                            notification);

                                                                    // Filter by date range
                                                                    if (startDate != null &&
                                                                        endDate !=
                                                                            null &&
                                                                        (notificationDateTime.isBefore(startDate!) ||
                                                                            notificationDateTime.isAfter(endDate!))) {
                                                                      return const SizedBox
                                                                          .shrink(); // Hide notifications outside the range.
                                                                    }

                                                                    final notifDate = DateFormat("MMM d, y (hh:mm a)").format(DateTime.parse(notification.substring(
                                                                        notification.indexOf('[') +
                                                                            1,
                                                                        notification
                                                                            .indexOf(']'))));

                                                                    if (notificationDateTime.isAfter(
                                                                            startDate!) &&
                                                                        notificationDateTime
                                                                            .isBefore(endDate!)) {
                                                                      return Container(
                                                                          constraints:
                                                                              BoxConstraints(maxHeight: MediaQuery.of(context).size.height * .30),
                                                                          child: SingleChildScrollView(
                                                                              primary: true,
                                                                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                                const SizedBox(
                                                                                  height: 15,
                                                                                ),
                                                                                Material(
                                                                                    child: Dismissible(
                                                                                        key: Key(notification), // Use the notification as the key
                                                                                        direction: DismissDirection.endToStart,
                                                                                        background: Container(
                                                                                          decoration: const BoxDecoration(
                                                                                            color: Colors.black,
                                                                                            borderRadius: BorderRadius.all(Radius.circular(5.0) //                 <--- border radius here
                                                                                                ),
                                                                                          ),
                                                                                          alignment: Alignment.centerRight,
                                                                                          padding: const EdgeInsets.only(right: 20.0),
                                                                                          child: const Icon(Icons.delete, color: Colors.white),
                                                                                        ),
                                                                                        onDismissed: (direction) {
                                                                                          setState(() {
                                                                                            // Remove the notification from the UI.
                                                                                            notifications.remove(notification);
                                                                                          });

                                                                                          // Now, delete the notification from the data source.
                                                                                          context.read<FriendListProvider>().deleteNotification(widget.user!.uid, notification);

                                                                                          showCustomSnackBar(context, "Notification deleted");
                                                                                        },
                                                                                        child: ListTile(
                                                                                            isThreeLine: false,
                                                                                            minVerticalPadding: 0,
                                                                                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                                                                            tileColor: const Color.fromARGB(117, 240, 240, 240),
                                                                                            dense: true,
                                                                                            horizontalTitleGap: 20,
                                                                                            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                                                                                            contentPadding: const EdgeInsets.fromLTRB(15, 12, 10, 12),
                                                                                            title: Expanded(
                                                                                                child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
                                                                                              Row(
                                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                children: [
                                                                                                  // Date part of notifications String
                                                                                                  Text(notifDate, maxLines: 2, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w900, fontSize: 17, wordSpacing: -3))
                                                                                                ],
                                                                                              )
                                                                                            ])),
                                                                                            subtitle: Expanded(
                                                                                              child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                                                                                                SizedBox(
                                                                                                    child: Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                  children: [
                                                                                                    Flexible(
                                                                                                        child: Padding(
                                                                                                      padding: const EdgeInsets.only(top: 5),
                                                                                                      // String part of the notification String
                                                                                                      child: Text((notification.substring(notification.indexOf('] ') + 1).trimLeft()), textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black87)),
                                                                                                    ))
                                                                                                  ],
                                                                                                ))
                                                                                              ]),
                                                                                            ))))
                                                                              ])));
                                                                    }
                                                                  });
                                                        }
                                                      }))))
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ]);
                    }
                  },
                ))));
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
