import 'package:get/get.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/auth/views/signup_view.dart';
import '../modules/auth/views/splash_screen.dart';
import '../modules/chat/views/chat_room_view.dart';
import '../modules/feed/bindings/feed_binding.dart';
import '../modules/feed/views/create_post_view.dart';
import '../modules/main_screen.dart';
import '../modules/products/bindings/product_binding.dart';
import '../modules/products/views/add_product_view.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final pages = <GetPage>[
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => SignupView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.main,
      page: () => MainScreen(),
    ),
    GetPage(
      name: AppRoutes.createPost,
      page: () => CreatePostView(),
      binding: FeedBinding(),
    ),
    GetPage(
      name: AppRoutes.chatRoom,
      page: () {
        final args = Get.arguments as dynamic;
        return ChatRoomView(otherUser: args);
      },
    ),
    GetPage(
      name: AppRoutes.addProduct,
      page: () => const AddProductView(),
      binding: ProductBinding(),
    ),
  ];
}
