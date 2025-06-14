import 'package:flutter/material.dart';
import '../models/user.dart';

class FamilyManagementScreen extends StatefulWidget {
  final List<User> familyUsers;
  final Function(User) onAddFamilyMember;

  FamilyManagementScreen({required this.familyUsers, required this.onAddFamilyMember});

  @override
  _FamilyManagementScreenState createState() => _FamilyManagementScreenState();
}

class _FamilyManagementScreenState extends State<FamilyManagementScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _password = '';
  UserRole _role = UserRole.adult;

  void _addFamilyMember() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newUser = User(
        name: _name,
        email: _email,
        password: _password,
        familyId: widget.familyUsers.first.familyId,
        role: _role,
      );
      print('Добавляем члена семьи: ${newUser.name}, роль: ${_role.toString()}');
      widget.onAddFamilyMember(newUser);
      Navigator.pop(context);
      print('Navigator.pop вызван');
    } else {
      print('Валидация не прошла');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Управление семьёй')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Члены семьи:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: widget.familyUsers.length,
                itemBuilder: (context, index) {
                  final user = widget.familyUsers[index];
                  return ListTile(
                    title: Text(user.name),
                    subtitle: Text('${user.email} • ${user.role.toString().split('.').last}'),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            Text('Добавить нового члена:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Имя'),
                    validator: (value) => value!.isEmpty ? 'Введите имя' : null,
                    onSaved: (value) => _name = value!,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value!)
                        ? 'Введите корректный email'
                        : null,
                    onSaved: (value) => _email = value!,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Пароль'),
                    obscureText: true,
                    validator: (value) => value!.length < 8 ? 'Минимум 8 символов' : null,
                    onSaved: (value) => _password = value!,
                  ),
                  DropdownButtonFormField<UserRole>(
                    decoration: InputDecoration(labelText: 'Роль'),
                    value: _role,
                    items: UserRole.values.map((role) {
                      return DropdownMenuItem<UserRole>(
                        value: role,
                        child: Text(role.toString().split('.').last),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => _role = value!),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _addFamilyMember,
                    child: Text('Добавить'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}