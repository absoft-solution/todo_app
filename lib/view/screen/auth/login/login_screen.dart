import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/view/screen/auth/registration/verification_screen.dart';
import '../../../../services/auth_services.dart';
import '../registration/sign_up_screen.dart';

class LoginScreen extends StatelessWidget {
  final AuthService authService = Get.put(AuthService());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen({super.key});

  void _login() async {
    final email = emailController.text;
    final password = passwordController.text;
    User? user = await authService.signIn(email, password);

    if (user != null) {
      await user.reload(); //reload data abut verified users
      user = FirebaseAuth.instance.currentUser;

      if (user?.emailVerified == true) //if verified go to home
      {
        Get.offNamed('/home');
      } else {
        Get.snackbar('Email Not Verified',
            'Please verify your email before logging in.');
        Get.to(() => VerificationScreen());
      }
    } else {
      Get.snackbar('Login Error', 'Invalid email or password.',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
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
              onPressed: _login,
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: () {
                Get.to(() => SignUpScreen());
              },
              child: const Text("Don't have an account? Register"),
            ),
          ],
        ),
      ),
    );
  }
}
