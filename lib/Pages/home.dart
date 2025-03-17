import 'package:flutter/material.dart';
import '../Widgets/footer.dart'; // Importation du footer
import '../Widgets/header.dart'; // Importation du header
import '../Widgets/menu.dart'; // Importation du menu
import 'package:google_fonts/google_fonts.dart'; // Police de Google

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isMenuOpen = false;
  final Color redColor = const Color(0xFFDC320F);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(), // Utilise le Header
          if (_isMenuOpen)
            _buildMenu() // Menu ouvert
          else
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.asset(
                                'assets/images/menu.png',
                                width: double.infinity,
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          // Section "À propos"
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "À propos",
                                  style: GoogleFonts.poppins(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "A propos\n\n"
                                  "Vous pourrez ici suivre toute l'actualité sportive locale, à la manière des grands journaux.\n\n"
                                  "Mais vous pourrez aussi réserver des compétitions et les complexes pour les accueillir. Nous sommes reconnus pour la qualité de nos produits et services, ainsi que pour notre expertise pointue dans notre domaine. "
                                  "Notre équipe de professionnels passionnés travaille sans relâche pour vous offrir des solutions sur-mesure qui répondent parfaitement à vos objectifs. "
                                  "N'hésitez pas à me poser toutes vos questions, je serai ravi d'y répondre en détail et de vous guider tout au long de notre collaboration. "
                                  "Je suis convaincu que nous pourrons trouver la solution idéale pour vous.\n\n"
                                  "La M2L héberge une multitude de ligues :\n"
                                  "- Ligue de Plongée\n"
                                  "- Ligue de Tennis\n"
                                  "- Ligue de Football\n"
                                  "- Ligue de Bowling\n"
                                  "- Ligue de tennis de table",
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  _buildFooter(), // Utilise le Footer
                ],
              ),
            ),
        ],
      ),
    );
  }

  // Fonction pour afficher le header
  Widget _buildHeader() {
    return Header(
      isMenuOpen: _isMenuOpen,
      onMenuToggle: () {
        setState(() {
          _isMenuOpen = !_isMenuOpen;
        });
      },
    );
  }

  // Fonction pour afficher le menu
  Widget _buildMenu() {
    return Menu();
  }

  // Fonction pour afficher le footer
  Widget _buildFooter() {
    return Footer();
  }
}
