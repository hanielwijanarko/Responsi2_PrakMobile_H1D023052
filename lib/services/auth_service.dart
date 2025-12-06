import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const baseUrl = "http://localhost:3000";

  static Future<Map<String, dynamic>> register(String nama, String email, String password) async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/auth/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "nama": nama,
          "email": email,
          "password": password
        }),
      ).timeout(const Duration(seconds: 10));

      if (res.statusCode == 200 || res.statusCode == 201) {
        return {"success": true, "message": "Register berhasil"};
      } else {
        try {
          final error = jsonDecode(res.body);
          return {"success": false, "message": error['message'] ?? "Register gagal"};
        } catch (_) {
          return {"success": false, "message": "Register gagal"};
        }
      }
    } catch (e) {
      return {"success": false, "message": "Error: $e"};
    }
  }

  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/auth/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password
        }),
      ).timeout(const Duration(seconds: 10));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return {"success": true, "token": data["token"] ?? "", "message": "Login berhasil"};
      } else {
        try {
          final error = jsonDecode(res.body);
          return {"success": false, "message": error['message'] ?? "Login gagal"};
        } catch (_) {
          return {"success": false, "message": "Login gagal"};
        }
      }
    } catch (e) {
      return {"success": false, "message": "Error: $e"};
    }
  }
}
