import 'dart:convert';
import 'package:http/http.dart' as http;
import 'TokenManager.dart';
import 'connection.dart';

class abdu_LoginService {
  // تسجيل الدخول
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
        final responseData = json.decode(response.body);

        if (responseData.containsKey('access')) {
          await TokenManager.saveToken(responseData['access']); // ⬅️ حفظ التوكن
          print('✅ Access Token: ${responseData['access']}'); // طباعة التوكن في التيرمنال
        }

        return {'success': true, 'data': responseData};
      } else {
        final errorResponse = json.decode(response.body);
        return {'success': false, 'error': errorResponse['detail'] ?? 'Login failed. Please try again.'};
      }
    } catch (e) {
      return {'success': false, 'error': 'An error occurred: $e'};
    }
  }
}
