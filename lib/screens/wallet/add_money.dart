import 'package:bide/utils/colors.dart';
import 'package:flutter/material.dart';

class AddMoney extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        title: Text('Portefeuille'),
        backgroundColor: primaryColor, // Couleur de l'app bar
      ),
      body: Card(
        color: secondaryColor,        margin: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Veuillez sélectionner un opérateur',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            Column(
              children: [
                _buildListItem(
                  imageUrl: 'assets/images/logo/paye/wave.jpeg',
                  title: 'Wave',
                  subtitle: 'Rechargement via Wave',
                  onTap: () {
                    // Navigate to another page
                  },
                ),
                _buildListItem(
                  imageUrl: 'assets/images/logo/paye/orange.jpeg',
                  title: 'Orange',
                  subtitle: 'Rechargement via Orange',
                  onTap: () {
                    // Navigate to another page
                  },
                ),
                _buildListItem(
                  imageUrl: 'assets/images/logo/paye/moov.jpeg',
                  title: 'Moov',
                  subtitle: 'Rechargement via Moov',
                  onTap: () {
                    // Navigate to another page
                  },
                ),
                _buildListItem(
                  imageUrl: 'assets/images/logo/paye/mtn.jpeg',
                  title: 'Mtn',
                  subtitle: 'Rechargement via Mtn',
                  onTap: () {
                    // Navigate to another page
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildListItem({
    required String imageUrl,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: primaryColor),
        ),
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(imageUrl),
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(subtitle),
              ],
            ),
            Spacer(),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor,
                border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
              ),
              child: IconButton(
                onPressed: onTap,
                icon: Icon(Icons.arrow_forward, color: secondaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}