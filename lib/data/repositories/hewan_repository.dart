import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:rest_api_0021/data/models/hewan_model.dart';
import 'package:rest_api_0021/data/providers/storage_provider.dart';

class HewanRepository {
  final String baseUrl = "https://ternak-be-production.up.railway.app/api/v1";
  final StorageProvider _storageProvider = StorageProvider();

  Future<List<HewanModel>> getAllHewan() async {
    try {
      final token = await _storageProvider.getToken();
      final response = await http.get(
        Uri.parse('$baseUrl/hewan'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      final data = jsonDecode(response.body);
      developer.log("Response Get All Hewan: ${response.body}", name: "API");

      if (response.statusCode == 200) {
        return (data['data'] as List)
            .map((e) => HewanModel.fromJson(e))
            .toList();
      } else {
        throw Exception(data['message'] ?? "Gagal Mendapatkan Data Hewan");
      }
    } catch (e) {
      developer.log("Error Get All Hewan: $e", name: "API");
      rethrow;
    }
  }

  Future<void> createHewan(Map<String, dynamic> hewanData) async {
    try {
      final token = await _storageProvider.getToken();
      final response = await http.post(
        Uri.parse('$baseUrl/hewan'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(hewanData),
      );
      final data = jsonDecode(response.body);
      developer.log("Response Create Hewan: ${response.body}", name: "API");

      if (response.statusCode != 201 && response.statusCode != 200) {
        throw Exception(data['message'] ?? "Gagal Menambahkan Data Hewan");
      }
    } catch (e) {
      developer.log("Error Create Hewan: $e", name: "API");
      rethrow;
    }
  }

  Future<void> updateHewan(int id, Map<String, dynamic> hewanData) async {
    try {
      final token = await _storageProvider.getToken();
      final response = await http.put(
        Uri.parse('$baseUrl/hewan/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(hewanData),
      );
      final data = jsonDecode(response.body);
      developer.log("Response Update Hewan: ${response.body}", name: "API");

      if (response.statusCode != 200) {
        throw Exception(data['message'] ?? "Gagal Mengupdate Data Hewan");
      }
    } catch (e) {
      developer.log("Error Update Hewan: $e", name: "API");
      rethrow;
    }
  }

  Future<void> deleteHewan(int id) async {
    try {
      final token = await _storageProvider.getToken();
      final response = await http.delete(
        Uri.parse('$baseUrl/hewan/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      final data = jsonDecode(response.body);
      developer.log("Response Delete Hewan: ${response.body}", name: "API");

      if (response.statusCode != 200) {
        throw Exception(data['message'] ?? "Gagal Menghapus Data Hewan");
      }
    } catch (e) {
      developer.log("Error Delete Hewan: $e", name: "API");
      rethrow;
    }
  }
}