import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/virtual_stock.dart';

class ApiService {
  //static const String baseUrl = 'http://10.0.2.2:8000';
  static const String baseUrl = 'https://gsm-backend.fly.dev';

  // 🔐 Store tokens (for simplicity using static vars — for real apps use secure storage)
  static String? accessToken;
  static String? refreshToken;

  /// 🟢 Sign up a user
  static Future<bool> signup(String username, String password) async {
    final url = Uri.parse('$baseUrl/api/signup/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    return response.statusCode == 201;
  }

  /// 🔐 Login and get JWT token
  static Future<bool> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/api/token/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      accessToken = data['access'];
      refreshToken = data['refresh'];
      return true;
    } else {
      return false;
    }
  }

  /// 📈 Fetch virtual stocks (authenticated)
  static Future<List<VirtualStock>> fetchStocks() async {
    final url = Uri.parse('$baseUrl/api/stocks/virtual/');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (accessToken != null) 'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => VirtualStock.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load stocks: ${response.statusCode}');
    }
  }
}
