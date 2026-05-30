import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/string_constants.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../routes/app_routes.dart';

class ProfileController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  final isLoading = false.obs;

  String get userName {
    final user = FirebaseAuth.instance.currentUser;
    return user?.displayName ?? user?.email?.split('@').first ?? 'User';
  }

  String get userEmail {
    return FirebaseAuth.instance.currentUser?.email ?? '';
  }

  String? get userPhotoUrl {
    return FirebaseAuth.instance.currentUser?.photoURL;
  }

  Future<void> logout() async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text(StringConstants.logout),
        content: const Text(StringConstants.logoutConfirm),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text(StringConstants.cancel),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            child: const Text(StringConstants.confirm),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      isLoading.value = true;
      await _authRepository.logout();
      Get.offAllNamed(AppRoutes.login);
    }
  }
}
