import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';

class CloudinaryService {
  static Future<String?> uploadImage(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        return null;
      }

      final request = http.MultipartRequest(
        'POST',
        Uri.parse(AppConstants.cloudinaryUploadUrl),
      );
      request.fields['upload_preset'] = AppConstants.cloudinaryUploadPreset;
      request.files.add(
        await http.MultipartFile.fromPath('file', filePath),
      );

      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      final jsonData = jsonDecode(responseData) as Map<String, dynamic>;

      if (response.statusCode == 200 && jsonData['secure_url'] != null) {
        return jsonData['secure_url'] as String;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
