import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user;
    } catch (e) {
      Get.snackbar('Login Error', e.toString());
      return null;
    }
  }

  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      await userCredential.user
          ?.sendEmailVerification(); //sedning verification email

      return userCredential.user;
    } catch (e) {
      Get.snackbar('Sign Up Error', e.toString());
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
