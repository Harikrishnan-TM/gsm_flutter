import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/virtual_stock.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000/api/stocks/'; // for Android Emulator

  static Future<List<VirtualStock>> fetchStocks() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => VirtualStock.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load stocks');
    }
  }
}
