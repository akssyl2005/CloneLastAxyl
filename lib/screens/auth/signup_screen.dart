import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
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

  bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[\w-\.]+@(gmail|yahoo|outlook|hotmail|icloud|protonmail|aol|live|msn|wanadoo|orange|free|laposte|sfr|gmx|yandex|mail|se.univ-bejaia)\.(com|fr|net|org|co\.uk|de|es|it|ca|ch|be|nl|dz)$',
    );
    return emailRegex.hasMatch(email);
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
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final user = userCredential.user;
      String? imageUrl;

      if (profileImage != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('user_profiles')
            .child('${user!.uid}.jpg');

        await ref.putFile(profileImage!);
        imageUrl = await ref.getDownloadURL();
      }

      await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
        'uid': user.uid,
        'fullName': name,
        'email': email,
        'dateOfBirth': selectedDate!.toIso8601String(),
        'gender': selectedGender,
        'imageUrl': imageUrl,
        'wishlist': [],
        'createdAt': Timestamp.now(),
      });

      showToast("Account created successfully!", success: true);
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      showToast(e.message ?? "Signup failed.");
    } catch (e) {
      showToast("An error occurred.");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> signUpWithGoogle() async {
    setState(() => isLoading = true);

    try {
      final userCredential = await AuthService.signInWithGoogle();
      final user = userCredential?.user;

      if (userCredential == null || user == null) {
        showToast("Google Sign-Up cancelled.");
        return;
      }

      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

      if (!doc.exists) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'fullName': user.displayName ?? '',
          'email': user.email,
          'imageUrl': user.photoURL,
          'wishlist': [],
          'createdAt': Timestamp.now(),
        });
      }

      showToast("Account created with Google!", success: true);
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      showToast("Google sign-up failed.");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              GestureDetector(
                onTap: pickImage,
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage:
                      profileImage != null ? FileImage(profileImage!) : null,
                  child:
                      profileImage == null
                          ? const Icon(Icons.camera_alt, size: 30)
                          : null,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: fullNameController,
                decoration: const InputDecoration(labelText: "Full Name"),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: passwordController,
                obscureText: !showPassword,
                decoration: InputDecoration(
                  labelText: "Password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      showPassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed:
                        () => setState(() => showPassword = !showPassword),
                  ),
                ),
              ),
              TextField(
                controller: confirmPasswordController,
                obscureText: !showConfirmPassword,
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      showConfirmPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed:
                        () => setState(
                          () => showConfirmPassword = !showConfirmPassword,
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      selectedDate == null
                          ? "Date of Birth: not selected"
                          : "Date of Birth: ${selectedDate!.toLocal().toString().split(' ')[0]}",
                    ),
                  ),
                  TextButton(
                    onPressed: selectDate,
                    child: const Text("Select"),
                  ),
                ],
              ),
              DropdownButtonFormField<String>(
                value: selectedGender.isEmpty ? null : selectedGender,
                items: const [
                  DropdownMenuItem(value: "male", child: Text("Male")),
                  DropdownMenuItem(value: "female", child: Text("Female")),
                  DropdownMenuItem(value: "other", child: Text("Other")),
                ],
                onChanged:
                    (value) => setState(() => selectedGender = value ?? ''),
                decoration: const InputDecoration(labelText: "Gender"),
              ),
              CheckboxListTile(
                value: acceptTerms,
                onChanged: (val) => setState(() => acceptTerms = val ?? false),
                title: const Text("I accept Terms & Conditions"),
              ),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: signUp, child: const Text("Sign Up")),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                icon: const Icon(Icons.login),
                label: const Text("Sign Up with Google"),
                onPressed: signUpWithGoogle,
              ),
              if (isLoading) const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
