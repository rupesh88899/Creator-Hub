import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/services/connectivity_service.dart';
import '../widgets/floating_bottom_nav.dart';
import '../widgets/no_network_widget.dart';
import 'feed/views/feed_view.dart';
import 'chat/views/chat_list_view.dart';
import 'products/views/product_list_view.dart';
import 'profile/views/profile_view.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final _currentIndex = 0.obs;

  final _pages = const [
    FeedView(),
    ChatListView(),
    ProductListView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    final connectivity = Get.find<ConnectivityService>();

    return Obx(() {
      if (!connectivity.isConnected.value) {
        return const Scaffold(
          body: NoNetworkWidget(),
        );
      }
      return Scaffold(
        body: Obx(() => IndexedStack(
              index: _currentIndex.value,
              children: _pages,
            )),
        bottomNavigationBar: Obx(
          () => FloatingBottomNav(
            currentIndex: _currentIndex.value,
            onTap: (index) => _currentIndex.value = index,
          ),
        ),
      );
    });
  }
}
