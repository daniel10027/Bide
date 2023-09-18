import 'package:bide/screens/main_home.dart';
import 'package:bide/utils/colors.dart';
import 'package:bide/utils/utils.dart';
import 'package:bide/widgets/custom_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddFundScreen extends StatefulWidget {
  @override
  State<AddFundScreen> createState() => _AddFundScreenState();
}

class _AddFundScreenState extends State<AddFundScreen> {
  final _amountController = TextEditingController();
  bool isLoading = false;
  String? errorText;

  @override
  void dispose() {
    super.dispose();
    _amountController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        title: Text('Rechargement'),
        backgroundColor: primaryColor, // Couleur de l'app bar
      ),
      body: Card(
        color: secondaryColor,
        margin: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Veuillez saisir le montant à recharger',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            isLoading
                ? Card(
                    color: secondaryColor,
                    margin: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: primaryColor,
                        )
                      ],
                    ),
                  )
                : Column(
                    children: [
                      TextFormField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Entrez le montant',
                          border: OutlineInputBorder(),
                          errorText: errorText,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Veuillez entrer un montant';
                          }
                          final amount = int.tryParse(value);
                          if (amount == null) {
                            return 'Montant invalide';
                          } else if (amount < 200 || amount > 1000000) {
                            return 'Montant hors limites';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.90,
                        child: CustomButton(
                          onPressed: () {
                            if (!isLoading) {
                              _handleValidation();
                            }
                          },
                          text: "Continuer",
                        ),
                      )
                    ],
                  )
          ],
        ),
      ),
    );
  }

  void _handleValidation() async {
    final inputAmount = _amountController.text.trim();

    if (inputAmount.isEmpty) {
      setState(() {
        errorText = 'Veuillez entrer un montant';
      });
      return;
    }

    final amount = int.tryParse(inputAmount);
    if (amount == null || amount < 200 || amount > 1000000) {
      setState(() {
        errorText = 'Montant invalide ou hors limites';
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorText = null;
    });

    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
    try {
      final connectedUserUid = _firebaseAuth.currentUser!.uid;
      final userDocument = await _firebaseFirestore
          .collection('users')
          .doc(connectedUserUid)
          .get();
      if (userDocument.exists) {
        // Ajouter la valeur de _amountController au champ AccountBalance du document
        await _firebaseFirestore
            .collection('users')
            .doc(connectedUserUid)
            .update({'AccountBalance': FieldValue.increment(amount)});
      }
    } catch (e) {
      showSnackBarWidget(context, '$e');
    }
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });

    // Rediriger vers la page d'accueil
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
      (route) => false,
    );
  }
}
