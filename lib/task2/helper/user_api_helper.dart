import 'dart:convert';
import 'package:http/http.dart' as http;

class UserApiHelper {
  Future<Map<String, dynamic>> fetchData() async {
    final url = Uri.parse("https://dummyjson.com/users");
    final response = await http.get(url);

    try {
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Failed to fetch data!");
      }
    } catch (e) {
      throw Exception("Failed to fetch data: $e");
    }
  }

  Future<Map<String, dynamic>> fetchAuthServiceApi({
    required String username,
    required String password,
  }) async {
    final url = Uri.parse("https://dummyjson.com/auth/login");
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    try {
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Invalid username or password!");
      }
    } catch (e) {
      throw Exception("Failed to authenticate: $e");
    }
  }
}
