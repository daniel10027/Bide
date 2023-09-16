import 'package:bide/provider/auth_provider.dart';
import 'package:bide/widgets/card.dart';
import 'package:bide/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class GameScreeenFirst extends StatefulWidget {
  const GameScreeenFirst({Key? key}) : super(key: key);

  @override
  State<GameScreeenFirst> createState() => _GameScreeenFirstState();
}

class _GameScreeenFirstState extends State<GameScreeenFirst> {
  List<DocumentSnapshot> otherUserGames = [];
  List<DocumentSnapshot> UserGames = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();
  List<DocumentSnapshot> searchResults = [];
  bool isSearching = false; // Variable pour suivre l'état de la recherche

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.getUserGames().then((games) {
      setState(() {
        otherUserGames = games.where((game) {
          final closed = game['closed'] ??
              false; // Assurez-vous d'ajuster la clé en fonction de votre modèle de données
          return !closed; // On sélectionne les jeux où closed est false
        }).toList();

        final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
        final connectedUserUid = _firebaseAuth
            .currentUser!.uid; // Utilisez la propriété uid du Provider
        UserGames = otherUserGames.where((game) {
          final gameUid = game[
              'uid']; // Assurez-vous d'ajuster la clé en fonction de votre modèle de données
          return gameUid == connectedUserUid;
        }).toList();
        isLoading = false;
      });
    });
  }

  void searchGameById(String gameId) {
    setState(() {
      searchResults.clear();
      isSearching = true; // L'utilisateur commence à rechercher
    });

    if (gameId.isEmpty) {
      setState(() {
        isSearching = false; // L'utilisateur a terminé la recherche
      });
      return;
    }

    final firestore = FirebaseFirestore.instance;

    firestore
        .collection("games")
        .doc(gameId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        // Le document existe, ajoutez-le aux résultats de la recherche
        setState(() {
          searchResults.add(documentSnapshot);
          isSearching = false; // La recherche est terminée
        });
      } else {
        // Le document n'existe pas
        setState(() {
          isSearching = false; // La recherche est terminée
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Container(
                            height: 30,
                            child: InkWell(
                              child: Icon(
                                Icons.search,
                                size: 40,
                                color: primaryColor,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            onChanged: (gameId) {
                              searchGameById(gameId);
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Rechercher une partie par ID',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  height: 25,
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          // Affichez le CircularProgressIndicator si l'utilisateur est en train de rechercher
          isSearching
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Center(
                    child: CircularProgressIndicator(color: primaryColor),
                  ),
                )
              : Container(
                  // ignore: unnecessary_null_comparison
                  height: searchResults.length > 0
                      ? 90
                      : searchController.text.isNotEmpty
                          ? 20
                          : 0,
                  child: searchResults.isNotEmpty
                      ? Center(
                          child: ListView.builder(
                            itemCount: searchResults.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, int index) {
                              return SeachGameCard(context,
                                  searchResults[index] as DocumentSnapshot);
                            },
                          ),
                        )
                      : Center(
                          child: searchController.text.isNotEmpty
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.hourglass_empty_rounded,
                                      color: primaryColor,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Aucun jeu trouvé",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Color.fromARGB(255, 91, 82, 20),
                                      ),
                                    ),
                                  ],
                                )
                              : SizedBox(),
                        ),
                ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: Text(
              "Jeux actuellement disponibles",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color.fromARGB(255, 91, 82, 20),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 220,
            child: isLoading
                ? Center(child: CircularProgressIndicator(color: primaryColor))
                : ListView.builder(
                    itemCount: otherUserGames.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, int index) {
                      return GameCard(context, otherUserGames[index]);
                    },
                  ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Text(
                "Mes Jeux",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color.fromARGB(255, 91, 82, 20),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 10,
            child: isLoading
                ? Center(child: CircularProgressIndicator(color: primaryColor))
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: ListView.builder(
                      itemCount: UserGames.length,
                      itemBuilder: (context, int index) {
                        return UserGameCard(context, UserGames[index]);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
