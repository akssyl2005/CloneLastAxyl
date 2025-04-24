import 'package:flutter/material.dart';
import 'package:complete_shop_clone/models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(product.image, fit: BoxFit.cover),
            const SizedBox(height: 16),
            Text(
              product.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "€ ${product.price.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 20, color: Colors.blueAccent),
            ),
            const SizedBox(height: 16),
            Text(
              product.category, // Si tu as une description dans ton modèle
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
