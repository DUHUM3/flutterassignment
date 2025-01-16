import 'package:flutter/material.dart';
import '../api/users_service.dart';
import 'Verification.dart';

class abdu_RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<abdu_RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String email = '';
  String phone = '';
  String role = 'teacher';
  String password = '';
  String confirmPassword = '';

  Future<void> registerUser() async {
    if (_formKey.currentState!.validate()) {
      final response = await abdu_UserService.registerUser(
        name: name,
        email: email,
        phone: phone,
        role: role,
        password: password,
        confirmPassword: confirmPassword,
      );

      if (response['success'] == true) {
        // Registration successful
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'])),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => abdu_VerificationScreen(email: email),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'])),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register New Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
              ),
              const SizedBox(height: 10),

              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
              const SizedBox(height: 10),

              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    phone = value;
                  });
                },
              ),
              const SizedBox(height: 10),

              DropdownButtonFormField<String>(
                value: role,
                decoration: const InputDecoration(
                  labelText: 'Role',
                  border: OutlineInputBorder(),
                ),
                items: ['teacher', 'student']
                    .map((role) => DropdownMenuItem(
                          value: role,
                          child:
                              Text(role == 'teacher' ? 'Teacher' : 'Student'),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    role = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your role';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
              const SizedBox(height: 10),

              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value != password) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    confirmPassword = value;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Register button
              ElevatedButton(
                onPressed: registerUser,
                child: const Text('Register'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
