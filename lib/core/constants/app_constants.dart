import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  AppConstants._();

  static const String appName = 'Creator Hub';

  static String get cloudinaryCloudName =>
      dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';
  static String get cloudinaryApiKey =>
      dotenv.env['CLOUDINARY_API_KEY'] ?? '';
  static String get cloudinaryApiSecret =>
      dotenv.env['CLOUDINARY_API_SECRET'] ?? '';
  static String get cloudinaryUploadPreset =>
      dotenv.env['CLOUDINARY_UPLOAD_PRESET'] ?? 'ml_default';

  static String get cloudinaryUploadUrl =>
      'https://api.cloudinary.com/v1_1/$cloudinaryCloudName/image/upload';

  static const Duration cacheDuration = Duration(hours: 1);

  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double cardRadius = 12.0;
  static const double buttonRadius = 8.0;
}
