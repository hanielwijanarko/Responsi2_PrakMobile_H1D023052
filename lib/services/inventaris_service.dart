import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/inventaris.dart';

class InventarisService {
  static const baseUrl = "http://localhost:3000";

  static Future<Map<String, dynamic>> getAll() async {
    try {
      final res = await http.get(Uri.parse("$baseUrl/inventaris")).timeout(const Duration(seconds: 10));
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        final items = data.map((e) => Inventaris.fromJson(e)).toList();
        return {"success": true, "data": items};
      }
      return {"success": false, "data": []};
    } catch (e) {
      return {"success": false, "data": [], "error": e.toString()};
    }
  }

  static Future<Map<String, dynamic>> create(String nama, int harga, int jumlah, String tanggal) async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/inventaris"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "nama": nama,
          "harga": harga,
          "jumlah": jumlah,
          "tanggal_masuk": tanggal
        }),
      ).timeout(const Duration(seconds: 10));

      if (res.statusCode == 200 || res.statusCode == 201) {
        return {"success": true, "message": "Inventaris berhasil ditambahkan"};
      }
      return {"success": false, "message": "Gagal menambah inventaris"};
    } catch (e) {
      return {"success": false, "message": "Error: $e"};
    }
  }

  static Future<Map<String, dynamic>> update(int id, String nama, int harga, int jumlah, String tanggal) async {
    try {
      final res = await http.put(
        Uri.parse("$baseUrl/inventaris/$id"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "nama": nama,
          "harga": harga,
          "jumlah": jumlah,
          "tanggal_masuk": tanggal
        }),
      ).timeout(const Duration(seconds: 10));

      if (res.statusCode == 200 || res.statusCode == 201) {
        return {"success": true, "message": "Inventaris berhasil diperbarui"};
      }
      return {"success": false, "message": "Gagal memperbarui inventaris"};
    } catch (e) {
      return {"success": false, "message": "Error: $e"};
    }
  }

  static Future<Map<String, dynamic>> deleteItem(int id) async {
    try {
      final res = await http.delete(Uri.parse("$baseUrl/inventaris/$id")).timeout(const Duration(seconds: 10));
      if (res.statusCode == 200) {
        return {"success": true, "message": "Inventaris berhasil dihapus"};
      }
      return {"success": false, "message": "Gagal menghapus inventaris"};
    } catch (e) {
      return {"success": false, "message": "Error: $e"};
    }
  }
}
