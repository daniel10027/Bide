import 'package:bide/model/game_model.dart';
import 'package:bide/screens/games/game_details.dart';
import 'package:bide/utils/colors.dart';
import 'package:bide/screens/main_home.dart';
import 'package:bide/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewGameScreen extends StatefulWidget {
  @override
  _NewGameScreenState createState() => _NewGameScreenState();
}

class _NewGameScreenState extends State<NewGameScreen> {
  final _formKey = GlobalKey<FormState>();
  final _initialAmountController = TextEditingController();
  int _numberOfDice = 1;
  int _numberOfPlayers = 1;
  int _numberOfPart = 1;
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Créer un nouveau jeu'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _initialAmountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText:
                        'Montant initial (minimyun 100 Fracs / Maximun 1.000.000 Francs)',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un montant initial';
                    }
                    final amount = int.tryParse(value);
                    if (amount == null || amount < 100) {
                      return 'Le montant initial doit être d\'au moins 100';
                    }
                    if (amount > 1000000) {
                      return 'Le montant initial doit être d\'au plus 1.000.000';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                buildDropdown('Nombre de Tour', _numberOfPart, [1, 2, 3]),
                SizedBox(height: 20),
                buildDropdown('Nombre de dés', _numberOfDice, [1, 2]),
                SizedBox(height: 20),
                buildDropdown('Nombre de joueurs', _numberOfPlayers, [1, 2, 3, 4]),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _selectTime,
                  child: Row(
                    children: [
                      Text('Sélectionner l\'heure de début'),
                      SizedBox(width: 10),
                      Icon(
                        Icons.watch_later,
                        color: secondaryColor,
                      ),
                      SizedBox(width: 10),
                      Text(
                        '${_selectedTime.format(context)}',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
                ),
                SizedBox(height: 50),
                buildCreateGameButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDropdown(String label, int value, List<int> items) {
    return DropdownButtonFormField<int>(
      value: value,
      onChanged: (newValue) {
        setState(() {
          if (label == 'Nombre de Tour') {
            _numberOfPart = newValue!;
          } else if (label == 'Nombre de dés') {
            _numberOfDice = newValue!;
          } else if (label == 'Nombre de joueurs') {
            _numberOfPlayers = newValue!;
          }
        });
      },
      items: items.map<DropdownMenuItem<int>>((int itemValue) {
        return DropdownMenuItem<int>(
          value: itemValue,
          child: Text('$itemValue ${label == 'Nombre de Tour' ? 'Tour(s)' : label == 'Nombre de dés' ? 'dé(s)' : 'joueur(s)'}'),
        );
      }).toList(),
      decoration: InputDecoration(labelText: label),
    );
  }

  ElevatedButton buildCreateGameButton() {
    return ElevatedButton(
      onPressed: _createGame,
      child: isLoading
          ? CircularProgressIndicator(
              color: primaryColor,
            )
          : Text('Créer le jeu'),
      style: ElevatedButton.styleFrom(
        primary: primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
    );
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _createGame() async {
    if (_formKey.currentState!.validate() && !isLoading) {
      setState(() {
        isLoading = true;
      });

      final initialAmount = int.parse(_initialAmountController.text);
      User? user = FirebaseAuth.instance.currentUser;
      String userUid = user!.uid;
      final game = GameModel.createNewGame(
        uid: userUid,
        initialAmount: initialAmount,
        numberOfDice: _numberOfDice,
        numberOfPlayers: _numberOfPlayers,
        numberOfPart: _numberOfPart,
        startedHour: DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          _selectedTime.hour,
          _selectedTime.minute,
        ),
      );

      try {
        final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
        final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

        final connectedUserUid = _firebaseAuth.currentUser!.uid;
        final userDocument =
            await _firebaseFirestore.collection('users').doc(connectedUserUid).get();

        final userBalance = userDocument.data()?['AccountBalance'] ?? 0;

        if (userBalance >= initialAmount) {
          final newBalance = userBalance - initialAmount;
          await _firebaseFirestore
              .collection('users')
              .doc(connectedUserUid)
              .update({'AccountBalance': newBalance});

          DocumentReference gameRef = await FirebaseFirestore.instance
              .collection('games')
              .add(game.toMap());

          showSnackBarWidget(context, 'Solde Débité de ${initialAmount} Fcfa');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GameDetailScreen(
                gameRef: gameRef,
              ),
            ),
          );
        } else {
          showSnackBarWidget(context, 'Solde Insuffisant');
        }
      } catch (e) {
        showSnackBarWidget(context, e.toString());
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}
