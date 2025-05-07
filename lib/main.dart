import 'package:complete_shop_clone/Utils/AjouterProduit.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Écrans
import 'screens/auth/splash.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/auth/sign_in_screen.dart';
import 'screens/auth/forget_password_screen.dart';
import 'screens/home/home_screen.dart';

import 'package:complete_shop_clone/profile/profile_screen.dart';
import 'package:complete_shop_clone/profile/profile_loader.dart';
import 'package:complete_shop_clone/onboarding/onboarding.dart'; // Assurez-vous que ce fichier existe
import '../../../cart/cart_screen.dart';

// Firebase options
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    print("🟡 Initialisation de Firebase...");
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("🟢 Firebase initialisé avec succès.");
  } catch (e, s) {
    print("🔴 Erreur lors de l'initialisation Firebase: $e");
    print("🔍 Stack: $s");
  }

  // Vérification des préférences pour l'onboarding et l'authentification
  final prefs = await SharedPreferences.getInstance();
  final bool seenOnboarding = prefs.getBool('seenOnboarding') ?? false;
  final User? user = FirebaseAuth.instance.currentUser;

  Widget initialScreen;
  if (user != null) {
    initialScreen = const Homepage();
  } else {
    if (!seenOnboarding) {
      initialScreen = const OnBoardingScreen();
    } else {
      initialScreen = const SignInScreen();
    }
  }

  runApp(MyApp(initialScreen: initialScreen));
}

class MyApp extends StatelessWidget {
  final Widget initialScreen;

  const MyApp({super.key, required this.initialScreen});

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
      home: initialScreen,
      routes: {
        '/signup': (context) => const SignUpScreen(),
        '/login': (context) => const SignInScreen(),
        '/home': (context) => const Homepage(),
        '/forget-password': (context) => const ForgetPasswordScreen(),
        '/cart': (context) => const CartScreen(),
        '/profile': (context) => const AddDefaultProductPage(),
          '/client-profile': (context) => const ProfileScreen(),
        
        /*'/profile-loader': (context) {
          final uid = ModalRoute.of(context)!.settings.arguments as String;
          return ProfileLoader(uid: uid);
        },*/
      },
    );
  }
}

