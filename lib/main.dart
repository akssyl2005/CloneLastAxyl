import 'package:complete_shop_clone/screens/auth/splash.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/home/home_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/auth/sign_in_screen.dart';
import 'screens/auth/forget_password_screen.dart';
import 'screens/auth/splash.dart'; // ✅ Correction : import de splash.dart
import 'firebase_options.dart';
import '';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    print("🟡 Firebase initializing...");
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("🟢 Firebase initialized.");
  } catch (e, s) {
    print("🔴 Firebase init error: $e");
    print("🔍 Stack: $s");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReLook',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),
      home: const SplashScreen(), // ✅ SplashScreen en première page
      routes: {
        '/signup': (context) => const SignUpScreen(),
        '/login': (context) => const SignInScreen(),
        '/home': (context) => const HomeScreen(),
        '/forget-password': (context) => const ForgetPasswordScreen(),
      },
    );
  }
}
