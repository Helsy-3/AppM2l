import 'package:flutter/material.dart';

class ReservationsPage extends StatelessWidget {
  const ReservationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Réservations M2L'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildReservationCard(
              title: 'Location de Matériel',
              price: 75.00,
              imagePath: 'assets/images/materiel_location.jpg',
              routeName: '/reserve',
              spaceId: 4,
              context: context,
            ),
            _buildReservationCard(
              title: 'Salle de Sport',
              price: 50.00,
              imagePath: 'assets/images/salle_sport.jpg',
              routeName: '/reserve',
              spaceId: 1,
              context: context,
            ),
            _buildReservationCard(
              title: 'Terrain Extérieur',
              price: 30.00,
              imagePath: 'assets/images/terrain_exterieur.jpg',
              routeName: '/reserve',
              spaceId: 3,
              context: context,
            ),
            _buildReservationCard(
              title: 'Salle de Conférence',
              price: 100.00,
              imagePath: 'assets/images/salle_conference.jpeg',
              routeName: '/reserve',
              spaceId: 2,
              context: context,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReservationCard({
    required String title,
    required double price,
    required String imagePath,
    required String routeName,
    required int spaceId,
    required BuildContext context,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            child: Image.asset(
              imagePath,
              width: double.infinity,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'Prix par jour : \$${price.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      routeName,
                      arguments: {'space_id': spaceId, 'price': price},
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                  ),
                  child: const Text(
                    'Réserver',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
