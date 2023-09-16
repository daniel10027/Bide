import 'package:bide/model/game_model.dart';
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
  TextEditingController _initialAmountController = TextEditingController();
  int _numberOfDice = 1;
  int _numberOfPlayers = 1;
  int _numberOfPart = 1;
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool isLoading = false; // Variable pour gérer l'indicateur de progression

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
                  decoration:
                      InputDecoration(labelText: 'Montant initial (minimyun 100 Fracs / Maximun 1.000.000 Francs)'),
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
                SizedBox(height: 20,),
                DropdownButtonFormField<int>(
                  value: _numberOfDice,
                  onChanged: (value) {
                    setState(() {
                      _numberOfPart = value!;
                    });
                  },
                  items: [1, 2,3].map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text('$value Tour(s)'),
                    );
                  }).toList(),
                  decoration: InputDecoration(labelText: 'Nombre de Tour'),
                ),
                 SizedBox(height: 20,),
                DropdownButtonFormField<int>(
                  value: _numberOfDice,
                  onChanged: (value) {
                    setState(() {
                      _numberOfDice = value!;
                    });
                  },
                  items: [1, 2].map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text('$value dé(s)'),
                    );
                  }).toList(),
                  decoration: InputDecoration(labelText: 'Nombre de dés'),
                ),
                 SizedBox(height: 20,),
                DropdownButtonFormField<int>(
                  value: _numberOfPlayers,
                  onChanged: (value) {
                    setState(() {
                      _numberOfPlayers = value!;
                    });
                  },
                  items: [1, 2, 3,4].map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text('$value joueur(s)'),
                    );
                  }).toList(),
                  decoration: InputDecoration(labelText: 'Nombre de joueurs'),
                ),
                 SizedBox(height: 20,),
                ElevatedButton(
                  onPressed: _selectTime,
                  child: Row(
                    children: [
                      Text('Sélectionner l\'heure de début'),
                      SizedBox(width: 10,),
                      Icon(Icons.watch_later, color: secondaryColor,),
                       SizedBox(width: 10,),
                      Text(
                      '${_selectedTime.format(context)}',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    ],
                  ),
                   style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(primaryColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0))),
                  ),
                ),
                
               
                SizedBox(height: 50),
                Center(
                  child: AbsorbPointer(
                    absorbing: isLoading, // Désactivez les interactions si isLoading est vrai
                    child: ElevatedButton(
                      onPressed: _createGame,
                      child: isLoading
                          ? CircularProgressIndicator(color: primaryColor,) // Indicateur de progression pendant le chargement
                          : Text('Créer le jeu'),
                       style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(primaryColor),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0))),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
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
        DocumentReference gameRef = await FirebaseFirestore.instance
            .collection('games')
            .add(game.toMap());

        String gameId = gameRef.id;
        print(gameId);

        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ));
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
