import 'package:flutter/material.dart';
import '../models/category_model.dart';

class CategoryCard extends StatelessWidget {
  final Category category;

  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              category.icon,
              size: 30,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          category.name,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
