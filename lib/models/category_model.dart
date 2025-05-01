import 'package:flutter/material.dart';

class Category {
  final String name;
  final IconData icon;

  Category({required this.name, required this.icon});

  static List<Category> categories = [
    Category(name: 'Homme', icon: Icons.male),
    Category(name: 'Femme', icon: Icons.female),
    Category(name: 'Bébé', icon: Icons.child_care),
    Category(name: 'Chaussures', icon: Icons.directions_walk),
    Category(name: 'Accessoires', icon: Icons.watch),
  ];
}
