import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:complete_shop_clone/servises/auth_service.dart';

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
  DateTime? selectedDate;
  String selectedGender = '';
  File? profileImage;

  bool isLoading = false;
  bool acceptTerms = false;
  bool showPassword = false;
  bool showConfirmPassword = false;

  void showToast(String message, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => profileImage = File(picked.path));
    }
  }

  Future<void> selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() => selectedDate = pickedDate);
    }
  }

  Future<void> signUp() async {
    final name = fullNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        selectedDate == null ||
        selectedGender.isEmpty) {
      showToast("Please fill in all fields.");
      return;
    }

    if (!isValidEmail(email)) {
      showToast("Invalid email address.");
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

  Future<void> signUpWithGoogle() async {
    setState(() => isLoading = true);

    try {
      final userCredential = await AuthService.signInWithGoogle();
      if (userCredential == null) {
        showToast("Google Sign-Up cancelled.");
      } else {
        showToast("Account created with Google!", success: true);
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      showToast("Google sign-up failed.");
    } finally {
      setState(() => isLoading = false);
    }
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[\w-\.]+@(gmail|yahoo|outlook|hotmail|icloud|protonmail|aol|live|msn|wanadoo|orange|free|laposte|sfr|gmx|yandex|mail)\.(com|fr|net|org|co\.uk|de|es|it|ca|ch|be|nl)$',
    );
    return emailRegex.hasMatch(email);
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
                child: GestureDetector(
                  onTap: pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    backgroundImage:
                        profileImage != null ? FileImage(profileImage!) : null,
                    child:
                        profileImage == null
                            ? const Icon(
                              Icons.camera_alt,
                              size: 40,
                              color: Colors.black45,
                            )
                            : null,
                  ),
                ),
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
              _buildInputField(
                "Password",
                passwordController,
                isPassword: true,
                showPassword: showPassword,
                togglePassword:
                    () => setState(() => showPassword = !showPassword),
              ),
              const SizedBox(height: 16),
              _buildInputField(
                "Confirm Password",
                confirmPasswordController,
                isPassword: true,
                showPassword: showConfirmPassword,
                togglePassword:
                    () => setState(
                      () => showConfirmPassword = !showConfirmPassword,
                    ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: selectDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: Text(
                    selectedDate == null
                        ? "Select Date of Birth"
                        : "Date of Birth: ${selectedDate!.toLocal().toString().split(' ')[0]}",
                    style: const TextStyle(color: Colors.black54),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedGender.isEmpty ? null : selectedGender,
                decoration: InputDecoration(
                  labelText: "Gender",
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items:
                    ['Male', 'Female', 'Other'].map((gender) {
                      return DropdownMenuItem(
                        value: gender,
                        child: Text(gender),
                      );
                    }).toList(),
                onChanged: (value) => setState(() => selectedGender = value!),
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
                  : Column(
                    children: [
                      SizedBox(
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
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: signUpWithGoogle,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black87,
                            side: const BorderSide(color: Colors.black),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/images/google.jfif",
                                height: 24,
                              ),
                              const SizedBox(width: 10),
                              const Text("Sign up with Google"),
                            ],
                          ),
                        ),
                      ),
                    ],
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

  Widget _buildInputField(
    String label,
    TextEditingController controller, {
    bool isPassword = false,
    bool showPassword = false,
    VoidCallback? togglePassword,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword && !showPassword,
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
        suffixIcon:
            isPassword
                ? IconButton(
                  icon: Icon(
                    showPassword ? Icons.visibility : Icons.visibility_off,
                    color: Colors.black54,
                  ),
                  onPressed: togglePassword,
                )
                : null,
      ),
    );
  }
}
