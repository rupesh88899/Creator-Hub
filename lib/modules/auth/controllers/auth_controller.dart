import 'package:get/get.dart';
import '../../../core/constants/string_constants.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../routes/app_routes.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  final isLoading = false.obs;
  final obscurePassword = true.obs;
  final obscureConfirmPassword = true.obs;

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      await _authRepository.login(email: email, password: password);
      Get.offAllNamed(AppRoutes.main);
    } catch (e) {
      Get.snackbar(
        StringConstants.errorOccurred,
        _getFirebaseErrorMessage(e),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      isLoading.value = true;
      await _authRepository.signUp(
        email: email,
        password: password,
        name: name,
      );
      Get.offAllNamed(AppRoutes.main);
    } catch (e) {
      Get.snackbar(
        StringConstants.errorOccurred,
        _getFirebaseErrorMessage(e),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  String _getFirebaseErrorMessage(Object error) {
    final message = error.toString();
    if (message.contains('email-already-in-use')) {
      return 'This email is already registered';
    }
    if (message.contains('user-not-found')) {
      return 'No user found with this email';
    }
    if (message.contains('wrong-password')) {
      return 'Incorrect password';
    }
    if (message.contains('invalid-credential')) {
      return 'Invalid email or password';
    }
    if (message.contains('network-request-failed')) {
      return StringConstants.noInternet;
    }
    return StringConstants.errorOccurred;
  }
}
