import 'dart:convert';
import 'dart:io'; // Импорт для SocketException
import 'dart:async';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class ApiService {
  static const String _baseUrl = 'http://10.0.2.2:5000';
  static Future<void> testConnection() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/test'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 5));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    } catch (e) {
      print('Connection test error: $e');
    }
  }
  static Future<User> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 30));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return User.fromJson(data['user']); // Убедитесь, что сервер возвращает 'user'
      } else {
        throw Exception(data['error'] ?? 'Ошибка регистрации');
      }
    } catch (e) {
      print('Registration error: $e');
      throw Exception('Не удалось зарегистрироваться. Проверьте подключение');
    }
  }

  static Future<User> login(String email, String password) async {
    try {
      print('[DEBUG] Sending login request with: email=$email, password=$password');

      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      ).timeout(const Duration(seconds: 30));

      print('[DEBUG] Server response: ${response.statusCode} - ${response.body}');

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return User.fromJson(data['user']);
      } else {
        throw Exception(data['error'] ?? 'Ошибка входа');
      }
    } catch (e) {
      print('[ERROR] Login error: $e');
      rethrow;
    }
  }

  static Future<User> getProfile(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return User.fromJson(data);
      } else {
        throw Exception(data['error'] ?? 'Ошибка получения профиля');
      }
    } on SocketException {
      throw Exception('Нет подключения к серверу');
    } catch (e) {
      if (e is TimeoutException) {  // Проверяем тип исключения
        throw Exception('Превышено время ожидания');
      }
      throw Exception('Ошибка: ${e.toString()}');
    }
  }

  static Future<User> joinFamily({
    required String inviteCode,
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/join-family'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'inviteCode': inviteCode,
          'name': name,
          'email': email,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 30));

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return User.fromJson(data['user']);
      } else {
        throw Exception(data['error'] ?? 'Ошибка присоединения к семье');
      }
    } catch (e) {
      print('Join family error: $e');
      throw Exception('Не удалось присоединиться к семье. Проверьте код приглашения');
    }
  }
}