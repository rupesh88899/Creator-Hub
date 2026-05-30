import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/string_constants.dart';
import '../../../core/utils/validators.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/loading_widget.dart';
import '../controllers/auth_controller.dart';

class SignupView extends StatelessWidget {
  SignupView({super.key});

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),
                Text(
                  'Create Account',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign up to get started',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey,
                      ),
                ),
                const SizedBox(height: 48),
                CustomTextField(
                  controller: _nameController,
                  label: StringConstants.name,
                  hint: 'Enter your full name',
                  textCapitalization: TextCapitalization.words,
                  validator: Validators.validateName,
                ),
                const SizedBox(height: 16),
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
                      hint: 'Create a password',
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
                const SizedBox(height: 16),
                Obx(() => CustomTextField(
                      controller: _confirmPasswordController,
                      label: StringConstants.confirmPassword,
                      hint: 'Confirm your password',
                      obscureText: _authController.obscureConfirmPassword.value,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _authController.obscureConfirmPassword.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () => _authController
                            .obscureConfirmPassword
                            .toggle(),
                      ),
                      validator: (value) =>
                          Validators.validateConfirmPassword(
                        value,
                        _passwordController.text,
                      ),
                    )),
                const SizedBox(height: 32),
                Obx(() => _authController.isLoading.value
                    ? const LoadingWidget()
                    : ElevatedButton(
                        onPressed: _onSignUp,
                        child: const Text(StringConstants.signup),
                      )),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text.rich(
                    TextSpan(
                      text: "${StringConstants.alreadyHaveAccount} ",
                      children: [
                        TextSpan(
                          text: StringConstants.login,
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
  }

  void _onSignUp() {
    if (_formKey.currentState?.validate() ?? false) {
      _authController.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        name: _nameController.text.trim(),
      );
    }
  }
}
