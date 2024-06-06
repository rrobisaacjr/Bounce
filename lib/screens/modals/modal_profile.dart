// package imports
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rounded_background_text/rounded_background_text.dart'; // Import FirebaseFirestore

const double borderRadius = 25.0;

class FriendProfileModal extends StatefulWidget {
  const FriendProfileModal({Key? key, required this.friendRef})
      : super(key: key);
  final DocumentReference friendRef; // Receive the friendRef

  @override
  State<FriendProfileModal> createState() => FriendProfileModalState();
}

class FriendProfileModalState extends State<FriendProfileModal> {
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
            final friendLocation = friendData?['location'];
            final friendBirthDate = friendData?['birthDate'];
            final bool friendStatus = friendData?['status'];
            final friendBio = friendData?['bio'] ?? 'No bio yet.';
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
                      margin: const EdgeInsets.only(bottom: 10),
                      child: SizedBox(
                        width: 300,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.account_circle_rounded,
                                size: 100,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(friendDisplayName,
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
                                    child: Text('@$friendUserName\t',
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w900,
                                            fontSize: 20,
                                            wordSpacing: -10)),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    flex: -1,
                                    child: friendStatus
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
                                                fontSize: 15,
                                                wordSpacing: -10),
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
                                                fontSize: 15,
                                                wordSpacing: -10),
                                            backgroundColor: Colors.black87),
                                  )
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text("\"$friendBio\"",
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
                                    child: Text("Lives in $friendLocation",
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
                                    child: Text("Born on $friendBirthDate",
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
                                    child: Text("UID: $friendUid",
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
                            ],
                          ),
                        ),
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
                                    child: Text('Friends with',
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
                                        } else if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        } else if (!snapshot.hasData) {
                                          return const Center(
                                            child: Padding(
                                              padding: EdgeInsets.all(10.0),
                                              child: Text("No Friends Found"),
                                            ),
                                          );
                                        } else {
                                          final friendReferences =
                                              (snapshot.data?.get("friends")
                                                      as List<dynamic>)
                                                  .cast<DocumentReference>();

                                          if (friendReferences.isEmpty) {
                                            return Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Text(
                                                    "$friendFirstName has no friends yet."),
                                              ),
                                            );
                                          }

                                          return SizedBox(
                                              height: 65,
                                              child: MediaQuery.removePadding(
                                                  context: context,
                                                  removeTop: true,
                                                  child: Scrollbar(
                                                      controller:
                                                          _scrollController,
                                                      thumbVisibility: true,
                                                      interactive: true,
                                                      child: ListView.separated(
                                                          controller:
                                                              _scrollController,
                                                          physics:
                                                              const AlwaysScrollableScrollPhysics(
                                                                  parent:
                                                                      BouncingScrollPhysics()),
                                                          separatorBuilder:
                                                              (context, index) {
                                                            return const Divider(
                                                              color: Colors
                                                                  .transparent,
                                                              height: 5,
                                                            );
                                                          },
                                                          shrinkWrap: true,
                                                          itemCount:
                                                              friendReferences
                                                                  .length,
                                                          // friendReferences.length < 2
                                                          //     ? friendReferences.length
                                                          //     : 2,
                                                          itemBuilder:
                                                              ((context,
                                                                  index) {
                                                            final otherFriendRef =
                                                                friendReferences[
                                                                    index];
                                                            return StreamBuilder<
                                                                DocumentSnapshot>(
                                                              stream:
                                                                  otherFriendRef
                                                                      .snapshots(),
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
                                                                  final friendData = friendSnapshot
                                                                          .data
                                                                          ?.data()
                                                                      as Map<
                                                                          String,
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
                                                                            BorderRadius.all(Radius.circular(10))),
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
                                                                        vertical:
                                                                            -1),
                                                                    contentPadding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10.0,
                                                                        right:
                                                                            0.0),
                                                                    title: Text(
                                                                        friendDisplayName ??
                                                                            "Unknown",
                                                                        style: const TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .w900,
                                                                            fontSize:
                                                                                15,
                                                                            wordSpacing:
                                                                                -3)),
                                                                    subtitle: RoundedBackgroundText(
                                                                        outerRadius:
                                                                            20.0,
                                                                        innerRadius:
                                                                            20.0,
                                                                        "@${friendUserName ?? "Unknown"}",
                                                                        style: const TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                13,
                                                                            color: Colors
                                                                                .black54),
                                                                        backgroundColor: const Color.fromARGB(
                                                                            255,
                                                                            198,
                                                                            255,
                                                                            27)),
                                                                    leading: IconButton(
                                                                        onPressed: () {
                                                                          _showFriendProfileDialog(
                                                                              context,
                                                                              otherFriendRef);
                                                                        },
                                                                        padding: const EdgeInsets.all(0),
                                                                        icon: const Icon(
                                                                          Icons
                                                                              .account_circle_rounded,
                                                                          size:
                                                                              40,
                                                                        )),
                                                                  );
                                                                }
                                                              },
                                                            );
                                                          })))));
                                        }
                                      },
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // const SizedBox(height: 5),
                    // Card(
                    //   child: SizedBox(
                    //     width: 300,
                    //     child: Padding(
                    //       padding: const EdgeInsets.all(15.0),
                    //       child: Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           // Dashboard Greeting and Time Text
                    //           Row(
                    //             mainAxisAlignment: MainAxisAlignment.center,
                    //             children: [
                    //               Expanded(
                    //                 child: Text('$friendFirstName\'s Notes',
                    //                     overflow: TextOverflow.ellipsis,
                    //                     softWrap: false,
                    //                     textAlign: TextAlign.center,
                    //                     style: const TextStyle(
                    //                         fontWeight: FontWeight.w900,
                    //                         fontSize: 30,
                    //                         wordSpacing: -3)),
                    //               )
                    //             ],
                    //           ),

                    // Card(
                    //     elevation: 0,
                    //     color: Colors.transparent,
                    //     child: SizedBox(
                    //       width: 500,
                    //       //height: 250,
                    //       child: StreamBuilder(
                    //         stream: FirebaseFirestore.instance
                    //             .collection("users")
                    //             .doc(friendUid)
                    //             .snapshots(),
                    //         initialData: null,
                    //         builder: (context, snapshot) {
                    //           if (snapshot.hasError) {
                    //             return Center(
                    //               child: Text(
                    //                   "Error encountered! ${snapshot.error}"),
                    //             );
                    //           } else if (snapshot.connectionState ==
                    //               ConnectionState.waiting) {
                    //             return const Center(
                    //               child: CircularProgressIndicator(),
                    //             );
                    //           } else if (!snapshot.hasData) {
                    //             return const Center(
                    //               child: Padding(
                    //                 padding: EdgeInsets.all(10.0),
                    //                 child: Text("No Friends Found"),
                    //               ),
                    //             );
                    //           } else {
                    //             final friendReferences =
                    //                 (snapshot.data?.get("friends")
                    //                         as List<dynamic>)
                    //                     .cast<DocumentReference>();

                    //             if (friendReferences.isEmpty) {
                    //               return Center(
                    //                 child: Padding(
                    //                   padding:
                    //                       const EdgeInsets.all(10.0),
                    //                   child: Text(
                    //                       "$friendFirstName has no notes."),
                    //                 ),
                    //               );
                    //             }

                    //             return SizedBox(
                    //                 height: 65,
                    //                 child: MediaQuery.removePadding(
                    //                     context: context,
                    //                     removeTop: true,
                    //                     child: Scrollbar(
                    //                         controller:
                    //                             _scrollController2,
                    //                         thumbVisibility: true,
                    //                         interactive: true,
                    //                         child: ListView.separated(
                    //                             controller:
                    //                                 _scrollController2,
                    //                             physics:
                    //                                 const AlwaysScrollableScrollPhysics(
                    //                                     parent:
                    //                                         BouncingScrollPhysics()),
                    //                             separatorBuilder:
                    //                                 (context, index) {
                    //                               return const Divider(
                    //                                 color: Colors
                    //                                     .transparent,
                    //                                 height: 5,
                    //                               );
                    //                             },
                    //                             shrinkWrap: true,
                    //                             itemCount:
                    //                                 friendReferences
                    //                                     .length,
                    //                             // friendReferences.length < 2
                    //                             //     ? friendReferences.length
                    //                             //     : 2,
                    //                             itemBuilder:
                    //                                 ((context,
                    //                                     index) {
                    //                               final otherFriendRef =
                    //                                   friendReferences[
                    //                                       index];
                    //                               return StreamBuilder<
                    //                                   DocumentSnapshot>(
                    //                                 stream:
                    //                                     otherFriendRef
                    //                                         .snapshots(),
                    //                                 initialData: null,
                    //                                 builder: (context,
                    //                                     friendSnapshot) {
                    //                                   if (friendSnapshot
                    //                                           .connectionState ==
                    //                                       ConnectionState
                    //                                           .waiting) {
                    //                                     return const CircularProgressIndicator();
                    //                                   } else if (friendSnapshot
                    //                                       .hasError) {
                    //                                     return Text(
                    //                                         "Error: ${friendSnapshot.error}");
                    //                                   } else {
                    //                                     final friendData = friendSnapshot
                    //                                             .data
                    //                                             ?.data()
                    //                                         as Map<
                    //                                             String,
                    //                                             dynamic>?;

                    //                                     final friendDisplayName =
                    //                                         friendData?[
                    //                                                 'displayName']
                    //                                             as String?;
                    //                                     final friendUserName =
                    //                                         friendData?[
                    //                                                 'userName']
                    //                                             as String?;

                    //                                     return ListTile(
                    //                                         shape: const RoundedRectangleBorder(
                    //                                             borderRadius: BorderRadius.all(Radius.circular(
                    //                                                 10))),
                    //                                         tileColor: const Color.fromARGB(
                    //                                             117,
                    //                                             240,
                    //                                             240,
                    //                                             240),
                    //                                         dense:
                    //                                             true,
                    //                                         horizontalTitleGap:
                    //                                             16,
                    //                                         visualDensity: const VisualDensity(
                    //                                             horizontal:
                    //                                                 -4,
                    //                                             vertical:
                    //                                                 -1),
                    //                                         contentPadding: const EdgeInsets.only(
                    //                                             left:
                    //                                                 10.0,
                    //                                             right:
                    //                                                 0.0),
                    //                                         title: Text(friendDisplayName ?? "Unknown",
                    //                                             style: const TextStyle(
                    //                                                 fontWeight: FontWeight
                    //                                                     .w900,
                    //                                                 fontSize:
                    //                                                     15)),
                    //                                         subtitle: RoundedBackgroundText(
                    //                                             outerRadius: 20.0,
                    //                                             innerRadius: 20.0,
                    //                                             "@${friendUserName ?? "Unknown"}",
                    //                                             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black54),
                    //                                             backgroundColor: const Color.fromARGB(255, 198, 255, 27)),
                    //                                         leading: IconButton(
                    //                                             onPressed: () {
                    //                                               _showFriendProfileDialog(context,
                    //                                                   otherFriendRef);
                    //                                             },
                    //                                             padding: const EdgeInsets.all(0),
                    //                                             icon: const Icon(
                    //                                               Icons.account_circle_rounded,
                    //                                               size:
                    //                                                   40,
                    //                                             )),
                    //                                         trailing: Row(
                    //                                           mainAxisSize:
                    //                                               MainAxisSize.min,
                    //                                           children: [
                    //                                             IconButton(
                    //                                               padding: const EdgeInsets.fromLTRB(
                    //                                                   5,
                    //                                                   0,
                    //                                                   15,
                    //                                                   0),
                    //                                               onPressed:
                    //                                                   () {
                    //                                                 // showDialog(
                    //                                                 //   context: context,
                    //                                                 //   builder: (BuildContext
                    //                                                 //           context) =>
                    //                                                 //       FriendModal(
                    //                                                 //           friendReference:
                    //                                                 //               friendRef,
                    //                                                 //           type:
                    //                                                 //               'Delete friend'),
                    //                                                 // );
                    //                                               },
                    //                                               icon:
                    //                                                   const Icon(Icons.note),
                    //                                             )
                    //                                           ],
                    //                                         ));
                    //                                   }
                    //                                 },
                    //                               );
                    //                             })))));
                    //           }
                    //         },
                    //       ),
                    //     )),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // )
                  ])),
            );
          }
        },
      )),
    );
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
}
