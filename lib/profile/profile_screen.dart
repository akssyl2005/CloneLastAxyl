import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserData() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance.collection('users').doc(uid).get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mon Profil")),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: getUserData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final userData = snapshot.data!.data();
          if (userData == null) {
            return const Center(
              child: Text("Aucune donnée utilisateur trouvée."),
            );
          }

          final fullName = userData['fullName'] ?? '';
          final email = userData['email'] ?? '';
          final gender = userData['gender'] ?? '';
          final dob = userData['dateOfBirth']?.toString().split('T')[0] ?? '';
          final imageUrl = userData['imageUrl'];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Si l'utilisateur n'a pas de photo, une image par défaut est affichée
                if (imageUrl != null) ...[
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(imageUrl),
                  ),
                ] else ...[
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(
                      gender == 'female'
                          ? 'https://example.com/default_female_image.jpg' // Remplacez par une image par défaut pour les femmes
                          : 'https://example.com/default_male_image.jpg', // Remplacez par une image par défaut pour les hommes
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                // Affichage de l'email centré
                Text(
                  email,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                // Affichage des informations utilisateur
                _infoRow("Nom complet", fullName),
                _infoRow("Genre", gender),
                _infoRow("Date de naissance", dob),
                const SizedBox(height: 24),
                // Liste des actions disponibles
                _actionTile("Wishlist", Icons.favorite, () {}),
                _actionTile("Aide", Icons.help_outline, () {}),
                _actionTile("Mes commandes", Icons.shopping_bag, () {}),
                _actionTile("Espace Admin", Icons.admin_panel_settings, () {
                  Navigator.pushNamed(context, '/admin');
                }),
                const SizedBox(height: 24),
                // Bouton de déconnexion
                ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.grey.shade300, // Utilisation de backgroundColor
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Se Déconnecter",
                    style: TextStyle(fontSize: 18, color: Colors.black87),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  Widget _actionTile(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
