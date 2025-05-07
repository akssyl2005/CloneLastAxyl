import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddDefaultProductPage extends StatelessWidget {
  const AddDefaultProductPage({Key? key}) : super(key: key);

  Future<void> addDefaultProduct() async {
    await FirebaseFirestore.instance.collection('products').add({
      'name': 'Nom par défaut',
      'price': 0.0,
      'salePrice': 0.0,
      'description': '',
      'imageUrl': '',
      'categories': ['Femme'],
      'isOnSale': false,
      'stockQuantity': 0,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ajouter un produit")),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await addDefaultProduct();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Produit ajouté avec succès")),
            );
          },
          child: const Text("Ajouter produit par défaut"),
        ),
      ),
    );
  }
}
