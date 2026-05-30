import '../constants/string_constants.dart';

class Validators {
  Validators._();

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return StringConstants.enterEmail;
    }
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return StringConstants.enterValidEmail;
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return StringConstants.enterPassword;
    }
    if (value.length < 6) {
      return StringConstants.passwordLength;
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return StringConstants.enterName;
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.trim().isEmpty) {
      return StringConstants.enterPassword;
    }
    if (value != password) {
      return StringConstants.passwordsDontMatch;
    }
    return null;
  }
}
