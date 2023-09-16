import 'package:cloud_firestore/cloud_firestore.dart';

class GameModel {
  String uid; // ID de la personne qui a créé le jeu
  int initialAmount; // Montant initial pour participer au jeu
  int numberOfPart; // Nombre de participants
  int numberOfDice; // Nombre de dés
  int numberOfPlayers; // Nombre de joueurs
  List<String> participants; // Liste des participants (UID)
  DateTime created; // Date de création du jeu
  DateTime startedHour; // Heure de début du jeu
  bool closed; // Indique si le jeu est terminé
  int gain; // Gain calculé en fonction du nombre de participants et de la mise initiale

  GameModel({
    required this.uid,
    required this.initialAmount,
    required this.numberOfDice,
    required this.numberOfPlayers,
    required this.participants,
    required this.created,
    required this.startedHour,
    required this.numberOfPart,
    this.closed = false,
  }) : gain = initialAmount * numberOfPlayers; // Calcul du gain

  // Constructeur pour créer un nouveau jeu à partir des données du formulaire
  GameModel.createNewGame({
    required this.uid,
    required this.initialAmount,
    required this.numberOfDice,
    required this.numberOfPart,
    required this.numberOfPlayers,
    required this.startedHour,
  })  : participants = [uid],
        created = DateTime.now(),
        closed = false,
        gain = initialAmount * numberOfPlayers;

  // Conversion du modèle en Map pour l'ajout dans Firebase
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'initialAmount': initialAmount,
      'numberOfDice': numberOfDice,
      'numberOfPlayers': numberOfPlayers,
      'participants': participants,
      'created': created,
      'startedHour': startedHour,
      'closed': closed,
      'numberOfPart': numberOfPart,
      'gain': gain,
    };
  }

  // Constructeur à partir de Map pour récupérer depuis Firebase
  GameModel.fromMap(Map<String, dynamic> map)
      : uid = map['uid'],
        initialAmount = map['initialAmount'],
        numberOfDice = map['numberOfDice'],
        numberOfPlayers = map['numberOfPlayers'],
        participants = List<String>.from(map['participants']),
        created = (map['created'] as Timestamp).toDate(),
        startedHour = (map['startedHour'] as Timestamp).toDate(),
        closed = map['closed'],
        numberOfPart = map['numberOfPart'],
        gain = map['gain'];
}
