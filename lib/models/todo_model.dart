import 'dart:convert';

class Todo {
  final int userId;
  String? id;
  String title;
  String note;

  Todo(
      {required this.userId, this.id, required this.title, required this.note});

  // Factory constructor to instantiate object from json format
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
        userId: json['userId'],
        id: json['id'],
        title: json['title'],
        note: json['note']);
  }

  static List<Todo> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Todo>((dynamic d) => Todo.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson(Todo todo) {
    return {
      'userId': todo.userId,
      'id': todo.id,
      'title': todo.title,
      'note': todo.note
    };
  }
}
