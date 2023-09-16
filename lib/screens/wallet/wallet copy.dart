  import 'package:bide/model/user_model.dart';
  import 'package:bide/provider/auth_provider.dart';
  import 'package:bide/screens/wallet/add_fund.dart';
  import 'package:bide/utils/colors.dart';
  import 'package:bide/widgets/custom_button.dart';
  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:firebase_storage/firebase_storage.dart';
  import 'package:flutter/material.dart';
  import 'package:google_fonts/google_fonts.dart';
  import 'package:provider/provider.dart';

  class WalletScreen extends StatefulWidget {
    @override
    State<WalletScreen> createState() => _WalletScreenState();
  }

  class _WalletScreenState extends State<WalletScreen> {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
    final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

    String? _uid;
    String get uid => _uid!;

    UserModel? _userModel;
    UserModel get userModel =>
        _userModel ??
        UserModel(
            name: "",
            email: "",
            bio: "",
            ProfilePic: "",
            createdAt: "",
            phoneNumber: "",
            uid: "",
            AccountBalance: 0);

    Future getDataFromFirestore() async {
      await _firebaseFirestore
          .collection("users")
          .doc(_firebaseAuth.currentUser!.uid)
          .get()
          .then((DocumentSnapshot snapshot) {
        _userModel = UserModel(
          name: snapshot['name'],
          email: snapshot['email'],
          createdAt: snapshot['createdAt'],
          bio: snapshot['bio'],
          uid: snapshot['uid'],
          ProfilePic: '',
          phoneNumber: snapshot['phoneNumber'],
          AccountBalance: snapshot['AccountBalance'],
        );
        _uid = userModel.uid;
      });
    }

    @override
    void initState() {
      super.initState();
      final ap = Provider.of<AuthProvider>(context, listen: false);
      getDataFromFirestore(); // Appel de la fonction pour récupérer les données
      ap.getDataFromSP();
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
                                color: Colors.black,
                                boxShadow: [
                                  BoxShadow(
                                      color: primaryColor.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(0, 1)),
                                ],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
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
                                        color: primaryColor,
                                      ),
                                      Text(
                                        "Bide Bank",
                                        style: GoogleFonts.roboto(
                                            fontSize: 20, color: primaryColor),
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
                                            fontSize: 24, color: primaryColor),
                                      ),
                                      Text(
                                        // Utilisez la valeur récupérée
                                        "${userModel.AccountBalance.toString()}",
                                        style: GoogleFonts.roboto(
                                            fontSize: 24, color: primaryColor),
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
                                        "${ap.userModel.name.toUpperCase()}",
                                        style: GoogleFonts.roboto(
                                            fontSize: 18, color: primaryColor),
                                      ),
                                      Text(
                                        "08/2030",
                                        style: GoogleFonts.roboto(
                                            fontSize: 18, color: primaryColor),
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
                                        AddFundScreen(), // Remplacez WelcomeScreen() par le nom de votre classe WelcomeScreen
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    }
                  })
            ],
          ),
        ),
      );
    }
  }
