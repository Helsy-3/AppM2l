import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? user;
  bool _isLoading = true;

  final _sportController = TextEditingController();
  String? _niveau;

  @override
  void initState() {
    super.initState();
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    try {
      final res = await http.get(
        Uri.parse('http://10.0.2.2:3000/user/profile'),
        headers: {'Authorization': 'Bearer $token'},
      );
      final data = json.decode(res.body);

      if (res.statusCode == 200) {
        setState(() {
          user = data['user'];
          _isLoading = false;
        });
      } else {
        throw Exception(data['error']);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Erreur : $e")));
    }
  }

  Future<void> updateProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      final res = await http.put(
        Uri.parse('http://10.0.2.2:3000/user/complement'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          'sport': _sportController.text,
          'niveau': _niveau,
        }),
      );

      final data = json.decode(res.body);

      if (res.statusCode == 200) {
        Navigator.of(context).pop(); // Fermer le modal
        setState(() {
          user = data['user'];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Profil mis à jour")),
        );
      } else {
        throw Exception(data['error']);
      }
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur : $e")),
      );
    }
  }

  void showEditModal() {
    _sportController.text = user?['sport'] ?? '';
    _niveau = user?['niveau'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Compléter le profil"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: _sportController,
                decoration: const InputDecoration(labelText: "Sport pratiqué"),
              ),
              DropdownButtonFormField<String>(
                value: _niveau,
                onChanged: (val) => setState(() => _niveau = val),
                items: ['Débutant', 'Intermédiaire', 'Avancé', 'Expert']
                    .map((label) => DropdownMenuItem(
                          value: label,
                          child: Text(label),
                        ))
                    .toList(),
                decoration: const InputDecoration(labelText: "Niveau"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: updateProfile,
            child: const Text("Enregistrer"),
          ),
        ],
      ),
    );
  }

  Widget _info(String label, String? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14.0)),
        const SizedBox(height: 4),
        Text(value ?? "Non renseigné",
            style:
                const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil"),
        backgroundColor: Colors.redAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              Navigator.pushReplacementNamed(context, '/login');
            },
          )
        ],
      ),
      body: Center(
        child: Container(
          width: 420,
          margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [BoxShadow(blurRadius: 10, color: Colors.black26)],
          ),
          child: user == null
              ? const Text("Utilisateur introuvable.")
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text("Mon profil",
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 30),
                    _info("Nom", user!['nom']),
                    _info("Prénom", user!['prenom']),
                    _info("Email", user!['email']),
                    _info("Sport pratiqué", user!['sport']),
                    _info("Niveau", user!['niveau']),
                    ElevatedButton(
                      onPressed: showEditModal,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent),
                      child: const Text("Compléter le profil"),
                    ),
                  ],
                ),
        ),
      ),
      backgroundColor: const Color(0xFFF5F5F5),
    );
  }
}
