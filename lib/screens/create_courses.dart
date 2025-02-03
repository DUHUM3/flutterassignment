import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../managers/pending_request_manager.dart';
import '../api/TokenManager.dart';
import '../widgets/course_form.dart';

class abdu_AddItemScreen extends StatefulWidget {
  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<abdu_AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _titleController = TextEditingController();
  final _overviewController = TextEditingController();
  final PendingRequestManager _requestManager = PendingRequestManager();

  @override
  void initState() {
    super.initState();
    _requestManager.initHive().then((_) {
      _requestManager.checkAndSendPendingRequests();
    });
  }

  Future<void> submitForm() async {
    if (_formKey.currentState!.validate()) {
      final url = Uri.parse('https://lomfu.pythonanywhere.com/api/v1/teachers/courses/create/');
      final String? token = await TokenManager.getToken();

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('⚠️ لم يتم العثور على التوكن، الرجاء تسجيل الدخول مجددًا.')),
        );
        return;
      }

      final body = {
        'subject': _subjectController.text.trim(),
        'title': _titleController.text.trim(),
        'overview': _overviewController.text.trim(),
      };

      try {
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: json.encode(body),
        );

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('✅ تمت إضافة المادة بنجاح!')),
          );
          _subjectController.clear();
          _titleController.clear();
          _overviewController.clear();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('❌ فشل الإضافة: ${response.body}')),
          );
        }
      } catch (e) {
        await _requestManager.saveToHive(body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('⚠️ تم حفظ البيانات محليًا بسبب عدم توفر الإنترنت. سيتم إرسالها لاحقًا.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إضافة مادة جديدة')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CourseForm(
          formKey: _formKey,
          subjectController: _subjectController,
          titleController: _titleController,
          overviewController: _overviewController,
          submitForm: submitForm,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _titleController.dispose();
    _overviewController.dispose();
    super.dispose();
  }
}
