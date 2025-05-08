import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panneau Admin'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showProductDialog(context),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final products = snapshot.data?.docs ?? [];

          if (products.isEmpty) {
            return const Center(child: Text("Aucun produit trouvé."));
          }

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final data = product.data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.all(10),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  leading: Image.network(
                    data['imageUrl'],
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                  title: Text(data['name'] ?? ''),
                  subtitle: Text("Prix : ${data['price']} DA"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed:
                            () => _showProductDialog(
                              context,
                              docId: product.id,
                              existingData: data,
                            ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteProduct(context, product.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _deleteProduct(BuildContext context, String productId) async {
    // Afficher une boîte de dialogue de confirmation avant la suppression
    bool confirmDelete =
        await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Confirmer la suppression'),
              content: const Text(
                'Êtes-vous sûr de vouloir supprimer ce produit ?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false), // Annuler
                  child: const Text('Annuler'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true), // Confirmer
                  child: const Text(
                    'Supprimer',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            );
          },
        ) ??
        false; // Si l'utilisateur ferme la boîte de dialogue, on considère que c'est un refus

    // Si l'utilisateur a confirmé la suppression, procéder à la suppression dans Firestore
    if (confirmDelete) {
      await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .delete();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Produit supprimé.")));
    }
  }

  void _showProductDialog(
    BuildContext context, {
    String? docId,
    Map<String, dynamic>? existingData,
  }) {
    final nameController = TextEditingController(text: existingData?['name']);
    final priceController = TextEditingController(
      text: existingData?['price']?.toString(),
    );
    final salePriceController = TextEditingController(
      text: existingData?['salePrice']?.toString(),
    );
    final descController = TextEditingController(
      text: existingData?['description'],
    );
    final stockController = TextEditingController(
      text: existingData?['stockQuantity']?.toString(),
    );
    final imageUrlController = TextEditingController(
      text: existingData?['imageUrl'],
    );
    final categoryController = TextEditingController(
      text: existingData?['categories']?[0] ?? '',
    );
    bool isOnSale = existingData?['isOnSale'] ?? false;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            docId == null ? "Ajouter un produit" : "Modifier le produit",
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nom'),
                ),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Prix'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: salePriceController,
                  decoration: const InputDecoration(labelText: 'Prix soldé'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: stockController,
                  decoration: const InputDecoration(
                    labelText: 'Quantité en stock',
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: imageUrlController,
                  decoration: const InputDecoration(
                    labelText: 'URL de l\'image',
                  ),
                ),
                TextField(
                  controller: categoryController,
                  decoration: const InputDecoration(labelText: 'Catégorie'),
                ),
                SwitchListTile(
                  value: isOnSale,
                  onChanged: (val) => isOnSale = val,
                  title: const Text("En solde ?"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Annuler"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: Text(docId == null ? "Ajouter" : "Mettre à jour"),
              onPressed: () async {
                final productData = {
                  'name': nameController.text.trim(),
                  'price': double.tryParse(priceController.text.trim()) ?? 0,
                  'salePrice':
                      double.tryParse(salePriceController.text.trim()) ?? 0,
                  'description': descController.text.trim(),
                  'stockQuantity':
                      int.tryParse(stockController.text.trim()) ?? 0,
                  'imageUrl': imageUrlController.text.trim(),
                  'isOnSale': isOnSale,
                  'categories': [categoryController.text.trim()],
                };

                if (docId == null) {
                  await FirebaseFirestore.instance
                      .collection('products')
                      .add(productData);
                } else {
                  await FirebaseFirestore.instance
                      .collection('products')
                      .doc(docId)
                      .update(productData);
                }

                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
