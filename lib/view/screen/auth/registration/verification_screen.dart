import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/view/screen/auth/login/login_screen.dart';
import '../../../../services/auth_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VerificationScreen extends StatelessWidget {
  final AuthService authService = Get.put(AuthService());
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _resendVerification() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
      Get.snackbar('Verification Email Sent',
          'Please check your email to verify your account.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Email Verification')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Please verify your email address.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _resendVerification,
              child: const Text('Resend Verification Email'),
            ),
            TextButton(
              onPressed: () {
                Get.to(() => LoginScreen());
              },
              child: const Text("Already verified? Login"),
            ),
          ],
        ),
      ),
    );
  }
}
