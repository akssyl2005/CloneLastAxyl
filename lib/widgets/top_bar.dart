import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "ReLook",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, "/profile");
            },

           child: const CircleAvatar(
  radius: 20,
  backgroundColor: Colors.white, // Vous pouvez personnaliser la couleur de fond
  child: Icon(
    Icons.person_outline,
    color: Colors.black, // Couleur de l'icône
    size: 24, // Taille de l'icône
  ),
),

          ),
        ],
      ),
    );
  }
}
