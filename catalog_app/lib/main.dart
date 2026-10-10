import 'package:flutter/material.dart';
import 'package:catalog_app/views/login_screen.dart'; // Login ekranının yolu
import 'package:catalog_app/views/register_screen.dart'; // Kayıt ekranının yolu

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catalog App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const LoginScreen(), // Uygulama buradan başlar
    );
  }
}