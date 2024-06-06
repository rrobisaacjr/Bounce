// package imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:rounded_background_text/rounded_background_text.dart';

//file imports
import '../modals/modal_friend.dart';
import '../modals/modal_profile.dart';
import '../modals/modal_task_friend.dart';

const double borderRadius = 25.0;

class FriendPage extends StatefulWidget {
  const FriendPage({super.key, required this.title, required this.user});

  final String title;
  final User? user;

  @override
  State<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  late PageController _pageController;
  int activePageIndex = 0;

  final TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> userDocs = [];
  List<DocumentSnapshot> searchResults = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
    _pageController = PageController();
    // Initialize searchResults with all users
    searchResults = userDocs;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadUsers() async {
    final snapshot = await FirebaseFirestore.instance.collection('users').get();
    setState(() {
      userDocs = snapshot.docs;
    });
  }

  void _updateSearchResults(String query) {
    setState(() {
      searchResults = userDocs.where((doc) {
        final userName = doc['userName'] as String;

        // Show all users if the query is empty, or if their username contains the query
        return query.isEmpty ||
            userName.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                TypewriterAnimatedText("Friends",
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
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: PageView(
                    controller: _pageController,
                    physics: const ClampingScrollPhysics(),
                    onPageChanged: (int i) {
                      FocusScope.of(context).requestFocus(FocusNode());
                      setState(() {
                        activePageIndex = i;
                      });
                    },
                    children: <Widget>[
                      // -------------------------- USER FRIENDS -------------------------------------
                      ConstrainedBox(
                        constraints: const BoxConstraints.expand(),
                        child: Center(
                            child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.65,
                                child: Center(
                                    child: SingleChildScrollView(
                                        physics:
                                            const AlwaysScrollableScrollPhysics(
                                                parent:
                                                    BouncingScrollPhysics()),
                                        child: Center(
                                            child: Card(
                                          // margin:
                                          //     const EdgeInsets.fromLTRB(0, 100, 0, 50),
                                          child: SizedBox(
                                            width: 300,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(20.0),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      StreamBuilder<
                                                          DocumentSnapshot>(
                                                        stream:
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    "users")
                                                                .doc(widget
                                                                    .user?.uid)
                                                                .snapshots(),
                                                        builder: (context,
                                                            snapshot) {
                                                          if (snapshot
                                                                  .connectionState ==
                                                              ConnectionState
                                                                  .waiting) {
                                                            return CircularProgressIndicator();
                                                          }

                                                          final currentUserName =
                                                              snapshot.data?.get(
                                                                      "displayName")
                                                                  as String;

                                                          return Flexible(
                                                              child: Text(
                                                            // ignore: unnecessary_null_comparison
                                                            currentUserName !=
                                                                    null
                                                                ? "${currentUserName.split(" ").sublist(0, 1).join("")}'s Friends"
                                                                : "User's Friends", // Default text if user is not authenticated
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            softWrap: false,
                                                            maxLines: 2,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900,
                                                              fontSize: 30,
                                                              wordSpacing: -10,
                                                            ),
                                                          ));
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                  const Divider(
                                                    height: 10,
                                                    color: Color.fromARGB(
                                                        179, 240, 240, 240),
                                                  ),
                                                  Card(
                                                      elevation: 0,
                                                      color: Colors.transparent,
                                                      child: SizedBox(
                                                        width: 500,
                                                        //height: 250,
                                                        child: StreamBuilder(
                                                          stream:
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      "users")
                                                                  .doc(widget
                                                                      .user
                                                                      ?.uid)
                                                                  .snapshots(),
                                                          builder: (context,
                                                              snapshot) {
                                                            //print("Snapshot Value: ${snapshot.data}");
                                                            if (snapshot
                                                                .hasError) {
                                                              return Center(
                                                                child: Text(
                                                                    "Error encountered! ${snapshot.error}"),
                                                              );
                                                            } else if (snapshot
                                                                    .connectionState ==
                                                                ConnectionState
                                                                    .waiting) {
                                                              return const Center(
                                                                child:
                                                                    CircularProgressIndicator(),
                                                              );
                                                            } else if (!snapshot
                                                                .hasData) {
                                                              return const Center(
                                                                child: Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              10.0),
                                                                  child: Text(
                                                                      "No Friends Found"),
                                                                ),
                                                              );
                                                            } else {
                                                              final friendReferences = (snapshot
                                                                          .data
                                                                          ?.get(
                                                                              "friends")
                                                                      as List<
                                                                          dynamic>)
                                                                  .cast<
                                                                      DocumentReference>();

                                                              if (friendReferences
                                                                  .isEmpty) {
                                                                return const Center(
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            10.0),
                                                                    child: Text(
                                                                        "No Friends Found"),
                                                                  ),
                                                                );
                                                              }

                                                              return ListView
                                                                  .separated(
                                                                      separatorBuilder:
                                                                          (context,
                                                                              index) {
                                                                        return const Divider(
                                                                          color:
                                                                              Colors.transparent,
                                                                          height:
                                                                              5,
                                                                        );
                                                                      },
                                                                      shrinkWrap:
                                                                          true,
                                                                      itemCount:
                                                                          friendReferences
                                                                              .length,
                                                                      itemBuilder:
                                                                          ((context,
                                                                              index) {
                                                                        final friendRef =
                                                                            friendReferences[index];
                                                                        return StreamBuilder<
                                                                            DocumentSnapshot>(
                                                                          stream:
                                                                              friendRef.snapshots(),
                                                                          builder:
                                                                              (context, friendSnapshot) {
                                                                            if (friendSnapshot.connectionState ==
                                                                                ConnectionState.waiting) {
                                                                              return const CircularProgressIndicator();
                                                                            } else if (friendSnapshot.hasError) {
                                                                              return Text("Error: ${friendSnapshot.error}");
                                                                            } else {
                                                                              final friendData = friendSnapshot.data?.data() as Map<String, dynamic>?;

                                                                              final friendDisplayName = friendData?['displayName'] as String?;
                                                                              final friendUserName = friendData?['userName'] as String?;

                                                                              return ListTile(
                                                                                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                                                                  tileColor: const Color.fromARGB(117, 240, 240, 240),
                                                                                  dense: true,
                                                                                  horizontalTitleGap: 16,
                                                                                  visualDensity: const VisualDensity(horizontal: -4, vertical: -1),
                                                                                  contentPadding: const EdgeInsets.only(left: 10.0, right: 0.0),
                                                                                  title: Text(friendDisplayName ?? "Unknown", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, wordSpacing: -3)),
                                                                                  subtitle: RoundedBackgroundText(outerRadius: 20.0, innerRadius: 20.0, "@${friendUserName ?? "Unknown"}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black54), backgroundColor: const Color.fromARGB(255, 198, 255, 27)),
                                                                                  leading: IconButton(
                                                                                    onPressed: () {
                                                                                      _showFriendProfileDialog(context, friendRef);
                                                                                    },
                                                                                    padding: const EdgeInsets.all(0),
                                                                                    icon: const Icon(
                                                                                      Icons.account_circle_rounded,
                                                                                      size: 40,
                                                                                    ),
                                                                                  ),
                                                                                  trailing: Row(
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    children: [
                                                                                      IconButton(
                                                                                        padding: const EdgeInsets.fromLTRB(5, 0, 15, 0),
                                                                                        onPressed: () {
                                                                                          _showFriendTaskDialog(context, friendRef);
                                                                                        },
                                                                                        icon: const Icon(Icons.note),
                                                                                      ),
                                                                                      IconButton(
                                                                                        padding: const EdgeInsets.fromLTRB(5, 0, 15, 0),
                                                                                        onPressed: () {
                                                                                          showAnimatedDialog(
                                                                                            animationType: DialogTransitionType.fadeScale,
                                                                                            curve: Curves.decelerate,
                                                                                            context: context,
                                                                                            barrierDismissible: true,
                                                                                            builder: (BuildContext context) => FriendModal(friendReference: friendRef, type: 'Delete friend'),
                                                                                          );
                                                                                        },
                                                                                        icon: const Icon(Icons.person_remove_rounded),
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
                                        )))))),
                      ),

                      // --------------------------USER FRIENDS SENT REQUESTS-------------------------------------
                      ConstrainedBox(
                          constraints: const BoxConstraints.expand(),
                          child: Center(
                              child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.65,
                            child: Center(
                                child: SingleChildScrollView(
                                    physics:
                                        const AlwaysScrollableScrollPhysics(
                                            parent: BouncingScrollPhysics()),
                                    child: Center(
                                        child: Card(
                                      // margin:
                                      //     const EdgeInsets.symmetric(vertical: 100),
                                      child: SizedBox(
                                        width: 300,
                                        child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Column(
                                            children: [
                                              const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text("Sent Requests",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          fontSize: 27,
                                                          wordSpacing: -3))
                                                ],
                                              ),
                                              const Divider(
                                                height: 10,
                                                color: Color.fromARGB(
                                                    179, 240, 240, 240),
                                              ),
                                              Card(
                                                  elevation: 0,
                                                  color: Colors.transparent,
                                                  child: SizedBox(
                                                    width: 500,
                                                    //height: 250,
                                                    child: StreamBuilder(
                                                      stream: FirebaseFirestore
                                                          .instance
                                                          .collection("users")
                                                          .doc(widget.user?.uid)
                                                          .snapshots(),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot.hasError) {
                                                          return Center(
                                                            child: Text(
                                                                "Error encountered! ${snapshot.error}"),
                                                          );
                                                        } else if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          return const Center(
                                                            child:
                                                                CircularProgressIndicator(),
                                                          );
                                                        } else if (!snapshot
                                                            .hasData) {
                                                          return const Center(
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(
                                                                          10.0),
                                                              child: Expanded(
                                                                  child: Text(
                                                                      "No sent request")),
                                                            ),
                                                          );
                                                        } else {
                                                          final sentFriendRequests =
                                                              (snapshot.data?.get(
                                                                          "sentFriendRequest")
                                                                      as List<
                                                                          dynamic>)
                                                                  .cast<
                                                                      DocumentReference>();

                                                          if (sentFriendRequests
                                                              .isEmpty) {
                                                            return const Center(
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            10.0),
                                                                child: Text(
                                                                    "No sent friend request"),
                                                              ),
                                                            );
                                                          }

                                                          return ListView
                                                              .separated(
                                                                  separatorBuilder:
                                                                      (context,
                                                                          index) {
                                                                    return const Divider(
                                                                      color: Colors
                                                                          .transparent,
                                                                      height: 5,
                                                                    );
                                                                  },
                                                                  shrinkWrap:
                                                                      true,
                                                                  itemCount:
                                                                      sentFriendRequests
                                                                          .length,
                                                                  itemBuilder:
                                                                      ((context,
                                                                          index) {
                                                                    final friendRef =
                                                                        sentFriendRequests[
                                                                            index];
                                                                    return StreamBuilder<
                                                                        DocumentSnapshot>(
                                                                      stream: friendRef
                                                                          .snapshots(),
                                                                      builder:
                                                                          (context,
                                                                              friendSnapshot) {
                                                                        if (friendSnapshot.connectionState ==
                                                                            ConnectionState
                                                                                .waiting) {
                                                                          return const CircularProgressIndicator();
                                                                        } else if (friendSnapshot
                                                                            .hasError) {
                                                                          return Text(
                                                                              "Error: ${friendSnapshot.error}");
                                                                        } else {
                                                                          final friendData = friendSnapshot.data?.data() as Map<
                                                                              String,
                                                                              dynamic>?; // Explicit cast here

                                                                          final friendDisplayName =
                                                                              friendData?['displayName'] as String?;
                                                                          final friendUserName =
                                                                              friendData?['userName'] as String?;

                                                                          return ListTile(
                                                                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                                                              tileColor: const Color.fromARGB(117, 240, 240, 240),
                                                                              dense: true,
                                                                              horizontalTitleGap: 16,
                                                                              visualDensity: const VisualDensity(horizontal: -4, vertical: -1),
                                                                              contentPadding: const EdgeInsets.only(left: 10.0, right: 0.0),
                                                                              title: Text(friendDisplayName ?? "Unknown", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, wordSpacing: -3)),
                                                                              subtitle: RoundedBackgroundText(outerRadius: 20.0, innerRadius: 20.0, "@${friendUserName ?? "Unknown"}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black54), backgroundColor: const Color.fromARGB(255, 198, 255, 27)),
                                                                              leading: IconButton(
                                                                                onPressed: () {
                                                                                  _showFriendProfileDialog(context, friendRef);
                                                                                },
                                                                                padding: const EdgeInsets.all(0),
                                                                                icon: const Icon(
                                                                                  Icons.account_circle_rounded,
                                                                                  size: 40,
                                                                                ),
                                                                              ),
                                                                              trailing: Row(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                children: [
                                                                                  IconButton(
                                                                                    padding: const EdgeInsets.fromLTRB(5, 0, 15, 0),
                                                                                    onPressed: () {
                                                                                      showAnimatedDialog(
                                                                                        animationType: DialogTransitionType.fadeScale,
                                                                                        curve: Curves.decelerate,
                                                                                        context: context,
                                                                                        barrierDismissible: true,
                                                                                        builder: (BuildContext context) => FriendModal(friendReference: friendRef, type: 'Cancel friend request'),
                                                                                      );
                                                                                    },
                                                                                    icon: const Icon(Icons.delete),
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
                                    )))),
                          ))),

                      // --------------------------USER FRIENDS RECEIVED REQUESTS-------------------------------------
                      ConstrainedBox(
                          constraints: const BoxConstraints.expand(),
                          child: Center(
                              child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.65,
                                  child: Center(
                                      child: SingleChildScrollView(
                                          physics:
                                              const AlwaysScrollableScrollPhysics(
                                                  parent:
                                                      BouncingScrollPhysics()),
                                          child: Center(
                                            child: Card(
                                                // margin: const EdgeInsets.symmetric(
                                                //     vertical: 100),
                                                child: SizedBox(
                                              width: 300,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(20.0),
                                                child: Column(
                                                  children: [
                                                    const Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text("Friend Requests",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w900,
                                                                fontSize: 27,
                                                                wordSpacing:
                                                                    -3))
                                                      ],
                                                    ),
                                                    const Divider(
                                                      height: 10,
                                                      color: Color.fromARGB(
                                                          179, 240, 240, 240),
                                                    ),
                                                    Card(
                                                        elevation: 0,
                                                        color:
                                                            Colors.transparent,
                                                        child: SizedBox(
                                                          width: 500,
                                                          //height: 250,
                                                          child: StreamBuilder(
                                                            stream:
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        "users")
                                                                    .doc(widget
                                                                        .user
                                                                        ?.uid)
                                                                    .snapshots(),
                                                            builder: (context,
                                                                snapshot) {
                                                              if (snapshot
                                                                  .hasError) {
                                                                return Center(
                                                                  child: Text(
                                                                      "Error encountered! ${snapshot.error}"),
                                                                );
                                                              } else if (snapshot
                                                                      .connectionState ==
                                                                  ConnectionState
                                                                      .waiting) {
                                                                return const Center(
                                                                  child:
                                                                      CircularProgressIndicator(),
                                                                );
                                                              } else if (!snapshot
                                                                  .hasData) {
                                                                return const Center(
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            10.0),
                                                                    child: Text(
                                                                        "No Friend Request"),
                                                                  ),
                                                                );
                                                              } else {
                                                                final receivedFriendRequests = (snapshot
                                                                        .data
                                                                        ?.get(
                                                                            "receivedFriendRequest") as List<
                                                                        dynamic>)
                                                                    .cast<
                                                                        DocumentReference>();

                                                                if (receivedFriendRequests
                                                                    .isEmpty) {
                                                                  return const Center(
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              10.0),
                                                                      child: Text(
                                                                          "No received friend request"),
                                                                    ),
                                                                  );
                                                                }

                                                                return ListView
                                                                    .separated(
                                                                        separatorBuilder:
                                                                            (context,
                                                                                index) {
                                                                          return const Divider(
                                                                            color:
                                                                                Colors.transparent,
                                                                            height:
                                                                                5,
                                                                          );
                                                                        },
                                                                        shrinkWrap:
                                                                            true,
                                                                        itemCount:
                                                                            receivedFriendRequests
                                                                                .length,
                                                                        itemBuilder:
                                                                            ((context,
                                                                                index) {
                                                                          final friendRef =
                                                                              receivedFriendRequests[index];
                                                                          return StreamBuilder<
                                                                              DocumentSnapshot>(
                                                                            stream:
                                                                                friendRef.snapshots(),
                                                                            builder:
                                                                                (context, friendSnapshot) {
                                                                              if (friendSnapshot.connectionState == ConnectionState.waiting) {
                                                                                return const CircularProgressIndicator();
                                                                              } else if (friendSnapshot.hasError) {
                                                                                return Text("Error: ${friendSnapshot.error}");
                                                                              } else {
                                                                                final friendData = friendSnapshot.data?.data() as Map<String, dynamic>?; // Explicit cast here

                                                                                final friendDisplayName = friendData?['displayName'] as String?;
                                                                                final friendUserName = friendData?['userName'] as String?;

                                                                                return ListTile(
                                                                                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                                                                    tileColor: const Color.fromARGB(117, 240, 240, 240),
                                                                                    dense: true,
                                                                                    horizontalTitleGap: 16,
                                                                                    visualDensity: const VisualDensity(horizontal: -4, vertical: -1),
                                                                                    contentPadding: const EdgeInsets.only(left: 10.0, right: 0.0),
                                                                                    title: Text(friendDisplayName ?? "Unknown", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, wordSpacing: -3)),
                                                                                    subtitle: RoundedBackgroundText(outerRadius: 20.0, innerRadius: 20.0, "@${friendUserName ?? "Unknown"}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black54), backgroundColor: const Color.fromARGB(255, 198, 255, 27)),
                                                                                    leading: IconButton(
                                                                                      onPressed: () {
                                                                                        _showFriendProfileDialog(context, friendRef);
                                                                                      },
                                                                                      padding: const EdgeInsets.all(0),
                                                                                      icon: const Icon(
                                                                                        Icons.account_circle_rounded,
                                                                                        size: 40,
                                                                                      ),
                                                                                    ),
                                                                                    trailing: Row(
                                                                                      mainAxisSize: MainAxisSize.min,
                                                                                      children: [
                                                                                        IconButton(
                                                                                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                                                                                          constraints: const BoxConstraints(),
                                                                                          onPressed: () {
                                                                                            showAnimatedDialog(
                                                                                              animationType: DialogTransitionType.fadeScale,
                                                                                              curve: Curves.decelerate,
                                                                                              context: context,
                                                                                              barrierDismissible: true,
                                                                                              builder: (BuildContext context) => FriendModal(friendReference: friendRef, type: 'Accept friend request'),
                                                                                            );
                                                                                          },
                                                                                          icon: const Icon(Icons.check_rounded),
                                                                                        ),
                                                                                        IconButton(
                                                                                          padding: const EdgeInsets.fromLTRB(5, 0, 15, 0),
                                                                                          onPressed: () {
                                                                                            showAnimatedDialog(
                                                                                              animationType: DialogTransitionType.fadeScale,
                                                                                              curve: Curves.decelerate,
                                                                                              context: context,
                                                                                              barrierDismissible: true,
                                                                                              builder: (BuildContext context) => FriendModal(friendReference: friendRef, type: 'Reject friend request'),
                                                                                            );
                                                                                          },
                                                                                          icon: const Icon(Icons.close_rounded),
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
                                            )),
                                          )))))),

                      // --------------------------USER ADD FRIENDS-------------------------------------
                      ConstrainedBox(
                          constraints: const BoxConstraints.expand(),
                          child: Center(
                              child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.65,
                            child: Center(
                                child: SingleChildScrollView(
                                    physics:
                                        const AlwaysScrollableScrollPhysics(
                                            parent: BouncingScrollPhysics()),
                                    child: Center(
                                      child: Card(
                                          // margin:
                                          //     const EdgeInsets.symmetric(vertical: 100),
                                          child: SizedBox(
                                        width: 300,
                                        child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Column(
                                            children: [
                                              const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text("Add Friends",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          fontSize: 27,
                                                          wordSpacing: -3))
                                                ],
                                              ),
                                              const Divider(
                                                height: 10,
                                                color: Color.fromARGB(
                                                    179, 240, 240, 240),
                                              ),
                                              SizedBox(
                                                  width: 500,
                                                  height: 250,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Expanded(
                                                        flex: -1,
                                                        child: TextField(
                                                          controller:
                                                              _searchController,
                                                          onChanged:
                                                              _updateSearchResults,
                                                          decoration:
                                                              const InputDecoration(
                                                            labelText:
                                                                'Search for friends',
                                                            prefixIcon: Icon(
                                                                Icons.search),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Expanded(
                                                          child: StreamBuilder<
                                                                  QuerySnapshot>(
                                                              stream: FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'users')
                                                                  .snapshots(),
                                                              builder: (context,
                                                                  snapshot) {
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
                                                                } else {
                                                                  final users =
                                                                      snapshot
                                                                          .data!
                                                                          .docs;

                                                                  return ListView
                                                                      .separated(
                                                                    separatorBuilder:
                                                                        (context,
                                                                            index) {
                                                                      return const Divider(
                                                                        color: Colors
                                                                            .transparent,
                                                                        height:
                                                                            5,
                                                                      );
                                                                    },
                                                                    itemCount:
                                                                        searchResults
                                                                            .length,
                                                                    itemBuilder:
                                                                        (context,
                                                                            index) {
                                                                      final userData = searchResults[index]
                                                                              .data()
                                                                          as Map<
                                                                              String,
                                                                              dynamic>;
                                                                      final userDisplayName =
                                                                          userData['displayName']
                                                                              as String;
                                                                      final userName =
                                                                          userData['userName']
                                                                              as String;
                                                                      final friendReference =
                                                                          searchResults[index]
                                                                              .reference;

                                                                      return Material(
                                                                        child:
                                                                            ListTile(
                                                                          shape:
                                                                              const RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.all(Radius.circular(10)),
                                                                          ),
                                                                          tileColor: const Color.fromARGB(
                                                                              117,
                                                                              240,
                                                                              240,
                                                                              240),
                                                                          dense:
                                                                              true,
                                                                          horizontalTitleGap:
                                                                              16,
                                                                          visualDensity:
                                                                              const VisualDensity(
                                                                            horizontal:
                                                                                -4,
                                                                            vertical:
                                                                                -1,
                                                                          ),
                                                                          contentPadding:
                                                                              const EdgeInsets.only(
                                                                            left:
                                                                                10.0,
                                                                            right:
                                                                                0.0,
                                                                          ),
                                                                          title:
                                                                              Text(
                                                                            userDisplayName,
                                                                            style:
                                                                                const TextStyle(
                                                                              fontWeight: FontWeight.w900,
                                                                              fontSize: 15,
                                                                              wordSpacing: -3,
                                                                            ),
                                                                          ),
                                                                          subtitle:
                                                                              RoundedBackgroundText(
                                                                            outerRadius:
                                                                                20.0,
                                                                            innerRadius:
                                                                                20.0,
                                                                            "@$userName",
                                                                            style:
                                                                                const TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 13,
                                                                              color: Colors.black54,
                                                                            ),
                                                                            backgroundColor: const Color.fromARGB(
                                                                                255,
                                                                                198,
                                                                                255,
                                                                                27),
                                                                          ),
                                                                          leading:
                                                                              IconButton(
                                                                            onPressed:
                                                                                () {
                                                                              _showFriendProfileDialog(context, friendReference);
                                                                            },
                                                                            padding:
                                                                                const EdgeInsets.all(0),
                                                                            icon:
                                                                                const Icon(
                                                                              Icons.account_circle_rounded,
                                                                              size: 40,
                                                                            ),
                                                                          ),
                                                                          trailing:
                                                                              Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            children: [
                                                                              IconButton(
                                                                                padding: const EdgeInsets.fromLTRB(5, 0, 15, 0),
                                                                                onPressed: () {
                                                                                  showAnimatedDialog(
                                                                                    animationType: DialogTransitionType.fadeScale,
                                                                                    curve: Curves.decelerate,
                                                                                    context: context,
                                                                                    barrierDismissible: true,
                                                                                    builder: (BuildContext context) => FriendModal(
                                                                                      friendReference: friendReference,
                                                                                      type: 'Add friend',
                                                                                    ),
                                                                                  );
                                                                                },
                                                                                icon: const Icon(Icons.add),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  );
                                                                }
                                                              }))
                                                    ],
                                                  ))
                                            ],
                                          ),
                                        ),
                                      )),
                                    ))),
                          )))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      floatingActionButton: Padding(
          padding: EdgeInsets.only(top: 200),
          child: SizedBox(child: _menuBar(context))),
    );
  }

  Widget _menuBar(BuildContext context) {
    return Container(
      width: 300.0,
      height: 50.0,
      decoration: const BoxDecoration(
        color: Color(0XFFE0E0E0),
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: InkWell(
              borderRadius:
                  const BorderRadius.all(Radius.circular(borderRadius)),
              onTap: _onUserFriendsPress,
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 15),
                alignment: Alignment.center,
                decoration: (activePageIndex == 0)
                    ? const BoxDecoration(
                        color: Colors.black87,
                        borderRadius:
                            BorderRadius.all(Radius.circular(borderRadius)),
                      )
                    : null,
                child: Icon(
                  Icons.people_alt_rounded,
                  color: (activePageIndex == 0) ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              borderRadius:
                  const BorderRadius.all(Radius.circular(borderRadius)),
              onTap: _onUserSentRequestsPress,
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 15),
                alignment: Alignment.center,
                decoration: (activePageIndex == 1)
                    ? const BoxDecoration(
                        color: Colors.black87,
                        borderRadius:
                            BorderRadius.all(Radius.circular(borderRadius)),
                      )
                    : null,
                child: Icon(
                  Icons.call_made_rounded,
                  color: (activePageIndex == 1) ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              borderRadius:
                  const BorderRadius.all(Radius.circular(borderRadius)),
              onTap: _onUserFriendRequestsPress,
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 15),
                alignment: Alignment.center,
                decoration: (activePageIndex == 2)
                    ? const BoxDecoration(
                        color: Colors.black87,
                        borderRadius:
                            BorderRadius.all(Radius.circular(borderRadius)),
                      )
                    : null,
                child: Icon(
                  Icons.call_received_rounded,
                  color: (activePageIndex == 2) ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              borderRadius:
                  const BorderRadius.all(Radius.circular(borderRadius)),
              onTap: _onUserAddFriendsPress,
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 15),
                alignment: Alignment.center,
                decoration: (activePageIndex == 3)
                    ? const BoxDecoration(
                        color: Colors.black87,
                        borderRadius:
                            BorderRadius.all(Radius.circular(borderRadius)),
                      )
                    : null,
                child: Icon(
                  Icons.person_add_alt_1_rounded,
                  color: (activePageIndex == 3) ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onUserFriendsPress() {
    _pageController.animateToPage(0,
        duration: const Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _onUserSentRequestsPress() {
    _pageController.animateToPage(1,
        duration: const Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _onUserFriendRequestsPress() {
    _pageController.animateToPage(2,
        duration: const Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _onUserAddFriendsPress() {
    _pageController.animateToPage(3,
        duration: const Duration(milliseconds: 500), curve: Curves.decelerate);
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

  void showCustomSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
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
        // margin: EdgeInsets.only(
        //   bottom: MediaQuery.of(context).size.height * 0.72,
        //   right: 40,
        //   left: 40,
        // ),
      ),
    );
  }
}
