import 'package:flutter/material.dart';
import 'package:catalog_app/services/cart_manager.dart';
import 'package:catalog_app/services/local_storage_service.dart';
import 'package:catalog_app/views/home_screen.dart';
import 'package:catalog_app/views/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CartManager.loadCart();
  final storage = LocalStorageService();
  final email = await storage.getData('user_email');
  final hasValidSession =
      await storage.getData('is_logged_in') == 'true' &&
      email != null &&
      await storage.hasRegisteredUser(email);
  if (!hasValidSession) await storage.clearData('is_logged_in');
  runApp(MyApp(isLoggedIn: hasValidSession));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.isLoggedIn = false});

  final bool isLoggedIn;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catalog App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: isLoggedIn ? const HomeScreen() : const LoginScreen(),
    );
  }
}
