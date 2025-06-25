import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    setState(() {
      _isLoggedIn = token != null;
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            _buildMenuItem('Contact', context),
            _buildMenuItem('Réservation', context),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: _isLoggedIn
                    ? [
                        _buildMenuButton('Profil', context),
                        const SizedBox(height: 12),
                        _buildMenuButton('Se déconnecter', context,
                            isLogout: true),
                      ]
                    : [
                        _buildAuthButton('Se connecter', context,
                            isOutlined: true),
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
          if (text == 'Se connecter') {
            Navigator.pushNamed(context, '/login');
          } else if (text == "S'inscrire") {
            Navigator.pushNamed(context, '/register');
          }
        },
        style: TextButton.styleFrom(
          backgroundColor: isOutlined ? Colors.white : const Color(0xFFDC320F),
          side: BorderSide(color: const Color(0xFFDC320F), width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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

  Widget _buildMenuButton(String text, BuildContext context,
      {bool isLogout = false}) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: TextButton(
        onPressed:
            isLogout ? _logout : () => Navigator.pushNamed(context, '/profile'),
        style: TextButton.styleFrom(
          backgroundColor: isLogout ? Colors.white : const Color(0xFFDC320F),
          side: BorderSide(color: const Color(0xFFDC320F), width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            color: isLogout ? const Color(0xFFDC320F) : Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
