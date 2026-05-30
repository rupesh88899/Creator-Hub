class ProductModel {
  final String id;
  final String userId;
  final String title;
  final double price;
  final String imageUrl;
  final String description;
  final DateTime? createdAt;

  ProductModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.price,
    required this.imageUrl,
    this.description = '',
    this.createdAt,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map, String docId) {
    return ProductModel(
      id: docId,
      userId: map['userId'] as String? ?? '',
      title: map['title'] as String? ?? '',
      price: (map['price'] as num? ?? 0).toDouble(),
      imageUrl: map['imageUrl'] as String? ?? '',
      description: map['description'] as String? ?? '',
      createdAt: (map['createdAt'] as dynamic)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'price': price,
      'imageUrl': imageUrl,
      'description': description,
    };
  }
}
