import 'package:flutter/material.dart';

class CourseForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController subjectController;
  final TextEditingController titleController;
  final TextEditingController overviewController;
  final Function submitForm;

  CourseForm({
    required this.formKey,
    required this.subjectController,
    required this.titleController,
    required this.overviewController,
    required this.submitForm,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView(
        children: [
          TextFormField(
            controller: subjectController,
            decoration: const InputDecoration(labelText: 'الموضوع'),
            validator: (value) => value!.isEmpty ? 'الرجاء إدخال الموضوع' : null,
          ),
          TextFormField(
            controller: titleController,
            decoration: const InputDecoration(labelText: 'العنوان'),
            validator: (value) => value!.isEmpty ? 'الرجاء إدخال العنوان' : null,
          ),
          TextFormField(
            controller: overviewController,
            decoration: const InputDecoration(labelText: 'الوصف'),
            maxLines: 3,
            validator: (value) => value!.isEmpty ? 'الرجاء إدخال الوصف' : null,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => submitForm(),
            child: const Text('إرسال'),
          ),
        ],
      ),
    );
  }
}
