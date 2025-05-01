import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:complete_shop_clone/profile/profile_screen.dart';

class ProfileLoader extends StatelessWidget {
  final String uid;

  const ProfileLoader({super.key, required this.uid});

  Future<bool> _isCurrentUser() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    return currentUser != null && currentUser.uid == uid;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isCurrentUser(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.data!) {
          return const ProfileScreen(); // Ton propre profil
        } else {
          return Scaffold(
            appBar: AppBar(title: const Text('Profil utilisateur')),
            body: Center(child: Text("Profil d'un autre utilisateur : $uid")),
          );
        }
      },
    );
  }
}
