import 'dart:convert';
import 'package:http/http.dart' as http;

import 'connection.dart';

class LoginService {

  // Login API
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('${Connection.baseUrl}/v1/accounts/login/');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email.trim(),
          'password': password.trim(),
        }),
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': json.decode(response.body),
        };
      } else {
        final errorResponse = json.decode(response.body);
        return {
          'success': false,
          'error': errorResponse['detail'] ?? 'Login failed. Please try again.',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'An error occurred: $e',
      };
    }
  }
}
