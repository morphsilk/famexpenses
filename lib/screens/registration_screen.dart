import 'package:flutter/material.dart';
import '../models/user.dart';
import 'dart:math';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _password = '';

  void _register() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String familyId = 'FAM${Random().nextInt(10000).toString().padLeft(4, '0')}'; // Генерируем ID семьи
      User newUser = User(
        name: _name,
        email: _email,
        password: _password,
        familyId: familyId,
        role: UserRole.admin, // Первый пользователь — админ
      );
      print('Зарегистрирован: ${newUser.toJson()}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Регистрация успешна!')),
      );
      Navigator.pushReplacementNamed(
        context,
        '/login',
        arguments: newUser,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Оставляем как есть, только обновили _register
    return Scaffold(
      appBar: AppBar(title: Text('Регистрация')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Имя'),
                validator: (value) {
                  if (value!.isEmpty) return 'Введите имя';
                  if (!RegExp(r'^[а-яА-ЯёЁ\s]+$').hasMatch(value)) {
                    return 'Используйте только русские буквы';
                  }
                  return null;
                },
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
                validator: (value) {
                  if (value!.length < 8) return 'Минимум 8 символов';
                  if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)').hasMatch(value)) {
                    return 'Должен содержать буквы и цифры';
                  }
                  return null;
                },
                onSaved: (value) => _password = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _register,
                child: Text('Зарегистрироваться'),
              ),
              TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                child: Text('Уже есть аккаунт? Войти'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}