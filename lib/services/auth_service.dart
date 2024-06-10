import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl;

  AuthService({required this.baseUrl});

  Future<String?> getToken(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/wp-json/jwt-auth/v1/token'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      return responseBody['token'];
    } else {
      print('Failed to obtain token: ${response.statusCode}');
      return null;
    }
  }

  Future<int?> uploadImage(String token, File imageFile) async {
    final request = http.MultipartRequest('POST', Uri.parse('$baseUrl/wp-json/wp/v2/media'))
      ..headers['Authorization'] = 'Bearer $token'
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    final response = await request.send();

    if (response.statusCode == 201) {
      final responseData = await response.stream.bytesToString();
      final jsonResponse = jsonDecode(responseData);
      return jsonResponse['id'];
    } else {
      print('Failed to upload image: ${response.statusCode}');
      return null;
    }
  }

  Future<int?> createPostWithImage(String token, String title, String content, int imageId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/wp-json/wp/v2/posts'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'title': title,
        'content': content,
        'status': 'publish',
        'featured_media': imageId,
      }),
    );

    if (response.statusCode == 201) {
      final responseBody = jsonDecode(response.body);
      return responseBody['id'];
    } else {
      print('Failed to create post: ${response.statusCode}');
      return null;
    }
  }
}
