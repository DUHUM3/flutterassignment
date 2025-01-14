import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'screens/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Dark Theme with GetX',
      theme: ThemeData.light(), 
      darkTheme: ThemeData.dark(), 
      themeMode: ThemeMode.system, 
      home: LoginScreen(),
    );
  }
}
