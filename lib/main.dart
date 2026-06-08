import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Job Prostuti',
      theme: ThemeData(
        fontFamily: 'Hind Siliguri',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1a5ff3)),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: false,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Color(0xFF0f1e4a)),
          titleTextStyle: TextStyle(color: Color(0xFF0f1e4a), fontSize: 18, fontWeight: FontWeight.w700),
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}