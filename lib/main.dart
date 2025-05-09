import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Сервіси та стани
import 'package:mob/services/app_state.dart';

// Екрани
import 'package:mob/screen/login_screen.dart';
import 'package:mob/screen/register_screen.dart';
import 'package:mob/screen/main_screen.dart';
import 'package:mob/screen/profile_screen.dart';
import 'package:mob/screen/qr_scanner_screen.dart'; // Додано
import 'package:mob/screen/saved_qr_screen.dart';   // Додано

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  final savedEmail = prefs.getString('email');

  final appState = AppState();
  if (isLoggedIn && savedEmail != null) {
    await appState.loadUserSettings(savedEmail);
  }

  runApp(
    ChangeNotifierProvider<AppState>.value(
      value: appState,
      child: MyApp(isLoggedIn: isLoggedIn),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart heating',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: Colors.pink.shade50,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: isLoggedIn ? '/home' : '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const MainScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/scan': (context) => QRScannerScreen(),           // Додано
        '/saved': (context) => const SavedQrScreen(),      // Додано
      },
    );
  }
}
