import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as developer;

class ImageUploadService {
  static const String _cloudName = 'dasmqt3vr';
  static const String _uploadPreset = 'govichain_upload';

  static Future<List<String>> uploadImages(List<File> imageFiles) async {
    final List<String> imageUrls = [];
    final url = Uri.parse('https://api.cloudinary.com/v1_1/$_cloudName/upload');

    try {
      for (final imageFile in imageFiles) {
        final request = http.MultipartRequest('POST', url);
        request.fields['upload_preset'] = _uploadPreset;
        request.files.add(
          await http.MultipartFile.fromPath('file', imageFile.path),
        );

        final response = await request.send();
        final responseData = await response.stream.toBytes();
        final resString = String.fromCharCodes(responseData);
        final jsonMap = jsonDecode(resString);

        if (response.statusCode == 200) {
          imageUrls.add(jsonMap['secure_url']);
          developer.log("Uploaded image URL: ${jsonMap['secure_url']}");
        } else {
          throw Exception(
            'Failed to upload image: ${jsonMap['error']?.toString()}',
          );
        }
      }
      return imageUrls;
    } catch (e) {
      developer.log("Image upload error: $e");
      throw Exception('Image upload failed: $e');
    }
  }
}
