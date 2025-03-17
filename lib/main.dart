import 'package:flutter/material.dart';
import 'Pages/home.dart'; // Importation de la page Home
import 'Pages/contact.dart'; // Importation de la page Contact
import 'Pages/login.dart'; // Importation de la page Login
import 'Pages/register.dart'; // Importation de la page Register
import 'Pages/reservation.dart';
import 'Pages/reserver.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Votre Application', // Le titre de l'application
      theme: ThemeData(
        primarySwatch:
            Colors.blue, // Vous pouvez ajuster la couleur principale ici
        fontFamily:
            'Poppins', // Définissez la police globale si vous le souhaitez
      ),
      initialRoute: '/', // Définir la route initiale
      routes: {
        '/': (context) => HomePage(), // Page d'accueil
        '/contact': (context) => ContactPage(), // Page Contact
        '/login': (context) => LoginPage(), // Page Login
        '/home': (context) => const HomePage(), // Accueil après connexion
        '/register': (context) => RegisterPage(), // Page Register
        '/reservation': (context) => ReservationsPage(),
        '/reserve': (context) => ReservePage(),
      },
    );
  }
}
