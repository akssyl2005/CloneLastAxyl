import 'package:flutter/material.dart';
import 'package:complete_shop_clone/servises/firestore_service.dart';
import 'package:complete_shop_clone/models/product_model.dart';
import 'package:complete_shop_clone/models/banner_model.dart';
import 'package:complete_shop_clone/widgets/promo_banner_caroussel.dart';
import 'package:complete_shop_clone/widgets/product_card.dart';
import 'package:complete_shop_clone/widgets/section_title.dart';

class Category {
  final String name;
  final IconData icon;

  Category({required this.name, required this.icon});
}

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  final _firestore = FirestoreService();
  List<Product> _products = [];
  List<PromoBanner> _banners = [];

  final List<Category> _categories = [
    Category(name: "Homme", icon: Icons.male),
    Category(name: "Femme", icon: Icons.female),
    Category(name: "Bébé", icon: Icons.child_care),
    Category(name: "Chaussures", icon: Icons.directions_walk),
    Category(name: "Accessoires", icon: Icons.watch),
  ];

  String? _selectedCategory; // Catégorie sélectionnée

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() async {
    final products = await _firestore.fetchProducts();
    final banners = await _firestore.fetchAllPromoBanners();
    setState(() {
      _products = products;
      _banners = banners;
      _selectedCategory = null; // aucune catégorie sélectionnée au début
    });
  }

  void _filterByCategory(String category) async {
    final filtered = await _firestore.fetchProductsByCategory(category);
    setState(() {
      _products = filtered;
      _selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Promo Banner
          if (_banners.isNotEmpty)
            SizedBox(
              height: 180,
              child: PromoBannerCarousel(banners: _banners),
            ),

          const SizedBox(height: 24),

          // 🔹 Catégories
          const SectionTitle(title: "Catégories"),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  _categories.map((category) {
                    final isSelected = _selectedCategory == category.name;
                    return GestureDetector(
                      onTap: () => _filterByCategory(category.name),
                      child: Container(
                        width: 70,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor:
                                  isSelected ? Colors.black : Colors.grey[200],
                              child: Icon(
                                category.icon,
                                size: 24,
                                color:
                                    isSelected ? Colors.white : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              category.name,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight:
                                    isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),

          const SizedBox(height: 24),

          // 🔹 Produits
          SectionTitle(
            title:
                _selectedCategory == null ? "Top Selling" : _selectedCategory!,
          ),
          const SizedBox(height: 12),
          _products.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : SizedBox(
                height: 260,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _products.length,
                  itemBuilder: (_, i) => ProductCard(product: _products[i]),
                ),
              ),
        ],
      ),
    );
  }
}
