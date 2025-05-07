import 'package:flutter/material.dart';

class TopBarCart extends StatelessWidget {
  const TopBarCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Panier",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
         
        ],
      ),
    );
  }
}
