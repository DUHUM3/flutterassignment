import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

class abdu_AddItemScreen extends StatefulWidget {
  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<abdu_AddItemScreen> {
  File? _imageFile;
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _titleController = TextEditingController();
  final _overviewController = TextEditingController();

  final String _baseUrl = "https://lomfu.pythonanywhere.com"; 
  final String _apiUrl = "/api/v1/teachers/courses/create/"; 

  Future<String?> _getAccessToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });

        print('Image Path: ${pickedFile.path}');
        print('File Name: ${path.basename(pickedFile.path)}');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && _imageFile != null) {
      final String? accessToken = await _getAccessToken(); 

      if (accessToken == null) {
        print('Error: No access token found');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: No access token found')),
        );
        return;
      }

      final url = Uri.parse('$_baseUrl$_apiUrl');

      try {
        final request = http.MultipartRequest('POST', url)
          ..headers.addAll({
            'Authorization': 'Bearer $accessToken', 
          })
          ..fields['subject'] = _subjectController.text
          ..fields['title'] = _titleController.text
          ..fields['overview'] = _overviewController.text
          ..files.add(await http.MultipartFile.fromPath('photo', _imageFile!.path)); 

        final response = await request.send();
        final responseBody = await response.stream.bytesToString();

        if (response.statusCode == 201) {
          final jsonResponse = jsonDecode(responseBody);
          print('Success: $jsonResponse');

          final String relativeImagePath = jsonResponse['photo'];
          final String fullImageUrl = "$_baseUrl$relativeImagePath";
          print('Uploaded Image URL: $fullImageUrl');

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Data sent successfully')),
          );
        } else {
          print('Failed: ${response.statusCode}');
          print('Response Body: $responseBody');

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to send data: ${response.statusCode}')),
          );
        }
      } catch (e) {
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred while sending data: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields and select an image')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _subjectController,
                decoration: const InputDecoration(labelText: 'Subject'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a subject';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _overviewController,
                decoration: const InputDecoration(labelText: 'Overview'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an overview';
                  }
                  return null;
                },
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              _imageFile != null
                  ? Image.file(
                      _imageFile!,
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                    )
                  : const Text('No image selected'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Choose Image from Gallery'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Add Item'),
              ),
            ],
          ),
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