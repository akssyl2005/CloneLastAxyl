import 'package:complete_shop_clone/screens/whishlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/help_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserData() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance.collection('users').doc(uid).get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Profil",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
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

          final fullName = userData['fullName'] ?? 'Mohand Salah';
          final email = userData['email'] ?? 'Mohandsalahmak@gmail.com';
          final gender = userData['gender'] ?? 'Male';
          final dob =
              userData['dateOfBirth']?.toString().split('T')[0] ?? '2000-01-13';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey.shade300,
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 16),

                Text(
                  fullName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),

                Text(
                  email,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 24),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Informations personnelles",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      _infoRow("Nom complet", fullName),
                      const Divider(),
                      _infoRow("Genre", gender),
                      const Divider(),
                      _infoRow("Date de naissance", dob),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                Column(
                  children: [
                    _customButton("Wishlist", Icons.favorite_border, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const WishlistScreen(),
                        ),
                      );
                    }),
                    const SizedBox(height: 12),
                    _customButton("Mes cartes", Icons.credit_card, () {}),
                    const SizedBox(height: 12),
                    _customButton("Mes commandes", Icons.shopping_bag, () {}),
                    const SizedBox(height: 12),
                    _customButton("Aide", Icons.help_outline, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HelpScreen(),
                        ),
                      );
                    }),
                    const SizedBox(height: 12),

                    _customButton(
                      "Espace Admin",
                      Icons.admin_panel_settings,
                      () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            String enteredPassword = '';
                            bool wrongPassword = false;

                            return StatefulBuilder(
                              builder: (context, setState) {
                                return AlertDialog(
                                  title: const Text("Mot de passe requis"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        "Veuillez entrer le mot de passe admin.",
                                      ),
                                      const SizedBox(height: 12),
                                      TextField(
                                        obscureText: true,
                                        onChanged: (value) {
                                          enteredPassword = value;
                                        },
                                        decoration: InputDecoration(
                                          hintText: "Mot de passe",
                                          errorText:
                                              wrongPassword
                                                  ? "Mot de passe incorrect"
                                                  : null,
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("Annuler"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        if (enteredPassword == "admin123") {
                                          Navigator.pop(context);
                                          Future.microtask(() {
                                            Navigator.pushNamed(
                                              context,
                                              '/admin',
                                            );
                                          });
                                        } else {
                                          setState(() {
                                            wrongPassword = true;
                                          });
                                        }
                                      },
                                      child: const Text("Valider"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Se Déconnecter",
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
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
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  Widget _customButton(String text, IconData icon, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.grey.shade300),
        ),
        elevation: 0,
      ),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 16),
          Text(text, style: const TextStyle(fontSize: 16)),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    );
  }
}
