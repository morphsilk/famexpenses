import 'package:flutter/material.dart';
import 'screens/registration_screen.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(FamilyFinanceApp());
}

class FamilyFinanceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Расходы Семьи',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegistrationScreen(),
      },
    );
  }
}