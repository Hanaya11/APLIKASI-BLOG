import 'package:flutter/material.dart';
import 'package:frontend/mainpage.dart';
import 'package:frontend/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blogverse',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE86F51),
        ),
        useMaterial3: true,
      ),

      // Halaman pertama yang dibuka
      initialRoute: '/login',

      // Daftar route
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const MainPage(),
      },
    );
  }
}