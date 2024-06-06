// package imports
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/friend_provider.dart';

class EditProfileModal extends StatelessWidget {
  final Future<Map<String, dynamic>?> currentUserDataFuture;
  final String userId;
  final _formKey = GlobalKey<FormState>();

  EditProfileModal({required this.currentUserDataFuture, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            child: Card(
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
                                  child: FutureBuilder<Map<String, dynamic>?>(
                                    future: currentUserDataFuture,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        return Text("Error: ${snapshot.error}");
                                      } else {
                                        final currentUserData = snapshot.data;
                                        final displayName =
                                            currentUserData?['displayName'] ??
                                                'User';
                                        final userName =
                                            currentUserData?['userName'] ??
                                                'User';
                                        final firstName =
                                            currentUserData?['firstName'];
                                        final lastName =
                                            currentUserData?['lastName'];
                                        final location =
                                            currentUserData?['location'];
                                        final birthDate =
                                            currentUserData?['birthDate'];
                                        final bio = currentUserData?['bio'] ??
                                            'No bio yet.';
                                        final bool status =
                                            currentUserData?['status'];

                                        // Create and return your edit profile form here
                                        return YourEditProfileFormWidget(
                                          userId: userId,
                                          displayName: displayName,
                                          userName: userName,
                                          firstName: firstName,
                                          lastName: lastName,
                                          location: location,
                                          birthDate: birthDate,
                                          bio: bio,
                                          status: status,
                                        );
                                      }
                                    },
                                  ),
                                ),
                              )))
                    ])))));
  }
}

class YourEditProfileFormWidget extends StatefulWidget {
  // Define fields you want to edit here...
  final String displayName;
  final String userName;
  final String? firstName;
  final String? lastName;
  final String? location;
  final String? birthDate;
  final String bio;
  final bool status;

  final String userId;

  YourEditProfileFormWidget({
    required this.displayName,
    required this.userName,
    this.firstName,
    this.lastName,
    this.location,
    this.birthDate,
    required this.bio,
    required this.status,
    required this.userId,
  });

  @override
  _YourEditProfileFormWidgetState createState() =>
      _YourEditProfileFormWidgetState();
}

class _YourEditProfileFormWidgetState extends State<YourEditProfileFormWidget> {
  // Controllers for text editing
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _birthDateController = TextEditingController();
  TextEditingController _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Initialize text controllers with existing data
    _firstNameController.text = widget.firstName ?? '';
    _lastNameController.text = widget.lastName ?? '';
    _locationController.text = widget.location ?? '';
    _userNameController.text = widget.userName;
    _birthDateController.text = widget.birthDate ?? '';
    _bioController.text = widget.bio;
  }

  @override
  Widget build(BuildContext context) {
    // Implement your edit profile form using the provided data...
    return Column(
      children: [
        const Text('Edit Profile',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w900,
              fontSize: 25,
            )),
        const Row(children: [
          Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text('First Name',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  )))
        ]),
        Padding(
            padding: const EdgeInsets.only(top: 5),
            child: TextFormField(
              controller: _firstNameController,
              decoration: InputDecoration(
                  isDense: true,
                  prefixIcon: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Icon(
                        Icons.person_rounded,
                      )),
                  hintStyle: const TextStyle(color: Colors.black54),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
            )),
        const Row(children: [
          Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text('Last Name',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  )))
        ]),
        Padding(
            padding: const EdgeInsets.only(top: 5),
            child: TextFormField(
              controller: _lastNameController,
              decoration: InputDecoration(
                  isDense: true,
                  prefixIcon: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Icon(
                        Icons.person_rounded,
                      )),
                  hintStyle: const TextStyle(color: Colors.black54),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
            )),
        const Row(children: [
          Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text('Username',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  )))
        ]),
        Padding(
            padding: const EdgeInsets.only(top: 5),
            child: TextFormField(
              controller: _userNameController,
              decoration: InputDecoration(
                  isDense: true,
                  prefixIcon: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Icon(
                        Icons.alternate_email_rounded,
                      )),
                  hintStyle: const TextStyle(color: Colors.black54),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
            )),
        const Row(children: [
          Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text('Location',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  )))
        ]),
        Padding(
            padding: const EdgeInsets.only(top: 5),
            child: TextFormField(
              controller: _locationController,
              decoration: InputDecoration(
                  isDense: true,
                  prefixIcon: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Icon(
                        Icons.location_pin,
                      )),
                  hintStyle: const TextStyle(color: Colors.black54),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
            )),
        const Row(children: [
          Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text('Birthdate',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  )))
        ]),
        Padding(
            padding: const EdgeInsets.only(top: 5),
            child: TextFormField(
              controller: _birthDateController,
              decoration: InputDecoration(
                  isDense: true,
                  prefixIcon: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Icon(
                        Icons.calendar_today_rounded,
                      )),
                  hintStyle: const TextStyle(color: Colors.black54),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
            )),
        const Row(children: [
          Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text('Bio',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  )))
        ]),
        Padding(
            padding: const EdgeInsets.only(top: 5),
            child: TextFormField(
              controller: _bioController,
              maxLines: 4,
              decoration: InputDecoration(
                  isDense: true,
                  prefixIcon: const Padding(
                      padding: EdgeInsets.fromLTRB(15, 0, 15, 60),
                      child: Icon(
                        Icons.format_quote_rounded,
                      )),
                  hintStyle: const TextStyle(color: Colors.black54),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
            )),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: TextButton(
              style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: const Color.fromARGB(255, 198, 255, 27)),
              onPressed: () async {
                // Implement your logic to update the user's profile here
                String updatedFirstName = _firstNameController.text;
                String updatedLastName = _lastNameController.text;
                String updatedLocation = _locationController.text;
                String updatedUserName = _userNameController.text;
                String updatedBirthDate = _birthDateController.text;
                String updatedBio = _bioController.text;

                // Concatenate first and last name to update displayName
                String updatedDisplayName =
                    '$updatedFirstName $updatedLastName';

                // You can now update these values in Firestore or wherever your data is stored
                // ...
                await context.read<FriendListProvider>().updateUserProfile(
                      userId: widget
                          .userId, // TODO: I need the userId to reach this.
                      updatedFirstName: updatedFirstName,
                      updatedLastName: updatedLastName,
                      updatedLocation: updatedLocation,
                      updatedUserName: updatedUserName,
                      updatedBirthDate: updatedBirthDate,
                      updatedBio: updatedBio,
                      updatedDisplayName: updatedDisplayName,
                    );

                await context.read<AuthProvider>().updateDisplayName(
                      widget.userId,
                      updatedDisplayName,
                    );

                showCustomSnackBar(context, "Profile updated successfully");

                // Close the modal when done
                Navigator.of(context).pop();
              },
              child: const SizedBox(
                  height: 40,
                  child: Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Icon(
                          Icons.edit_rounded,
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Text('Save changes',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w900,
                                fontSize: 20,
                              )))
                    ],
                  ))),
            ))
      ],
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
          bottom: MediaQuery.of(context).size.height - 140,
          right: 40,
          left: 40,
        ),
      ),
    );
  }
}
