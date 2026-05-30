import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/string_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Scaffold(
      appBar: AppBar(title: const Text(StringConstants.profile)),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            children: [
              const SizedBox(height: 32),
              CircleAvatar(
                radius: 50,
                backgroundImage: controller.userPhotoUrl != null
                    ? NetworkImage(controller.userPhotoUrl!)
                    : null,
                backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
                child: controller.userPhotoUrl == null
                    ? Icon(
                        Icons.person,
                        size: 50,
                        color: AppTheme.primaryColor,
                      )
                    : null,
              ),
              const SizedBox(height: 24),
              Text(
                controller.userName,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                controller.userEmail,
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: controller.logout,
                  icon: const Icon(Icons.logout, color: Colors.red),
                  label: const Text(
                    StringConstants.logout,
                    style: TextStyle(color: Colors.red),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
