// package imports
import 'package:flutter/material.dart';

// file imports

class NotificationsModal extends StatefulWidget {
  final List<String> notifications;

  NotificationsModal({required this.notifications});

  @override
  _NotificationsModalState createState() => _NotificationsModalState();
}

class _NotificationsModalState extends State<NotificationsModal> {
  bool isReversed = false;

  @override
  Widget build(BuildContext context) {
    final reversedNotifications = isReversed
        ? widget.notifications.reversed.toList()
        : widget.notifications;

    return Center(
      child: SingleChildScrollView(
        child: Card(
          color: Colors.black87,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: Column(
              children: [
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
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                  child: SizedBox(
                    width: 300,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Task History',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                              fontSize: 25,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                  padding: EdgeInsets.only(bottom: 15),
                                  child: Text(
                                      ((widget.notifications.length - 1) == 0)
                                          ? "There were no updates made yet."
                                          : "There were ${widget.notifications.length - 1} updates made.",
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400))),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Expanded(
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(10, 0, 15, 0),
                                  child: Divider(
                                    thickness: 1,
                                    color: Colors.black12,
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.sort_rounded,
                                color: Colors.black45,
                                size: 20,
                              ),
                              const Text("Sort ",
                                  style: TextStyle(
                                      color: Colors.black45,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 15)),
                              IconButton(
                                padding: EdgeInsets.zero,
                                iconSize: 20,
                                constraints: BoxConstraints(),
                                color: Colors.black45,
                                icon: Icon(
                                  isReversed
                                      ? Icons.arrow_upward
                                      : Icons.arrow_downward,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isReversed = !isReversed;
                                  });
                                },
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                height: 10,
                              )
                            ],
                          ),
                          Container(
                              constraints: BoxConstraints(
                                  maxHeight:
                                      MediaQuery.of(context).size.height * .30),
                              child: SingleChildScrollView(
                                child: Column(
                                  children:
                                      reversedNotifications.map((notification) {
                                    return Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Material(
                                          child: ListTile(
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                            ),
                                            tileColor: const Color.fromARGB(
                                                117, 240, 240, 240),
                                            dense: true,
                                            horizontalTitleGap: 16,
                                            visualDensity: const VisualDensity(
                                              horizontal: -4,
                                              vertical: -1,
                                            ),
                                            contentPadding:
                                                const EdgeInsets.only(
                                              left: 10.0,
                                              right: 0.0,
                                            ),
                                            title: Text(
                                              notification,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 15,
                                                wordSpacing: -3,
                                              ),
                                            ),
                                          ),
                                        ));
                                  }).toList(),
                                ),
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
