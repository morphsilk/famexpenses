import 'package:flutter/material.dart';
import 'main_screen.dart';
import 'history_screen.dart';
import 'analytics_screen.dart';
import 'goals_budget_screen.dart';
import '../models/account.dart';
import '../models/financial_goal.dart';
import '../models/user.dart';
import '../models/family.dart';

class MainNavigation extends StatefulWidget {
  final Family family;

  MainNavigation({required this.family});

  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  late User currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = widget.family.users.first; // Пока берём первого
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _addAccount(Account newAccount) {
    setState(() {
      widget.family.users.first.accounts.add(newAccount);
    });
  }

  void _addFamilyMember(User newUser) {
    setState(() {
      widget.family.users.add(newUser);
    });
  }

  List<Widget> get _screens {
    final allAccounts = widget.family.users.expand((user) => user.accounts).toList();
    final allGoals = widget.family.users.expand((user) => user.goals).toList();
    final userAccounts = currentUser.role == UserRole.child ? currentUser.accounts : allAccounts;
    final userGoals = currentUser.role == UserRole.child ? currentUser.goals : allGoals;

    return [
      MainScreen(
        accounts: userAccounts,
        goals: userGoals,
        onAddAccount: currentUser.role != UserRole.child ? _addAccount : null,
        family: widget.family, // Передаём family
        currentUser: currentUser, // Передаём currentUser
      ),
      HistoryScreen(accounts: userAccounts),
      AnalyticsScreen(accounts: userAccounts),
      GoalsBudgetScreen(accounts: userAccounts, goals: userGoals),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Главная'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'История'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Аналитика'),
          BottomNavigationBarItem(icon: Icon(Icons.flag), label: 'Цели'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}