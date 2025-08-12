import 'package:flutter/material.dart';
import 'screens/login_screen.dart'; // Import LoginScreen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Findoc Assignment',
      theme: ThemeData(
        fontFamily: 'Montserrat', // Set default font family
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(), // Start with the Login Screen
      debugShowCheckedModeBanner: false, // Optional: Hide debug banner
    );
  }
}