import 'package:flutter/material.dart';
import '../api/verifica_service.dart';
import 'login.dart';

class abdu_VerificationScreen extends StatefulWidget {
  final String email;

  const abdu_VerificationScreen({super.key, required this.email});

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<abdu_VerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  String otp = '';

  Future<void> verifyOtp() async {
    final response = await abdu_VerificaService.verifyOtp(widget.email, otp);

    if (response['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verification Successful!')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => abdu_LoginScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['error'])),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: widget.email,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'OTP',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the OTP';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    otp = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    verifyOtp();
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Verify'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
