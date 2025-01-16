import 'package:flutter/material.dart';


class abdu_EditCourseScreen extends StatefulWidget {
  final Map<String, dynamic> course;

  abdu_EditCourseScreen({required this.course});

  @override
  _EditCourseScreenState createState() => _EditCourseScreenState();
}

class _EditCourseScreenState extends State<abdu_EditCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _subjectController;
  late TextEditingController _overviewController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.course['title']);
    _subjectController = TextEditingController(text: widget.course['subject']);
    _overviewController = TextEditingController(text: widget.course['overview']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Course'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _subjectController,
                decoration: InputDecoration(labelText: 'Subject'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a subject';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _overviewController,
                decoration: InputDecoration(labelText: 'Overview'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an overview';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Map<String, dynamic> updatedData = {
                      'title': _titleController.text,
                      'subject': _subjectController.text,
                      'overview': _overviewController.text,
                    };
                    Navigator.pop(context, updatedData);
                  }
                },
                child: Text('Update Course'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

