import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class abdu_ControlcourseService {
  static const String baseUrl = 'https://lomfu.pythonanywhere.com/api/v1/teachers/courses/';

  static Future<String?> getAccessToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  static Future<List<Map<String, dynamic>>> fetchCourses() async {
    final token = await getAccessToken();
    if (token == null) {
      throw Exception("Access token not found.");
    }

    final url = Uri.parse(baseUrl);
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => e as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load courses. Status code: ${response.statusCode}');
    }
  }

  static Future<void> deleteCourse(int courseId) async {
    final token = await getAccessToken();
    if (token == null) {
      throw Exception("Access token not found.");
    }

    final url = Uri.parse('$baseUrl$courseId/delete/');
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete course. Status code: ${response.statusCode}');
    }
  }

  static Future<void> updateCourse(int courseId, Map<String, dynamic> updatedData) async {
    final token = await getAccessToken();
    if (token == null) {
      throw Exception("Access token not found.");
    }

    final url = Uri.parse('$baseUrl$courseId/update/');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(updatedData),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update course. Status code: ${response.statusCode}');
    }
  }
}
