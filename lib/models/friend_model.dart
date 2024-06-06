import 'dart:convert';

class Friend {
  String? id;
  String userName;
  String displayName;
  List<dynamic> friends = [];
  List<dynamic> receivedFriendRequests = [];
  List<dynamic> sentFriendRequests = [];

  Friend({
    this.id,
    required this.userName,
    required this.displayName,
    required this.friends,
    required this.receivedFriendRequests,
    required this.sentFriendRequests,
  });

  // Factory constructor to instantiate object from json format
  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
        id: json['id'],
        userName: json['userName'],
        displayName: json['displayName'],
        friends: json['friends'],
        receivedFriendRequests: json['receivedFriendRequests'],
        sentFriendRequests: json['sentFriendRequests']);
  }

  Map<String, dynamic> toJson(Friend friend) {
    return {
      'id': friend.id,
      'userName': friend.userName,
      'displayName': friend.displayName,
      'friends': friend.friends,
      'receivedFriendRequests': friend.receivedFriendRequests,
      'sentFriendRequests': friend.sentFriendRequests
    };
  }

  static List<Friend> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map((dynamic d) => Friend.fromJson(d)).toList();
  }
}
