import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:complete_shop_clone/profile/profile_screen.dart';

class ProfileLoader extends StatelessWidget {
  final String? uid;

  const ProfileLoader({super.key, this.uid});

  Future<bool> _isCurrentUser(String uidToCheck) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    return currentUser != null && currentUser.uid == uidToCheck;
  }

  @override
  Widget build(BuildContext context) {
    final String? effectiveUid = uid ?? FirebaseAuth.instance.currentUser?.uid;

    if (effectiveUid == null) {
      return const Scaffold(
        body: Center(child: Text("Aucun utilisateur connecté.")),
      );
    }

    return FutureBuilder<bool>(
      future: _isCurrentUser(effectiveUid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.data!) {
          return const ProfileScreen(); // Afficher son propre profil
        } else {
          return Scaffold(
            appBar: AppBar(title: const Text('Profil utilisateur')),
            body: Center(
              child: Text("Profil d'un autre utilisateur : $effectiveUid"),
            ),
          );
        }
      },
    );
  }
}
