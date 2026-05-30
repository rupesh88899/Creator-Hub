import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/string_constants.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/empty_state_widget.dart';
import '../../../widgets/loading_widget.dart';
import '../../../widgets/post_card.dart';
import '../controllers/feed_controller.dart';

class FeedView extends StatelessWidget {
  const FeedView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FeedController());

    return Scaffold(
      appBar: AppBar(
        title: const Text(StringConstants.feed),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.loadPosts(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRoutes.createPost),
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.posts.isEmpty) {
          return const LoadingWidget();
        }
        if (controller.posts.isEmpty) {
          return const EmptyStateWidget(message: StringConstants.noPosts);
        }
        return RefreshIndicator(
          onRefresh: () async => controller.loadPosts(),
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: controller.posts.length,
            itemBuilder: (context, index) {
              final post = controller.posts[index];
              return PostCard(
                post: post,
                isLiked: controller.isLiked(post.id),
                onLike: () => controller.toggleLike(post.id),
              );
            },
          ),
        );
      }),
    );
  }
}
