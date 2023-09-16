

import 'package:bide/screens/games/game_details.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../utils/colors.dart';

 Widget SeachGameCard(BuildContext context,DocumentSnapshot game) {
  // Personnalisez la conception de la carte ici
  // Utilisez les données de game pour construire la carte
  DateTime createdTime = game['created'].toDate();
  String formattedDate =
      DateFormat('dd/MM/yyyy HH\'H\':mm').format(createdTime);

  DateTime startedHour = game['startedHour'].toDate();
  String formattedDatestartedHour =
      DateFormat('HH\'H\':mm').format(startedHour);

  return GestureDetector(
     onTap: () {
      // Navigate to the detail page here
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GameDetailScreen(
            gameRef: game.reference,
          ),
        ),
      );
    },
    child: Padding(
      // go to detail page of game
      // au clic rediriger sur la plage de detail qui contient avec te meme contentu de l'objet
      padding: const EdgeInsets.only(right: 5, left: 5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: EdgeInsets.all(12),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipRRect(
                  borderRadius: BorderRadius.circular(30), // Adjust the radius as needed
                  child: Container(
                    color: secondaryColor,
                    height: 60,
                    child: Image.asset(
                      "assets/images/logo/logo.png",
                      fit: BoxFit.contain, // You can adjust the fit as needed
                    ),
                  ),
                ),
                  SizedBox(width: 10,),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      child: Text(
                        'Gain Potentiel :  ${game['gain']} Fcfa',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      color: primaryColor,
                      padding: EdgeInsets.all(8),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}



 Widget GameCard(BuildContext context,DocumentSnapshot game) {
  // Personnalisez la conception de la carte ici
  // Utilisez les données de game pour construire la carte
  DateTime createdTime = game['created'].toDate();
  String formattedDate =
      DateFormat('dd/MM/yyyy HH\'H\':mm').format(createdTime);

  DateTime startedHour = game['startedHour'].toDate();
  String formattedDatestartedHour =
      DateFormat('HH\'H\':mm').format(startedHour);

  return GestureDetector(
     onTap: () {
      // Navigate to the detail page here
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GameDetailScreen(
            gameRef: game.reference,
          ),
        ),
      );
    },
    child: Padding(
      // go to detail page of game
      // au clic rediriger sur la plage de detail qui contient avec te meme contentu de l'objet
      padding: const EdgeInsets.only(left: 25.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: EdgeInsets.all(12),
          color: primaryColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipRRect(
                  borderRadius: BorderRadius.circular(30), // Adjust the radius as needed
                  child: Container(
                    color: secondaryColor,
                    height: 60,
                    child: Image.asset(
                      "assets/images/logo/logo.png",
                      fit: BoxFit.contain, // You can adjust the fit as needed
                    ),
                  ),
                ),
                  SizedBox(width: 10,),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      child: Text(
                        'Gain Potentiel :  ${game['gain']} Fcfa',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      color: Colors.black,
                      padding: EdgeInsets.all(8),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.money,color: secondaryColor,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text('Nombre de Dés:  ${game['numberOfDice']}',  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.gamepad, color: secondaryColor,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text('Nombre de Tours:  ${game['numberOfPart']}',  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.group,color: secondaryColor,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text('Nombre de Joueurs:  ${game['numberOfPlayers']}',  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.money,color: secondaryColor,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text('Créé le:  ${formattedDate}',  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.watch_later,color: secondaryColor,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text('Débute à  :  ${formattedDatestartedHour}',  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}


Widget UserGameCard(BuildContext context, DocumentSnapshot game) {
  // Personnalisez la conception de la carte ici
  // Utilisez les données de game pour construire la carte
  DateTime createdTime = game['created'].toDate();
  String formattedDate = DateFormat('dd/MM/yyyy HH\'H\':mm').format(createdTime);

  DateTime startedHour = game['startedHour'].toDate();
  String formattedDatestartedHour =
      DateFormat('HH\'H\':mm').format(startedHour);

  return GestureDetector(
     onTap: () {
      // Navigate to the detail page here
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GameDetailScreen(
            gameRef: game.reference,
          ),
        ),
      );
    },
    child: Padding(
      // go to detail page of game
      // au clic rediriger sur la plage de detail qui contient avec te meme contentu de l'objet
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: primaryColor,
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                height: 50,
                padding: EdgeInsets.all(12.0),
                color: secondaryColor,
                child: Image.asset("assets/images/de/white_6.jpeg"),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.money, 
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Gain :  ${game['gain']} Fcfa',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.watch_later,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text('${formattedDatestartedHour}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                  ],
                ),
              ],
            ),
              ],
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                padding: EdgeInsets.all(5),
                color: secondaryColor,
                child: Row(
                  children: [
                    Text('${game['numberOfPlayers']}', style: TextStyle(fontWeight: FontWeight.bold, color:primaryColor),),
                    Icon(
                      Icons.group,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}