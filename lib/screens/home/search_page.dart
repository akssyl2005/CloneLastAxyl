import 'package:flutter/material.dart';
import 'package:complete_shop_clone/models/product_model.dart';
import 'package:complete_shop_clone/servises/firestore_service.dart';
import 'package:complete_shop_clone/widgets/product_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _firestore = FirestoreService();
  String _query = '';
  List<Product> _results = [];
  bool _isLoading = false;

  void _search(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _query = '';
        _results = [];
      });
      return;
    }

    setState(() {
      _query = query;
      _isLoading = true;
    });

    final results = await _firestore.searchProductsByName(query.trim());

    setState(() {
      _results = results;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          onChanged: _search,
          decoration: const InputDecoration(
            hintText: "Rechercher un vêtement...",
            border: InputBorder.none,
          ),
        ),
      ),
      body: _query.isEmpty
          ? const Center(child: Text("Commencez à taper pour rechercher."))
          : _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _results.isEmpty
                  ? const Center(child: Text("Aucun résultat trouvé."))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _results.length,
                      itemBuilder: (context, index) {
                        return ProductCard(product: _results[index]);
                      },
                    ),
    );
  }
}

