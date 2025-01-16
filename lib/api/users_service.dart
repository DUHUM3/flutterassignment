// api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'connection.dart';

class abdu_UserService {
  static const String baseUrl = '${Connection.baseUrl}/api/v1/accounts/register/';

  static Future<Map<String, dynamic>> registerUser({
    required String name,
    required String email,
    required String phone,
    required String role,
    required String password,
    required String confirmPassword,
  }) async {
    final url = Uri.parse(baseUrl);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'email': email,
          'phone': phone,
          'role': role,
          'password': password,
          'confirm_password': confirmPassword,
        }),
      );

      if (response.statusCode == 201) {
        // Registration successful
        return {'success': true, 'message': 'Registration Successful!'};
      } else {
        // Handle API errors
        final errorResponse = json.decode(response.body);
        final errorMessage = errorResponse['non_field_errors'] != null
            ? errorResponse['non_field_errors'][0]
            : 'Registration failed';
        return {'success': false, 'message': errorMessage};
      }
    } catch (e) {
      // Handle network or unexpected errors
      return {'success': false, 'message': 'An error occurred: $e'};
    }
  }
}