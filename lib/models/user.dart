import 'package:flutter/foundation.dart';
import 'account.dart';
import 'financial_goal.dart';

enum UserRole {
  admin,
  adult,
  child,
}

class User {
  final String name;
  final String email;
  final String password;
  final String familyId;
  final UserRole role;
  List<Account> accounts;
  List<FinancialGoal> goals;

  User({
    required this.name,
    required this.email,
    required this.password,
    required this.familyId,
    required this.role,
    this.accounts = const [],
    this.goals = const [],
  }) {
    accounts = List.from(accounts);
    goals = List.from(goals);
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'password': password,
    'familyId': familyId,
    'role': role.toString().split('.').last, // Сохраняем как строку
    'accounts': accounts.map((account) => account.toJson()).toList(),
    'goals': goals.map((goal) => goal.toJson()).toList(),
  };

  factory User.fromJson(Map<String, dynamic> json) => User(
    name: json['name'],
    email: json['email'],
    password: json['password'],
    familyId: json['familyId'],
    role: UserRole.values.firstWhere((e) => e.toString().split('.').last == json['role']),
    accounts: (json['accounts'] as List?)?.map((a) => Account.fromJson(a)).toList() ?? [],
    goals: (json['goals'] as List?)?.map((g) => FinancialGoal.fromJson(g)).toList() ?? [],
  );
}