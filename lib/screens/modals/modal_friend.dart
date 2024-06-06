import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../providers/friend_provider.dart';

class FriendModal extends StatelessWidget {
  final DocumentReference? friendReference;
  final String type;

  final TextEditingController displayNameController = TextEditingController();

  final List<String> searchResults = [];

  FriendModal({super.key, required this.type, required this.friendReference});

  // Method to show the title of the modal depending on the functionality
  Text _buildTitle() {
    switch (type) {
      case 'Add friend':
        return const Text("Add new friend",
            style: TextStyle(fontWeight: FontWeight.bold));
      case 'Cancel friend request':
        return const Text("Confirm cancel friend request",
            style: TextStyle(fontWeight: FontWeight.bold));
      case 'Delete friend':
        return const Text("Confirm delete friend",
            style: TextStyle(fontWeight: FontWeight.bold));
      case 'Accept friend request':
        return const Text("Confirm accept friend request",
            style: TextStyle(fontWeight: FontWeight.bold));
      case 'Reject friend request':
        return const Text("Confirm reject friend request",
            style: TextStyle(fontWeight: FontWeight.bold));
      default:
        return const Text("");
    }
  }

  // Method to build the content or body depending on the functionality
  Widget _buildContent(BuildContext context) {
    // Use context.read to get the last updated list of friends
    //List<Friend> friendItems = context.read<FriendListProvider>().friend;

    switch (type) {
      case 'Add friend':
        {
          return FutureBuilder<DocumentSnapshot>(
            future: friendReference?.get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else {
                final friendData =
                    snapshot.data?.data() as Map<String, dynamic>?;

                final friendDisplayName = friendData?['displayName'] as String?;

                return Text(
                  "Are you sure you want to send friend request to '$friendDisplayName'?",
                );
              }
            },
          );
        }

      case 'Delete friend':
        {
          return FutureBuilder<DocumentSnapshot>(
            future: friendReference?.get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else {
                final friendData =
                    snapshot.data?.data() as Map<String, dynamic>?;

                final friendDisplayName = friendData?['displayName'] as String?;

                return Text(
                  "Are you sure you want to delete '$friendDisplayName'?",
                );
              }
            },
          );
        }

      case 'Cancel friend request':
        {
          return FutureBuilder<DocumentSnapshot>(
            future: friendReference?.get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else {
                final friendData =
                    snapshot.data?.data() as Map<String, dynamic>?;

                final friendDisplayName = friendData?['displayName'] as String?;

                return Text(
                  "Are you sure you want to cancel send friend request to '$friendDisplayName'?",
                );
              }
            },
          );
        }

      case 'Accept friend request':
        {
          return FutureBuilder<DocumentSnapshot>(
            future: friendReference?.get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else {
                final friendData =
                    snapshot.data?.data() as Map<String, dynamic>?;

                final friendDisplayName = friendData?['displayName'] as String?;

                return Text(
                  "Are you sure you want to accept friend request from '$friendDisplayName'?",
                );
              }
            },
          );
        }

      case 'Reject friend request':
        {
          return FutureBuilder<DocumentSnapshot>(
            future: friendReference?.get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else {
                final friendData =
                    snapshot.data?.data() as Map<String, dynamic>?;

                final friendDisplayName = friendData?['displayName'] as String?;

                return Text(
                  "Are you sure you want to reject friend request from '$friendDisplayName'?",
                );
              }
            },
          );
        }

      default:
        {
          return const Text(
            "Error 404",
          );
        }
    }
  }

  TextButton _dialogAction(BuildContext context, String userUid) {
    return TextButton(
      onPressed: () {
        switch (type) {
          case 'Add friend':
            {
              // Assuming friendReference is a DocumentReference
              final friendUid = friendReference?.id;
              // Delete friend from the list and fetch updated list
              context
                  .read<FriendListProvider>()
                  .addFriendRequest(userUid, friendUid!);

              Navigator.pop(context); // Close the modal
              showCustomSnackBar(context, 'Friend request sent');

              break;
            }

          case 'Delete friend':
            {
              // Assuming friendReference is a DocumentReference
              final friendUid = friendReference?.id;
              // Delete friend from the list and fetch updated list
              context
                  .read<FriendListProvider>()
                  .unfriendFromList(userUid, friendUid!);

              Navigator.pop(context); // Close the modal
              showCustomSnackBar(context, 'Deleted friend');
              break;
            }
          case 'Cancel friend request':
            {
              // Assuming friendReference is a DocumentReference
              final friendUid = friendReference?.id;
              // Delete friend from the list and fetch updated list
              context
                  .read<FriendListProvider>()
                  .cancelSentRequestFromList(userUid, friendUid!);

              Navigator.pop(context);
              showCustomSnackBar(context, 'Canceled friend request');
              break; // Close the modal
            }
          case 'Accept friend request':
            {
              // Assuming friendReference is a DocumentReference
              final friendUid = friendReference?.id;
              // Delete friend from the list and fetch updated list
              context
                  .read<FriendListProvider>()
                  .acceptFriendRequestFromList(userUid, friendUid!);

              Navigator.pop(context);
              showCustomSnackBar(context, 'Accepted friend request');
              break; // Close the modal
            }
          case 'Reject friend request':
            {
              // Assuming friendReference is a DocumentReference
              final friendUid = friendReference?.id;
              // Delete friend from the list and fetch updated list
              context
                  .read<FriendListProvider>()
                  .rejectFriendRequestFromList(userUid, friendUid!);

              Navigator.pop(context);
              showCustomSnackBar(context, 'Deleted friend request');
              break; // Close the modal
            }
        }
      },
      style: TextButton.styleFrom(
        textStyle: Theme.of(context).textTheme.labelLarge,
      ),
      child: Text(type),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: _buildTitle(),
      content: _buildContent(context),

      // Contains two buttons - add/edit/delete, and cancel
      actions: <Widget>[
        _dialogAction(context, FirebaseAuth.instance.currentUser!.uid),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          child: const Text("Cancel"),
        ),
      ],
    );
  }

  void showCustomSnackBar(BuildContext context, String message) {
    final OverlayState overlayState = Overlay.of(context);
    OverlayEntry? entry;

    entry = OverlayEntry(
      builder: (BuildContext overlayContext) {
        final mediaQuery = MediaQuery.of(overlayContext);
        final double bottomMargin = mediaQuery.size.height * 0.72;

        return Positioned(
          bottom: mediaQuery.viewInsets.bottom + bottomMargin + 125,
          left: 40,
          right: 40,
          child: Material(
            elevation: 6,
            color: Colors.black87,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      message,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: GoogleFonts.robotoMono().fontFamily,
                      ),
                    ),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    color: Colors.white,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      entry?.remove();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    overlayState.insert(entry);

    // Automatically remove the overlay after some duration
    Future.delayed(const Duration(seconds: 2), () {
      entry?.remove();
    });
  }
}
