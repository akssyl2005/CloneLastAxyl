class PromoBanner {
  final String title, description, imageUrl, buttonText, categoryFilter;

  PromoBanner({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.buttonText,
    required this.categoryFilter,
  });

  factory PromoBanner.fromMap(Map<String, dynamic> data) => PromoBanner(
    title: data['title'],
    description: data['description'],
    imageUrl: data['imageUrl'],
    buttonText: data['buttonText'],
    categoryFilter: data['categoryFilter'] ?? '',
  );
}
