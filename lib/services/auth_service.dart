import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  //static const String baseUrl = "https://gsm-backend.fly.dev/api";
  static const String baseUrl = "https://gsm-backend.fly.dev";

  // 🔐 Signup method
  static Future<bool> signup(String username, String password) async {
  final response = await http.post(
    Uri.parse('$baseUrl/api/signup/'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'username': username, 'password': password}),
  );

  //print('Signup response code: ${response.statusCode}');
  //print('Signup response body: ${response.body}');

  return response.statusCode == 201;
  }


  // 🔐 Login method
  static Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/token/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access', data['access']);
      await prefs.setString('refresh', data['refresh']);
      return true;
    } else {
      return false;
    }
  }

  // 🪪 Get Access Token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access');
  }

  // 🚪 Logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clears both access & refresh
  }
}
