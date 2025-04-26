import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isLoading = false;
  bool acceptTerms = false;
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  // Liste des domaines autorisés
  final List<String> allowedDomains = [
    'gmail.com',
    'yahoo.com',
    'outlook.com',
    'icloud.com',
    'protonmail.com',
    'zoho.com',
    'aol.com',
    'yandex.com',
    'mail.com',
    'gmx.com',
    'fastmail.com',
    'tutanota.com',
    'mail.ru',
    'orange.fr',
    'sfr.fr',
    'free.fr',
    'walla.com',
    'o2online.de',
    'twitch.com',
    'discord.com',
  ];

  void showToast(String message, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  // Validation de l'email
  bool isValidEmail(String email) {
    final domain = email.split('@').last;
    return allowedDomains.contains(domain);
  }

  Future<void> signUp() async {
    final name = fullNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      showToast("All fields are required.");
      return;
    }

    if (!isValidEmail(email)) {
      showToast(
        "Please use a valid email address (e.g., gmail.com, yahoo.com).",
      );
      return;
    }

    if (password != confirmPassword) {
      showToast("Passwords do not match.");
      return;
    }

    if (!acceptTerms) {
      showToast("Please accept the Terms & Conditions.");
      return;
    }

    setState(() => isLoading = true);

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = FirebaseAuth.instance.currentUser;
      print("User signed up: ${user?.email}");

      showToast("Account created successfully!", success: true);
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      showToast(e.message ?? "Signup failed.");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset('assets/images/logo.jpeg', height: 100),
              ),
              const SizedBox(height: 30),
              const Text(
                "Create your account",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              _buildInputField("Full Name", fullNameController),
              const SizedBox(height: 16),
              _buildInputField("Email", emailController),
              const SizedBox(height: 16),
              _buildPasswordField(
                "Password",
                passwordController,
                _passwordVisible,
              ),
              const SizedBox(height: 16),
              _buildPasswordField(
                "Confirm Password",
                confirmPasswordController,
                _confirmPasswordVisible,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: acceptTerms,
                    onChanged: (value) => setState(() => acceptTerms = value!),
                  ),
                  const Expanded(
                    child: Text(
                      "I accept the Terms & Conditions",
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: signUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              const SizedBox(height: 24),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/login'),
                  child: const Text(
                    "Already have an account? Sign In",
                    style: TextStyle(
                      color: Colors.black54,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fonction pour afficher un champ de texte avec un mot de passe
  Widget _buildPasswordField(
    String label,
    TextEditingController controller,
    bool isPasswordVisible,
  ) {
    return TextField(
      controller: controller,
      obscureText: !isPasswordVisible,
      style: const TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black54),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(12),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.black54,
          ),
          onPressed: () {
            setState(() {
              if (label == "Password") {
                _passwordVisible = !_passwordVisible;
              } else {
                _confirmPasswordVisible = !_confirmPasswordVisible;
              }
            });
          },
        ),
      ),
    );
  }

  // Fonction pour afficher un champ de texte classique
  Widget _buildInputField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black54),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
