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
  final DocumentReference gameRef;

  const GameDetailScreen({Key? key, required this.gameRef}) : super(key: key);

  @override
  State<GameDetailScreen> createState() => _GameDetailScreenState();
}

class _GameDetailScreenState extends State<GameDetailScreen> {
  late Stream<DocumentSnapshot> gameStream;
  int currentParticipants = 0;
  List<String> participants =
      []; // Variable pour suivre le nombre de participants actuels

  @override
  void initState() {
    super.initState();
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
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final connectedUserUid = _firebaseAuth.currentUser!.uid;

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

        final gameData = snapshot.data!.data() as Map<String, dynamic>;
        participants = List<String>.from(gameData['participants'] ?? []);

        DateTime createdTime = (gameData['created'] as Timestamp).toDate();
        String formattedDate =
            DateFormat('dd/MM/yyyy HH\'H\':mm').format(createdTime);
        DateTime startedHour = (gameData['startedHour'] as Timestamp).toDate();
        DateTime gameStartTime = startedHour;
        DateTime now = DateTime.now();
        int endTime = gameStartTime.isBefore(now)
            ? now.millisecondsSinceEpoch
            : gameStartTime.millisecondsSinceEpoch;

        final numberOfPlayers = gameData['numberOfPlayers'];

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
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.check,
                                color: secondaryColor,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Participants inscrit : ${currentParticipants}/$numberOfPlayers ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
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
                          ? participants.contains(connectedUserUid)
                              ? ElevatedButton(
                                  onPressed: () {
                                    // Action à effectuer lorsque l'utilisateur est déjà inscrit
                                    // Mettez ici l'action que vous souhaitez exécuter.
                                  },
                                  style: ButtonStyle(
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                      Colors.white,
                                    ),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                      Colors
                                          .green, // Couleur pour "Commer à jouer"
                                    ),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    "Commer à jouer",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                )
                              : SizedBox() // Si l'utilisateur actuel a créé le jeu, ne rien afficher
                          : currentParticipants < numberOfPlayers
                              ? ElevatedButton(
                                  onPressed: () {
                                    _joinGame(gameData, numberOfPlayers);
                                  },
                                  style: ButtonStyle(
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                      Colors.white,
                                    ),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                      primaryColor, // Couleur pour "Rejoindre le Jeu"
                                    ),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    "Rejoindre le Jeu",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                )
                              : SizedBox(), // Si le nombre de participants est atteint, ne rien afficher
                    ),
                    SizedBox(
                      width: 20,
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

  void _showDeleteGameConfirmationDialog(
      BuildContext context, int initialAmount, gameData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Confirmation de suppression",
            style: TextStyle(color: primaryColor),
          ),
          content: Text(
              "En supprimant le jeu, vous perdrez $initialAmount Fcfa. Voulez-vous continuer ?"),
          actions: <Widget>[
            TextButton(
              child: Text(
                "Annuler",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Ferme le dialogue
              },
            ),
            SizedBox(
              width: 30,
            ),
            TextButton(
              child: Text(
                "Continuer",
                style:
                    TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                _deleteGame(gameData);
                Navigator.of(context).pop(); // Ferme le dialogue
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteGame(gameData) async {
    final gameUid = gameData['uid'];
    final gameId = widget.gameRef.id;
    final participants = List<String>.from(gameData['participants'] ?? []);
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final connectedUserUid = _firebaseAuth.currentUser!.uid;
    final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

    if (connectedUserUid == gameUid) {
      if (participants.length == 1) {
        try {
          // Supprimer le jeu de la collection "games" en utilisant son ID
          await _firebaseFirestore.collection('games').doc(gameId).delete();
          print('Jeu supprimé avec succès.');
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

  void _joinGame(gameData, int numberOfPlayers) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

    try {
      final gameDocument = await widget.gameRef.get();
      if (gameDocument.exists) {
        final participants = List<String>.from(gameData['participants'] ?? []);
        final connectedUserUid = _firebaseAuth.currentUser!.uid;

        // Obtenez la valeur actuelle de userBalance depuis Firebase
        final userDocument = await _firebaseFirestore
            .collection('users')
            .doc(connectedUserUid)
            .get();

        if (userDocument.exists) {
          final userBalance = userDocument.data()?['AccountBalance'] ?? 0;
          final initialAmount = gameData['initialAmount'] ?? 0;

          if (userBalance >= initialAmount) {
            if (participants.length < numberOfPlayers) {
              // Déduisez initialAmount du solde de l'utilisateur dans Firebase
              final newBalance = userBalance - initialAmount;
              await _firebaseFirestore
                  .collection('users')
                  .doc(connectedUserUid)
                  .update({'AccountBalance': newBalance});

              if (!participants.contains(connectedUserUid)) {
                participants.add(connectedUserUid);

                // Mettez à jour le document de jeu avec la nouvelle liste de participants
                await widget.gameRef.update({
                  'participants': participants,
                });

                _VerifyAndupdateParticipantsList(participants);

                // Mettez à jour la variable currentParticipants
                setState(() {
                  currentParticipants = participants.length;
                });

                showSnackBarWidget(context, 'Vous avez rejoint ce Jeu');
              } else {
                showSnackBarWidget(context, 'Vous avez déjà rejoint ce Jeu');
              }
            } else {
              showSnackBarWidget(context, 'Nombre de participants atteint');
            }
          } else {
            showSnackBarWidget(context, 'Votre solde est insuffisant');
          }
        }
      }
    } catch (e) {
      showSnackBarWidget(
          context, 'Erreur lors de la tentative de rejoindre le jeu : $e');
    }
  }

  void _VerifyAndupdateParticipantsList(List<String> participants) async {
    try {
      await FirebaseFirestore.instance
          .collection('games')
          .doc(widget.gameRef.id) // Utilisez le document du jeu actuel
          .update({
        'participants': participants,
      });
      print('Liste des participants mise à jour avec succès.');
    } catch (e) {
      print('Erreur lors de la mise à jour de la liste des participants : $e');
    }
  }
}
