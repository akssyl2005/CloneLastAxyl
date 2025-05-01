import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/product_model.dart';
import 'package:complete_shop_clone/servises/firestore_service.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  String? _selectedSize;
  String? _selectedColor;
  int _quantity = 1;
  int _rating = 0;
  final TextEditingController _commentController = TextEditingController();

  final List<String> availableSizes = ["S", "M", "L", "XL"];
  final List<String> availableColors = ["Rouge", "Bleu", "Noir", "Vert"];

  void _submitReview() async {
    if (_commentController.text.trim().isEmpty || _rating == 0) return;

    final review = {
      'userName': 'Utilisateur Anonyme',
      'comment': _commentController.text.trim(),
      'rating': _rating,
      'createdAt': Timestamp.now(),
    };

    await FirebaseFirestore.instance
        .collection('products')
        .doc(widget.product.id)
        .collection('reviews')
        .add(review);

    _commentController.clear();
    _rating = 0;
    setState(() {}); // Recharge les avis
  }

  Widget _buildStarRating() {
    return Row(
      children: List.generate(5, (index) {
        final filled = index < _rating;
        return IconButton(
          icon: Icon(
            filled ? Icons.star : Icons.star_border,
            color: filled ? Colors.amber : Colors.grey,
          ),
          onPressed: () => setState(() => _rating = index + 1),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🖼️ Image
            Center(
              child: Image.network(
                product.imageUrl,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),

            // 📋 Infos produit
            Text(product.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text(product.description, style: const TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 8),

            Row(
              children: [
                Text("\$${product.salePrice ?? product.price}",
                    style: const TextStyle(fontSize: 20, color: Colors.green)),
                if (product.salePrice != null)
                  Text(" \$${product.price}",
                      style: const TextStyle(fontSize: 16, decoration: TextDecoration.lineThrough, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 16),

            // 📏 Taille
            const Text("Taille", style: TextStyle(fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8,
              children: availableSizes.map((size) {
                final selected = _selectedSize == size;
                return ChoiceChip(
                  label: Text(size),
                  selected: selected,
                  onSelected: (_) => setState(() => _selectedSize = size),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // 🎨 Couleur
            const Text("Couleur", style: TextStyle(fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8,
              children: availableColors.map((color) {
                final selected = _selectedColor == color;
                return ChoiceChip(
                  label: Text(color),
                  selected: selected,
                  onSelected: (_) => setState(() => _selectedColor = color),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // 🔢 Quantité
            const Text("Quantité", style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    if (_quantity > 1) setState(() => _quantity--);
                  },
                  icon: const Icon(Icons.remove),
                ),
                Text("$_quantity", style: const TextStyle(fontSize: 16)),
                IconButton(
                  onPressed: () {
                    if (_quantity < product.stockQuantity) setState(() => _quantity++);
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ✍️ Avis utilisateur
            const Text("Laisser un avis", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildStarRating(),
            TextField(
              controller: _commentController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Votre commentaire...",
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _submitReview,
              child: const Text("Envoyer l'avis"),
            ),
            const SizedBox(height: 24),

            // 📣 Avis existants
            const Text("Avis des utilisateurs", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: FirestoreService().fetchReviews(product.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return const CircularProgressIndicator();

                final reviews = snapshot.data ?? [];

                if (reviews.isEmpty) return const Text("Aucun avis pour ce produit.");

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    final r = reviews[index];
                    return ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.person)),
                      title: Row(
                        children: [
                          Text(r['userName'] ?? "Utilisateur"),
                          const SizedBox(width: 8),
                          ...List.generate(
                            r['rating'] ?? 0,
                            (_) => const Icon(Icons.star, color: Colors.amber, size: 16),
                          )
                        ],
                      ),
                      subtitle: Text(r['comment'] ?? ""),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
