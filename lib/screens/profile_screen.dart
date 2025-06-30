import 'package:flutter/material.dart';
import '../models/account.dart';
import '../models/user.dart';
import '../models/family.dart';
import 'family_management_screen.dart';
import 'budget_calculation_screen.dart'; // Импорт нового экрана

class ProfileScreen extends StatelessWidget {
  final Family family;
  final User currentUser;
  final List<Account> accounts;
  final Function(User)? onRemoveFamilyMember;
  final Function(User, UserRole)? onUpdateRole;

  const ProfileScreen({
    required this.family,
    required this.currentUser,
    required this.accounts,
    this.onRemoveFamilyMember,
    this.onUpdateRole,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Имя: ${currentUser.name}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              'Email: ${currentUser.email}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Роль: ${currentUser.role.toString().split('.').last}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BudgetCalculationScreen(
                      accounts: accounts,
                    ),
                  ),
                );
              },
              child: const Text('Рассчитать бюджет'),
            ),
            const SizedBox(height: 20),
            if (currentUser.role == UserRole.admin)
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FamilyManagementScreen(
                        familyUsers: family.users,
                        onAddFamilyMember: (newUser) {
                          Navigator.pop(context);
                          family.users.add(newUser);
                        },
                        onRemoveFamilyMember: onRemoveFamilyMember ?? (user) {
                          family.users.removeWhere((u) => u.email == user.email);
                        },
                        onUpdateRole: onUpdateRole ?? (user, newRole) {
                          final index = family.users.indexWhere((u) => u.email == user.email);
                          if (index != -1) {
                            family.users[index] = user.copyWith(role: newRole);
                          }
                        },
                      ),
                    ),
                  );
                },
                child: const Text('Управление семьёй'),
              ),
          ],
        ),
      ),
    );
  }
}