import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            _buildMenuItem('Contact', context),
            _buildMenuItem(
                'Réservation', context), // Ajout de l'élément Réservation
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildAuthButton('Se connecter', context, isOutlined: true),
                  const SizedBox(height: 12),
                  _buildAuthButton("S'inscrire", context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(String text, BuildContext context) {
    return InkWell(
      onTap: () {
        // Correction des comparaisons
        if (text == 'Contact') {
          Navigator.pushNamed(context, '/contact');
        } else if (text == 'Réservation') {
          Navigator.pushNamed(context, '/reservation');
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              // ignore: deprecated_member_use
              color: const Color(0xFFDC320F).withOpacity(0.1),
            ),
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildAuthButton(String text, BuildContext context,
      {bool isOutlined = false}) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: TextButton(
        onPressed: () {
          // Redirection selon le texte du bouton
          if (text == 'Se connecter') {
            Navigator.pushNamed(context, '/login');
          } else if (text == "S'inscrire") {
            Navigator.pushNamed(context, '/register');
          }
        },
        style: TextButton.styleFrom(
          backgroundColor: isOutlined ? Colors.white : const Color(0xFFDC320F),
          side: BorderSide(color: const Color(0xFFDC320F), width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            color: isOutlined ? const Color(0xFFDC320F) : Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
