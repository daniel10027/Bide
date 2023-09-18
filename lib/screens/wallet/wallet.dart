import 'package:bide/provider/auth_provider.dart';
import 'package:bide/screens/wallet/add_fund.dart';
import 'package:bide/screens/wallet/add_money.dart';
import 'package:bide/utils/colors.dart';
import 'package:bide/utils/utils.dart';
import 'package:bide/widgets/custom_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class WalletScreen extends StatefulWidget {
  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  int userBalance = 0; // Déclarer userBalance
  String name = ""; // Déclarer name

  @override
  void initState() {
    super.initState();
    _GetBalance(); // Appeler la méthode pour obtenir les données depuis Firebase
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        title: Text('Portefeuille'),
        backgroundColor: primaryColor, // Couleur de l'app bar
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            FutureBuilder(
              future: ap.getDataFromSP(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 1),
                              ),
                            ],
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          width: MediaQuery.of(context).size.width * .9,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Image.asset(
                                    "assets/images/logo/logo.png",
                                    height: 70,
                                    color: Colors.orangeAccent,
                                  ),
                                  Text(
                                    "Bide Bank",
                                    style: GoogleFonts.roboto(
                                        fontSize: 20, color: secondaryColor),
                                  ),
                                ],
                              ),
                              Divider(
                                color: secondaryColor, // Couleur de la ligne
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Solde : ",
                                    style: GoogleFonts.roboto(
                                        fontSize: 24, color: secondaryColor),
                                  ),
                                  Text(
                                    "$userBalance Fcfa", // Utilisez la valeur de userBalance ici
                                    style: GoogleFonts.roboto(
                                        fontSize: 24, color: secondaryColor),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "CARD HOLDER",
                                    style: GoogleFonts.roboto(
                                        fontSize: 12, color: secondaryColor),
                                  ),
                                  Text(
                                    "VALIDE TO ",
                                    style: GoogleFonts.roboto(
                                        fontSize: 12, color: secondaryColor),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "$name", // Utilisez la valeur de name ici
                                    style: GoogleFonts.roboto(
                                        fontSize: 18, color: secondaryColor),
                                  ),
                                  Text(
                                    "08/2030",
                                    style: GoogleFonts.roboto(
                                        fontSize: 18, color: secondaryColor),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        SizedBox(
                          height: 50,
                          width: MediaQuery.of(context).size.width * 0.90,
                          child: CustomButton(
                            text: "Recharger",
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AddMoney(), // Remplacez AddFundScreen() par le nom de votre classe AddFundScreen
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }

  void _GetBalance() async {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  try {
    final connectedUserUid = _firebaseAuth.currentUser!.uid;
    final userDocument =
        await _firebaseFirestore.collection('users').doc(connectedUserUid).get();
    if (userDocument.exists) {
      setState(() {
        userBalance = (userDocument.data()?['AccountBalance'] ?? 0);
        name = userDocument.data()?['name'] ?? '.../';
      });
    } else {
      setState(() {
        userBalance = 0; // Définir userBalance comme double
        name = ".../";
      });
    }
  } catch (e) {
    showSnackBarWidget(context, 'Erreur lors de la tentative de rejoindre le jeu : $e');
  }
}
}
