import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/family.dart';
import 'family_management_screen.dart';

class ProfileScreen extends StatelessWidget {
  final Family? family; // Передаём семью, если доступно
  final User? currentUser;

  ProfileScreen({this.family, this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Профиль')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Имя: ${currentUser?.name ?? "Неизвестно"}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              'Email: ${currentUser?.email ?? "Неизвестно"}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Роль: ${currentUser?.role.toString().split('.').last ?? "Неизвестно"}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            if (currentUser?.role == UserRole.admin && family != null)
              ElevatedButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FamilyManagementScreen(
                        familyUsers: family!.users,
                        onAddFamilyMember: (newUser) {
                          family!.users.add(newUser);
                          // Обновляем состояние в MainNavigation через Navigator.pop
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  );
                  // Возвращаемся на MainScreen или обновляем профиль
                },
                child: Text('Управление семьёй'),
              ),
          ],
        ),
      ),
    );
  }
}