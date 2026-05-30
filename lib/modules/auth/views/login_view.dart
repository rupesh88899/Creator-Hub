import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/string_constants.dart';
import '../../../core/services/connectivity_service.dart';
import '../../../core/utils/validators.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/loading_widget.dart';
import '../../../widgets/no_network_widget.dart';
import '../controllers/auth_controller.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final connectivity = Get.find<ConnectivityService>();
      if (!connectivity.isConnected.value) {
        return const Scaffold(
          body: NoNetworkWidget(),
        );
      }
      return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 80),
                Text(
                  'Welcome Back',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign in to continue',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey,
                      ),
                ),
                const SizedBox(height: 48),
                CustomTextField(
                  controller: _emailController,
                  label: StringConstants.email,
                  hint: 'Enter your email',
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.validateEmail,
                ),
                const SizedBox(height: 16),
                Obx(() => CustomTextField(
                      controller: _passwordController,
                      label: StringConstants.password,
                      hint: 'Enter your password',
                      obscureText: _authController.obscurePassword.value,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _authController.obscurePassword.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () => _authController.obscurePassword
                            .toggle(),
                      ),
                      validator: Validators.validatePassword,
                    )),
                const SizedBox(height: 32),
                Obx(() => _authController.isLoading.value
                    ? const LoadingWidget()
                    : ElevatedButton(
                        onPressed: _onLogin,
                        child: const Text(StringConstants.login),
                      )),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Get.toNamed(AppRoutes.signup),
                  child: Text.rich(
                    TextSpan(
                      text: "${StringConstants.dontHaveAccount} ",
                      children: [
                        TextSpan(
                          text: StringConstants.signup,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      );
    });
  }

  void _onLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      _authController.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    }
  }
}
