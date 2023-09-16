import 'package:bide/utils/colors.dart';
import 'package:bide/screens/main_home.dart';
import 'package:bide/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';

class GameDetailScreen extends StatefulWidget {
  final DocumentReference
      gameRef; // Utilisez une référence au jeu au lieu du snapshot

  const GameDetailScreen({Key? key, required this.gameRef}) : super(key: key);

  @override
  State<GameDetailScreen> createState() => _GameDetailScreenState();
}

class _GameDetailScreenState extends State<GameDetailScreen> {
  // Utilisez un Stream pour surveiller les changements du jeu
  late Stream<DocumentSnapshot> gameStream;

  @override
  void initState() {
    super.initState();
    // Initialisez le Stream avec la référence au jeu
    gameStream = widget.gameRef.snapshots();
  }

  void _copyGameID(BuildContext context) {
    Clipboard.setData(ClipboardData(text: widget.gameRef.id));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Code du jeu copié'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Utilisez un StreamBuilder pour afficher les données du jeu en temps réel
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final connectedUserUid =
        _firebaseAuth.currentUser!.uid; // Utilisez la propriété uid du Provider
    return StreamBuilder<DocumentSnapshot>(
      stream: gameStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: primaryColor,
              title: Text('Détails du Jeu'),
            ),
            body: Center(
              child: Text('Erreur: ${snapshot.error}'),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: primaryColor,
            ),
            body: Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          // Les données du jeu n'existent pas, affichez un message approprié ou effectuez une autre action
          return Scaffold(
            appBar: AppBar(
              backgroundColor: primaryColor,
              title: Text('Détails du Jeu'),
            ),
            body: Center(
              child: Text('Le jeu n\'existe pas.'),
            ),
          );
        }

        // Récupérez les données du jeu à partir du snaps

        final gameData = snapshot.data!.data() as Map<String, dynamic>;

        DateTime createdTime = (gameData['created'] as Timestamp).toDate();
        String formattedDate =
            DateFormat('dd/MM/yyyy HH\'H\':mm').format(createdTime);
        DateTime startedHour = (gameData['startedHour'] as Timestamp).toDate();
        DateTime gameStartTime = startedHour;
        DateTime now = DateTime.now();
        int endTime = gameStartTime.isBefore(now)
            ? now.millisecondsSinceEpoch
            : gameStartTime.millisecondsSinceEpoch;

        return Scaffold(
          backgroundColor: secondaryColor,
          appBar: AppBar(
            backgroundColor: primaryColor,
            actions: [
              IconButton(
                icon: Icon(Icons.copy),
                onPressed: () {
                  _copyGameID(context);
                },
              ),
            ],
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
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
                                borderRadius: BorderRadius.circular(30),
                                child: Container(
                                  color: secondaryColor,
                                  height: 60,
                                  child: Image.asset(
                                    "assets/images/logo/logo.png",
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  child: Text(
                                    'Gain Potentiel :  ${gameData['gain']} Fcfa',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  color: Colors.black,
                                  padding: EdgeInsets.all(8),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.money,
                                color: secondaryColor,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Nombre de Dés:  ${gameData['numberOfDice']}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.gamepad,
                                color: secondaryColor,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Nombre de Tours:  ${gameData['numberOfPart']}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.group,
                                color: secondaryColor,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Nombre de Joueurs:  ${gameData['numberOfPlayers']}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.money,
                                color: secondaryColor,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Créé le:  ${formattedDate}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.watch_later,
                                color: secondaryColor,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Débute dans  ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  CountdownTimer(
                                    endTime: endTime,
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    onEnd: () {
                                      // Handle the timer completion event
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50,
                      child: connectedUserUid == gameData['uid']
                          ? ElevatedButton(
                              onPressed: () {
                                _deleteGame(gameData);
                              },
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  connectedUserUid == gameData['uid']
                                      ? const Color.fromARGB(255, 91, 13, 8)
                                      : Colors.grey,
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                ),
                              ),
                              child: Text(
                                "Supprimer le Jeu",
                                style: const TextStyle(fontSize: 16),
                              ),
                            )
                          : SizedBox(),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          showSnackBarWidget(
                            context,
                            "Votre Solde est insuffisant, merci de recharger votre compte.",
                          );
                        },
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(primaryColor),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                          ),
                        ),
                        child: Text(
                          "Rejoindre le Jeu",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _deleteGame(gameData) async {
    final gameUid = gameData['uid'];
    final gameId = widget.gameRef.id;
    final participants = List<String>.from(gameData['participants'] ?? []);
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final connectedUserUid =
        _firebaseAuth.currentUser!.uid; // Utilisez la propriété uid du Provider
    final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

    if (connectedUserUid == gameUid) {
      if (participants.length == 1) {
        try {
          // Supprimer le jeu de la collection "games" en utilisant son ID
           await _firebaseFirestore.collection('games').doc(gameId).update({
          'closed': true,
        });
          print('Jeu fermé avec succès.');
        } catch (e) {
          showSnackBarWidget(context, e.toString());
          // Vous pouvez gérer l'erreur ici en affichant un message d'erreur ou en lançant une exception.
        }
         Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      } else {
        // Il y a déjà d'autres participants
        showSnackBarWidget(context,
            "Suppression impossible, d'autres joueurs ont rejoint la partie");
      }
    }
  }
}
