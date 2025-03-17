import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:3000';

  // ✅ Inscription
  static Future<Map<String, dynamic>> registerUser(
      String nom, String prenom, String email, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/user/register'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'nom': nom,
              'prenom': prenom,
              'email': email,
              'password': password
            }),
          )
          .timeout(const Duration(seconds: 10));

      return json.decode(response.body);
    } catch (e) {
      throw Exception('Erreur d\'inscription : $e');
    }
  }

  // ✅ Connexion
  static Future<Map<String, dynamic>> loginUser(
      String email, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/user/login'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({'email': email, 'password': password}),
          )
          .timeout(const Duration(seconds: 10));

      return json.decode(response.body);
    } catch (e) {
      throw Exception('Erreur de connexion : $e');
    }
  }
}
