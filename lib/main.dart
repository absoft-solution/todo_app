import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:todo_app/view/screen/auth/login/login_screen.dart';
import 'package:todo_app/view/screen/home/home_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  LoginScreen(),
      getPages: [
        GetPage(name: '/', page: () =>  LoginScreen()),
        GetPage(name: '/home', page: () =>  HomeScreen()),
      ],
    );
  }
}
