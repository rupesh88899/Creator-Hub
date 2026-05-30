import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../../core/constants/string_constants.dart';
import '../../../data/models/post_model.dart';
import '../../../data/repositories/post_repository.dart';

class FeedController extends GetxController {
  final PostRepository _postRepository = PostRepository();

  final posts = <PostModel>[].obs;
  final isLoading = false.obs;

  final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  void onInit() {
    super.onInit();
    loadPosts();
  }

  void loadPosts() {
    isLoading.value = true;
    _postRepository.getPosts().listen(
      (data) {
        posts.assignAll(data);
        isLoading.value = false;
      },
      onError: (e) {
        isLoading.value = false;
        Get.snackbar(
          StringConstants.errorOccurred,
          'Failed to load posts',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }

  bool isLiked(String postId) {
    final post = posts.firstWhereOrNull((p) => p.id == postId);
    return post?.likes.contains(currentUserId) ?? false;
  }

  Future<void> toggleLike(String postId) async {
    try {
      if (isLiked(postId)) {
        await _postRepository.unlikePost(postId, currentUserId);
      } else {
        await _postRepository.likePost(postId, currentUserId);
      }
    } catch (e) {
      Get.snackbar(
        StringConstants.errorOccurred,
        'Failed to update like',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
