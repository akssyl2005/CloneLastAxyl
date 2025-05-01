class Product {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final double salePrice;
  final bool isOnSale;
  final int stockQuantity;
  final List<String> categories;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.salePrice,
    required this.isOnSale,
    required this.stockQuantity,
    required this.categories,
  });

  factory Product.fromMap(Map<String, dynamic> data, String documentId) {
    return Product(
      id: documentId,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      salePrice: (data['salePrice'] as num?)?.toDouble() ?? 0.0,
      isOnSale: data['isOnSale'] ?? false,
      stockQuantity: data['stockQuantity'] ?? 0,
      categories: List<String>.from(data['categories'] ?? []),
    );
  }
}
