import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';
import '../models/banner_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 🔹 Récupérer tous les produits
  Future<List<Product>> fetchProducts() async {
    try {
      final snapshot = await _db.collection('products').get();
      return snapshot.docs.map((doc) {
        print("🟢 Product: ${doc.data()}");
        return Product.fromMap(doc.data(), doc.id);
      }).toList();
    } catch (error) {
      print("Erreur lors de la récupération des produits: $error");
      return []; // Retourne une liste vide en cas d'erreur
    }
  }

  // 🔹 Récupérer les produits selon une catégorie
 Future<List<Product>> fetchProductsByCategory(String category) async {
  try {
    final snapshot = await _db
        .collection('products')
        .where('categories', arrayContains: category)
        .get();

    final products = snapshot.docs.map((doc) {
      print("🔵 Produit filtré: ${doc.data()}");
      return Product.fromMap(doc.data(), doc.id);
    }).toList();

    return products;
  } catch (e) {
    print("❌ Erreur fetchProductsByCategory: $e");
    return [];
  }
}



  // 🔹 Récupérer toutes les bannières
  Future<List<PromoBanner>> fetchAllPromoBanners() async {
    try {
      final snapshot = await _db.collection('banners').get();
      return snapshot.docs.map((doc) {
        print("🟣 Banner: ${doc.data()}");
        return PromoBanner.fromMap(doc.data());
      }).toList();
    } catch (error) {
      print("Erreur lors de la récupération des bannières: $error");
      return []; // Retourne une liste vide en cas d'erreur
    }
  }

  // 🔍 Recherche de produits par nom
  Future<List<Product>> searchProductsByName(String query) async {
    try {
      final snapshot = await _db
          .collection('products')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThan: query + 'z')
          .get();

      return snapshot.docs.map((doc) {
        print("🔎 Produit trouvé: ${doc.data()}");
        return Product.fromMap(doc.data(), doc.id);
      }).toList();
    } catch (error) {
      print("Erreur lors de la recherche des produits: $error");
      return []; // Retourne une liste vide en cas d'erreur
    }
  }

  // 🔹 Récupérer les avis d'un produit
  Future<List<Map<String, dynamic>>> fetchReviews(String productId) async {
    try {
      final snapshot = await _db
          .collection('products')
          .doc(productId)
          .collection('reviews')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (error) {
      print("Erreur lors de la récupération des avis: $error");
      return []; // Retourne une liste vide en cas d'erreur
    }
  }
}

