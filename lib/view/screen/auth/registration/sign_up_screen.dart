import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../services/auth_services.dart';


class SignUpScreen extends StatelessWidget {
  final AuthService authService = Get.put(AuthService());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _signUp() async {
    final email = emailController.text;
    final password = passwordController.text;
    await authService.signUp(email, password);
    if (authService.signUp(email, password) != null) {
      Get.offNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _signUp,
              child: const Text('Sign Up'),
            ),
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text("Already have an account? Login"),
            ),
          ],
        ),
      ),
    );
  }
}
