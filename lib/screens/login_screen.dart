import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/family.dart';
import 'main_navigation.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  static List<User> _registeredUsers = []; // Временное хранилище

  void _login() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final user = _registeredUsers.firstWhere(
            (u) => u.email == _email && u.password == _password,
        orElse: () => User(name: '', email: '', password: '', familyId: '', role: UserRole.adult),
      );
      if (user.email.isNotEmpty) {
        print('Вход успешен: ${user.toJson()}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Вход успешен!')),
        );
        // Собираем семью из всех пользователей с таким же familyId
        final family = Family(
          id: user.familyId,
          name: "Семья ${user.name}",
          users: _registeredUsers.where((u) => u.familyId == user.familyId).toList(),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainNavigation(family: family),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Неверный email или пароль')),
        );
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newUser = ModalRoute.of(context)?.settings.arguments as User?;
    if (newUser != null && !_registeredUsers.any((u) => u.email == newUser.email)) {
      _registeredUsers.add(newUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Без изменений
    return Scaffold(
      appBar: AppBar(title: Text('Вход')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                validator: (value) =>
                value!.isEmpty ? 'Введите пароль' : null,
                onSaved: (value) => _password = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: Text('Войти'),
              ),
              TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/register'),
                child: Text('Нет аккаунта? Зарегистрироваться'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}