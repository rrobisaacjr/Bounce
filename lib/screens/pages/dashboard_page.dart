// package imports
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:intl/intl.dart';

//file imports
import '../../providers/auth_provider.dart';
import '../../providers/friend_provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key, required this.title, this.user});
  final String title;
  final User? user;

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _timeString = '';

  @override
  void initState() {
    super.initState();
  }

  Stream<String> createTimeStream() {
    return Stream.periodic(const Duration(seconds: 1), (int _) {
      final formattedDateTime = DateFormat('EEEE \nMMMM d, y \nh:mm:ss a')
          .format(DateTime.now().toLocal())
          .toString();
      return formattedDateTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = widget.user;
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
                TypewriterAnimatedText("Dashboard",
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
        actions: <Widget>[
          IconButton(
            padding: EdgeInsets.only(right: 20),
            icon: const Icon(
              Icons.logout,
              color: Colors.black,
            ),
            onPressed: () {
              showCustomSnackBar(context, "Signing out.");
              context.read<AuthProvider>().signOut();
            },
          )
        ],
      ),
      body: Center(
          child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics()),
              child: Card(
                // margin: const EdgeInsets.symmetric(vertical: 50),
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
                                child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 7),
                              child: StreamBuilder<DocumentSnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(widget.user?.uid)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  }

                                  final currentUserName = snapshot.data
                                      ?.get("displayName") as String;

                                  return Text(
                                    currentUserName != null
                                        ? "Hi, ${currentUserName.split(" ").sublist(0, 1).join("")}!"
                                        : "Hi, User!", // Default text if user is not authenticated
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                    maxLines: 2,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 30,
                                      wordSpacing: -10,
                                    ),
                                  );
                                },
                              ),
                            )),
                          ],
                        ),
                        StreamBuilder<String>(
                          stream: createTimeStream(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }
                            final timeString = snapshot.data ?? '';
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 7),
                              child: Text(
                                "Today is $timeString",
                                maxLines: 3,
                                style: const TextStyle(
                                  wordSpacing: -3,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          },
                        ),
                        const Divider(
                          height: 10,
                          color: Color.fromARGB(179, 240, 240, 240),
                        ),

                        // Dashboard Buttons
                        GridView(
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                          scrollDirection: Axis.vertical,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          children: [
                            // To [Profile Page] Button
                            Padding(
                                padding: const EdgeInsets.all(7),
                                child: Expanded(
                                    child: ElevatedButton(
                                        style: ButtonStyle(
                                            elevation:
                                                MaterialStateProperty.all(4),
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0)))),
                                        child: const Expanded(
                                            child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Spacer(
                                              flex: 1,
                                            ),
                                            Expanded(
                                                flex: 2,
                                                child: Icon(
                                                  Icons.face,
                                                  color: Colors.black,
                                                  size: 40,
                                                )),
                                            Expanded(
                                                flex: 2,
                                                child: Text("Profile",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20))),
                                          ],
                                        )),
                                        onPressed: () {
                                          Navigator.pushNamed(
                                            context,
                                            '/profile',
                                            arguments: currentUser,
                                          );
                                        }))),

                            // To [Friends Page] Button
                            Padding(
                                padding: const EdgeInsets.all(7),
                                child: Flex(
                                  direction: Axis.horizontal,
                                  children: [
                                    Expanded(
                                        child: ElevatedButton(
                                            style: ButtonStyle(
                                                elevation:
                                                    MaterialStateProperty.all(
                                                        4),
                                                shape: MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    10.0)))),
                                            child: const Expanded(
                                                child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Spacer(
                                                  flex: 1,
                                                ),
                                                Expanded(
                                                    flex: 2,
                                                    child: Icon(
                                                      Icons.emoji_people,
                                                      color: Colors.black,
                                                      size: 40,
                                                    )),
                                                Expanded(
                                                    flex: 2,
                                                    child: Text("Friends",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 20)))
                                              ],
                                            )),
                                            onPressed: () {
                                              Navigator.pushNamed(
                                                context,
                                                '/friends',
                                                arguments: currentUser,
                                              );
                                            }))
                                  ],
                                )),
                            // To [Todo Page] Button
                            Padding(
                                padding: const EdgeInsets.all(7),
                                child: Expanded(
                                    child: ElevatedButton(
                                        style: ButtonStyle(
                                            elevation:
                                                MaterialStateProperty.all(4),
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0)))),
                                        child: const Expanded(
                                            child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Spacer(
                                              flex: 1,
                                            ),
                                            Expanded(
                                                flex: 2,
                                                child: Icon(
                                                  Icons.note,
                                                  color: Colors.black,
                                                  size: 40,
                                                )),
                                            Expanded(
                                                flex: 2,
                                                child: Text("Tasks",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20)))
                                          ],
                                        )),
                                        onPressed: () {
                                          Navigator.pushNamed(
                                            context,
                                            '/tasks',
                                            arguments: currentUser,
                                          );
                                        }))),

                            // To [Notifs] Button
                            Padding(
                                padding: const EdgeInsets.all(7),
                                child: Expanded(
                                    child: ElevatedButton(
                                        style: ButtonStyle(
                                            elevation:
                                                MaterialStateProperty.all(4),
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0)))),
                                        child: const Expanded(
                                            child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Spacer(
                                              flex: 1,
                                            ),
                                            Expanded(
                                                flex: 2,
                                                child: Icon(
                                                  Icons.notifications,
                                                  color: Colors.black,
                                                  size: 40,
                                                )),
                                            Expanded(
                                                flex: 2,
                                                child: Text("Notifs",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20)))
                                          ],
                                        )),
                                        onPressed: () {
                                          Navigator.pushNamed(
                                            context,
                                            '/notifications',
                                            arguments: currentUser,
                                          );
                                        }))),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ))),
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
            // IconButton(
            //   padding: EdgeInsets.zero,
            //   color: Colors.white,
            //   constraints: const BoxConstraints(),
            //   icon: const Icon(Icons.close),
            //   onPressed: () {
            //     ScaffoldMessenger.of(context).hideCurrentSnackBar();
            //   },
            // ),
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
