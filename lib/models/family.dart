import 'package:flutter/foundation.dart';
import 'user.dart';

class Family {
  final String id;
  final String name;
  final List<User> users;

  Family({
    required this.id,
    required this.name,
    required this.users,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'users': users.map((user) => user.toJson()).toList(),
  };

  factory Family.fromJson(Map<String, dynamic> json) => Family(
    id: json['id'],
    name: json['name'],
    users: (json['users'] as List).map((u) => User.fromJson(u)).toList(),
  );

  User? getAdmin() {
    for (var user in users) {
      if (user.role == UserRole.admin) {
        return user;
      }
    }
    return null;
  }
}