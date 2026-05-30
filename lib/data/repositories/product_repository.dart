import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/services/cloudinary_service.dart';
import '../../core/services/firestore_service.dart';
import '../models/product_model.dart';

class ProductRepository {
  final FirestoreService _firestoreService = FirestoreService();

  Stream<List<ProductModel>> getProducts() {
    return _firestoreService.getProducts().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ProductModel.fromMap(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    });
  }

  Future<void> createProduct({
    required String userId,
    required String title,
    required double price,
    required String imagePath,
    String description = '',
  }) async {
    final imageUrl = await CloudinaryService.uploadImage(imagePath);
    await _firestoreService.createProduct({
      'userId': userId,
      'title': title,
      'price': price,
      'imageUrl': imageUrl ?? '',
      'description': description,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
