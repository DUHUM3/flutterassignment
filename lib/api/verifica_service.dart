import 'dart:convert';
import 'package:http/http.dart' as http;
import 'connection.dart';

class abdu_VerificaService {

  // Verify OTP
  static Future<Map<String, dynamic>> verifyOtp(String email, String otp) async {
    final url = Uri.parse('${Connection.baseUrl}/v1/accounts/otp-verify/');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'otp': otp,
      }),
    );

    if (response.statusCode == 200) {
      return {'success': true, 'data': json.decode(response.body)};
    } else {
      return {
        'success': false,
        'error': json.decode(response.body)['error'] ?? 'Verification failed'
      };
    }
  }
}
