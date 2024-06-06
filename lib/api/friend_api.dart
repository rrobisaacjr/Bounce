// package imports
import 'dart:async';
import 'package:http/http.dart' as http;

//file imports
import '../models/friend_model.dart';

class FriendAPI {
  Future<List<Friend>> fetchFriends() async {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/friends'));

    if (response.statusCode == 200) {
      return Friend.fromJsonArray(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load friends');
    }
  }
}
