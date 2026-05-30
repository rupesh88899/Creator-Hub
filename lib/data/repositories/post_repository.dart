import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/services/cloudinary_service.dart';
import '../../core/services/firestore_service.dart';
import '../models/post_model.dart';

class PostRepository {
  final FirestoreService _firestoreService = FirestoreService();

  Stream<List<PostModel>> getPosts() {
    return _firestoreService.getPosts().map((snapshot) {
      return snapshot.docs.map((doc) {
        return PostModel.fromMap(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    });
  }

  Future<void> createPost({
    required String userId,
    required String userName,
    required String userPhoto,
    required String text,
    String? imagePath,
  }) async {
    String? imageUrl;
    if (imagePath != null) {
      imageUrl = await CloudinaryService.uploadImage(imagePath);
    }

    await _firestoreService.createPost({
      'userId': userId,
      'userName': userName,
      'userPhoto': userPhoto,
      'text': text,
      'imageUrl': imageUrl,
      'likes': [],
      'likeCount': 0,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> likePost(String postId, String userId) {
    return _firestoreService.likePost(postId, userId);
  }

  Future<void> unlikePost(String postId, String userId) {
    return _firestoreService.unlikePost(postId, userId);
  }
}
