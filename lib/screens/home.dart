import 'package:flutter/material.dart';


class HomeScreen extends StatelessWidget {
  final String accessToken;

  const HomeScreen({required this.accessToken, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Center(
        child: Text('Welcome! Access Token: $accessToken'),
      ),
    );
  }
}
