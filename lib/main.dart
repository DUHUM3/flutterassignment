import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await Hive.initFlutter();
  await Hive.openBox('offlineData');
  runApp(const MyApp());
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
      home: abdu_LoginScreen(),
    );
  }
}
