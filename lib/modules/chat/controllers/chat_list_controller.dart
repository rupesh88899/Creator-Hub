import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/chat_repository.dart';

class ChatListController extends GetxController {
  final ChatRepository _chatRepository = ChatRepository();

  final users = <UserModel>[].obs;
  final isLoading = false.obs;

  final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  void onInit() {
    super.onInit();
    loadUsers();
  }

  void loadUsers() {
    isLoading.value = true;
    _chatRepository.getAllUsers(currentUserId).listen(
      (data) {
        users.assignAll(data);
        isLoading.value = false;
      },
      onError: (e) {
        isLoading.value = false;
      },
    );
  }
}
