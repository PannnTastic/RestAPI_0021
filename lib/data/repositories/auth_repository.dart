import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:rest_api_0021/data/models/user_model.dart';

class AuthRepository {
  final String baseUrl = "https://ternak-be-production.up.railway.app/api/v1";
  final _storage =  const FlutterSecureStorage();

  Future<void> persistToken(String token) async {
    await _storage.write(key: 'jwt_token', value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: 'jwt_token');
  }

  Future<UserModel> login(String email, String password) async {
    try{
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: jsonEncode({"email": email, "password": password}),
      );
      final data = jsonDecode(response.body);
      developer.log("Response Login: ${response.body}", name: "API");

      if (response.statusCode == 200) {
        await persistToken(data["token"]);
        return UserModel.fromJson(data["user"]);
      } else {
        throw Exception(data['message'] ?? "Gagal Login");
      }
    }catch (e){
      developer.log("Error Login: $e", name: "API");
      rethrow;
    }

  }
  Future<void> register(String username, String email, String password) async{
    try{
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: jsonEncode({"username": username, "email": email, "password": password}),
      );
      final data = jsonDecode(response.body);
      developer.log("Response Register: ${response.body}", name: "API");

      if (response.statusCode != 201 && response.statusCode != 200){
        throw Exception(data['message'] ?? "Gagal Register");
      }
    }catch (e){
      developer.log("Error Register: $e", name: "API");
      rethrow;
    }
    
  }
  
}