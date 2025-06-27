import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ReservePage extends StatefulWidget {
  const ReservePage({super.key});

  @override
  ReservePageState createState() => ReservePageState();
}

class ReservePageState extends State<ReservePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  String? _pricePerDay;
  String? _totalAmount = "";
  String? _duration = "";
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      setState(() {
        _pricePerDay = args['price'].toString();
      });
    }
  }

  void _calculateTotal() {
    if (_startDateController.text.isNotEmpty &&
        _endDateController.text.isNotEmpty &&
        _pricePerDay != null) {
      DateTime startDate = DateTime.parse(_startDateController.text);
      DateTime endDate = DateTime.parse(_endDateController.text);
      int durationDays = endDate.difference(startDate).inDays;
      setState(() {
        _duration = "$durationDays jours";
        _totalAmount =
            (double.parse(_pricePerDay!) * durationDays).toStringAsFixed(2);
      });
    }
  }

  Future<void> _sendReservation() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez vous connecter.")),
      );
      return;
    }

    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final int? spaceId = args?['space_id'];
    if (spaceId == null) return;

    final String startDate = _startDateController.text;
    final String endDate = _endDateController.text;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('https://m2l-production.up.railway.app/reservations/create'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'space_id': spaceId,
          'start_date': startDate,
          'end_date': endDate,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? "Réservation créée !")),
        );
        setState(() {
          _startDateController.clear();
          _endDateController.clear();
          _duration = "";
          _totalAmount = "";
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? "Erreur de réservation")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Erreur de communication avec le serveur")),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  Widget _buildDatePicker(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon: const Icon(Icons.calendar_today),
      ),
      readOnly: true,
      onTap: () async {
        final DateTime? selectedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2101),
        );
        if (selectedDate != null) {
          setState(() {
            controller.text = selectedDate.toIso8601String().split('T')[0];
          });
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Ce champ est obligatoire';
        }
        return null;
      },
    );
  }

  Widget _buildReservationSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        children: [
          const Text(
            "Résumé de la réservation",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          _buildPriceInfo("Prix par jour", "$_pricePerDay €"),
          _buildPriceInfo("Durée", _duration ?? "---"),
          _buildPriceInfo("Montant Total",
              _totalAmount != null ? "$_totalAmount €" : "---"),
        ],
      ),
    );
  }

  Widget _buildPriceInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Réserver un Espace - M2L"),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                "Formulaire de Réservation",
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFDC320F)),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildDatePicker("Date de début *", _startDateController),
                    const SizedBox(height: 20),
                    _buildDatePicker("Date de fin *", _endDateController),
                    const SizedBox(height: 20),
                    _buildReservationSummary(),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                              if (_formKey.currentState?.validate() ?? false) {
                                _calculateTotal();
                                _sendReservation();
                              }
                            },
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text("Créer la réservation"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
