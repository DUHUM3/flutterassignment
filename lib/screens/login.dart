import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../api/auth_service.dart';
import 'create_user.dart';
import 'teachers_courses.dart';

class ThemeController extends GetxController {
  RxBool isDarkMode = false.obs;

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }
}

class abdu_LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ThemeController themeController = Get.put(ThemeController());

  abdu_LoginScreen({super.key});

  Future<void> loginUser(BuildContext context) async {
    final response = await abdu_LoginService.login(
      emailController.text,
      passwordController.text,
    );

    if (response['success']) {
      final responseData = response['data'];
      final accessToken = responseData['access'];

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login Successful!')),
      );

      Get.to(() => abdu_CoursesScreen());
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
        title: const Text('Login'),
        actions: [
          Obx(
            () => IconButton(
              icon: Icon(
                themeController.isDarkMode.value
                    ? Icons.light_mode
                    : Icons.dark_mode,
              ),
              onPressed: themeController.toggleTheme,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: passwordController,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    loginUser(context);
                  },
                  icon: const Icon(Icons.check),
                  label: const Text('Login'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Get.to(() => abdu_RegistrationScreen());
                  },
                  child: const Text('Create New User'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
