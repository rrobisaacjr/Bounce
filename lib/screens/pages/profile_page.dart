// package imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.title, required this.user});
  final String title;
  final User? user;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
                  TypewriterAnimatedText("Profile",
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
                child: StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .doc(widget.user?.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      final currentUserData = snapshot.data;
                      final displayName =
                          currentUserData?['displayName'] ?? 'User';
                      final userName = currentUserData?['userName'] ?? '@user';
                      final firstName = currentUserData?['firstName'] ?? 'User';
                      final location =
                          currentUserData?['location'] ?? 'Hello World';
                      final birthDate =
                          currentUserData?['birthDate'] ?? 'December 12, 2012';
                      final bio = currentUserData?['bio'] ?? 'No bio yet';
                      final bool status =
                          currentUserData?['status'] ?? 'In Progress';

                      return Column(children: [
                        Card(
                          margin: const EdgeInsets.fromLTRB(0, 50, 0, 25),
                          child: SizedBox(
                            width: 300,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.account_circle_rounded,
                                    size: 100,
                                  ),
                                  // Dashboard Greeting and Time Text
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Text(displayName,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w900,
                                                fontSize: 30,
                                                wordSpacing: -3)),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex: -1,
                                        child: Text('@$userName\t',
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w900,
                                                fontSize: 20)),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        flex: -1,
                                        child: status
                                            ? RoundedBackgroundText(
                                                outerRadius: 20.0,
                                                innerRadius: 20.0,
                                                "active",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontFamily:
                                                        GoogleFonts.robotoMono()
                                                            .fontFamily,
                                                    fontWeight: FontWeight.w900,
                                                    fontSize: 15),
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 198, 255, 27))
                                            : RoundedBackgroundText(
                                                outerRadius: 20.0,
                                                innerRadius: 20.0,
                                                "inactive",
                                                style: TextStyle(
                                                    fontFamily:
                                                        GoogleFonts.robotoMono()
                                                            .fontFamily,
                                                    fontWeight: FontWeight.w900,
                                                    fontSize: 15),
                                                backgroundColor:
                                                    Colors.black87),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Text("\"$bio\"",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w900,
                                                fontSize: 15,
                                                wordSpacing: -3)),
                                      )
                                    ],
                                  ),
                                  const Divider(
                                    height: 10,
                                    color: Color.fromARGB(179, 240, 240, 240),
                                  ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Text("Lives in $location",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w900,
                                                fontSize: 15,
                                                wordSpacing: -3)),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Text("Born on $birthDate",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w900,
                                                fontSize: 15,
                                                wordSpacing: -3)),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Text("UID: ${widget.user?.uid}",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                height: 2,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 10)),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            5, 20, 5, 5),
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 198, 255, 27)),
                                            onPressed: (() async {
                                              final changesSaved =
                                                  await showAnimatedDialog(
                                                      animationType:
                                                          DialogTransitionType
                                                              .slideFromBottomFade,
                                                      curve: Curves.decelerate,
                                                      context: context,
                                                      barrierDismissible: true,
                                                      builder: (BuildContext
                                                              context) =>
                                                          EditProfileModal(
                                                              userId: widget
                                                                  .user!.uid,
                                                              currentUserDataFuture:
                                                                  currentUserDataFuture));
                                            }),
                                            child: const SizedBox(
                                                height: 40,
                                                child: Center(
                                                    child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 10),
                                                      child: Icon(
                                                        Icons.edit_rounded,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 10),
                                                        child: Text(
                                                            'Edit Profile',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900,
                                                              fontSize: 20,
                                                            )))
                                                  ],
                                                )))),
                                      ))
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Card(
                          margin: const EdgeInsets.only(bottom: 50),
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
                                        child: Text('Your friends',
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
                                                  padding: EdgeInsets.all(10.0),
                                                  child:
                                                      Text("No Friends Found"),
                                                ),
                                              );
                                            } else {
                                              final friendReferences = (snapshot
                                                          .data
                                                          ?.get("friends")
                                                      as List<dynamic>)
                                                  .cast<DocumentReference>();

                                              if (friendReferences.isEmpty) {
                                                return Center(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Text(
                                                        "$firstName has no friends yet."),
                                                  ),
                                                );
                                              }

                                              return ListView.separated(
                                                  separatorBuilder:
                                                      (context, index) {
                                                    return const Divider(
                                                      color: Colors.transparent,
                                                      height: 5,
                                                    );
                                                  },
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      friendReferences.length,
                                                  itemBuilder:
                                                      ((context, index) {
                                                    final friendRef =
                                                        friendReferences[index];
                                                    return StreamBuilder<
                                                        DocumentSnapshot>(
                                                      stream:
                                                          friendRef.snapshots(),
                                                      initialData: null,
                                                      builder: (context,
                                                          friendSnapshot) {
                                                        if (friendSnapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          return const CircularProgressIndicator();
                                                        } else if (friendSnapshot
                                                            .hasError) {
                                                          return Text(
                                                              "Error: ${friendSnapshot.error}");
                                                        } else {
                                                          final friendData =
                                                              friendSnapshot
                                                                      .data
                                                                      ?.data()
                                                                  as Map<String,
                                                                      dynamic>?;

                                                          final friendDisplayName =
                                                              friendData?[
                                                                      'displayName']
                                                                  as String?;
                                                          final friendUserName =
                                                              friendData?[
                                                                      'userName']
                                                                  as String?;

                                                          return ListTile(
                                                              shape: const RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              10))),
                                                              tileColor:
                                                                  const Color.fromARGB(
                                                                      117,
                                                                      240,
                                                                      240,
                                                                      240),
                                                              dense: true,
                                                              horizontalTitleGap:
                                                                  16,
                                                              visualDensity: const VisualDensity(
                                                                  horizontal:
                                                                      -4,
                                                                  vertical: -1),
                                                              contentPadding: const EdgeInsets.only(
                                                                  left: 10.0,
                                                                  right: 0.0),
                                                              title: Text(
                                                                  friendDisplayName ??
                                                                      "Unknown",
                                                                  style: const TextStyle(
                                                                      fontWeight: FontWeight.w900,
                                                                      fontSize: 15,
                                                                      wordSpacing: -3)),
                                                              subtitle: RoundedBackgroundText(outerRadius: 20.0, innerRadius: 20.0, "@${friendUserName ?? "Unknown"}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black54), backgroundColor: const Color.fromARGB(255, 198, 255, 27)),
                                                              leading: IconButton(
                                                                onPressed: () {
                                                                  _showFriendProfileDialog(
                                                                      context,
                                                                      friendRef);
                                                                },
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(0),
                                                                icon:
                                                                    const Icon(
                                                                  Icons
                                                                      .account_circle_rounded,
                                                                  size: 40,
                                                                ),
                                                              ),
                                                              trailing: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  IconButton(
                                                                    padding:
                                                                        const EdgeInsets.fromLTRB(
                                                                            5,
                                                                            0,
                                                                            15,
                                                                            0),
                                                                    onPressed:
                                                                        () {
                                                                      _showFriendTaskDialog(
                                                                          context,
                                                                          friendRef);
                                                                    },
                                                                    icon: const Icon(
                                                                        Icons
                                                                            .note),
                                                                  ),
                                                                  IconButton(
                                                                    padding:
                                                                        const EdgeInsets.fromLTRB(
                                                                            5,
                                                                            0,
                                                                            15,
                                                                            0),
                                                                    onPressed:
                                                                        () {
                                                                      showAnimatedDialog(
                                                                        animationType:
                                                                            DialogTransitionType.fadeScale,
                                                                        curve: Curves
                                                                            .decelerate,
                                                                        context:
                                                                            context,
                                                                        barrierDismissible:
                                                                            true,
                                                                        builder: (BuildContext context) => FriendModal(
                                                                            friendReference:
                                                                                friendRef,
                                                                            type:
                                                                                'Delete friend'),
                                                                      );
                                                                    },
                                                                    icon: const Icon(
                                                                        Icons
                                                                            .person_remove_rounded),
                                                                  )
                                                                ],
                                                              ));
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
                    }))));
  }

  void _showFriendProfileDialog(
      BuildContext context, DocumentReference friendRef) {
    showAnimatedDialog(
        animationType: DialogTransitionType.slideFromBottomFade,
        curve: Curves.decelerate,
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) =>
            FriendProfileModal(friendRef: friendRef));
  }

  void _showFriendTaskDialog(
      BuildContext context, DocumentReference friendRef) {
    showAnimatedDialog(
        animationType: DialogTransitionType.slideFromBottomFade,
        curve: Curves.decelerate,
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) => FriendTaskModal(
              friendRef: friendRef,
              user: widget.user,
            ));
  }
}
