import 'dart:convert';
import 'dart:io';

import 'package:bide/model/user_model.dart';
import 'package:bide/screens/auths/opt_screen.dart';
import 'package:bide/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

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

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  AuthProvider() {
    checkSign();
  }

   void getCurrentUserUid() {
    if (_firebaseAuth.currentUser != null) {
      _uid = _firebaseAuth.currentUser?.uid;
      notifyListeners();
    }
  }

  void checkSign() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _isSignedIn = s.getBool("is_signedin") ?? false;
    notifyListeners();
  }

  Future setSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.setBool("is_signedin", true);
    _isSignedIn = true;
    notifyListeners();
  }

  void signInWithPhone(BuildContext context, String phoneNumber) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _firebaseAuth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted:
              (PhoneAuthCredential phoneAuthCredential) async {
            await _firebaseAuth.signInWithCredential(phoneAuthCredential);
          },
          verificationFailed: (error) {
            throw Exception(error.message);
          },
          codeSent: (verificationId, forceResendingToken) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtpScreen(
                    verificationId:
                        verificationId), // Remplacez WelcomeScreen() par le nom de votre classe WelcomeScreen
              ),
            );
            _isLoading = false;
            notifyListeners();
          },
          codeAutoRetrievalTimeout: ((verificationId) {}));
    } on FirebaseAuthException catch (e) {
      showSnackBarWidget(context, e.message.toString());
    }
    _isLoading = false;
    notifyListeners();
  }

  void verifyOtp(
      {required BuildContext context,
      required String verificationId,
      required String userOtp,
      required Function onSuccess}) async {
    _isLoading = true;
    notifyListeners();
    try {
      PhoneAuthCredential creds = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOtp);
      User? user = (await _firebaseAuth.signInWithCredential(creds)).user!;
      // ignore: unnecessary_null_comparison
      if (user != null) {
        _uid = user.uid;
        onSuccess();
      }

      _isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      showSnackBarWidget(context, e.message.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  // Operation sur la db
  Future<bool> checkExinstingUser() async {
    DocumentSnapshot snapshot =
        await _firebaseFirestore.collection("users").doc(_uid).get();
    if (snapshot.exists) {
      print(
          "******************************USER EXISTS***************************");
      return true;
    } else {
      print(
          "******************************NEW USER***************************");
      return false;
    }
  }

  void saveUserDataToFirebase({
    required BuildContext context,
    required UserModel userModel,
    // required File ProfilePic,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      // uploading image to firebase storage.
      // await storeFileToStorage("profilePic/$_uid", ProfilePic).then((value) {
      //   userModel.ProfilePic = value;
      //   userModel.createdAt = DateTime.now().millisecondsSinceEpoch.toString();
      //   userModel.phoneNumber = _firebaseAuth.currentUser!.phoneNumber!;
      //   userModel.uid = _firebaseAuth.currentUser!.phoneNumber!;
      // });
      
        userModel.ProfilePic = "";
        userModel.createdAt = DateTime.now().millisecondsSinceEpoch.toString();
        userModel.phoneNumber = _firebaseAuth.currentUser!.phoneNumber!;
        userModel.uid = _firebaseAuth.currentUser!.phoneNumber!;
  
      _userModel = userModel;

      // uploading to database
      await _firebaseFirestore
          .collection("users")
          .doc(_uid)
          .set(userModel.toMap())
          .then((value) {
        onSuccess();
        _isLoading = false;
        notifyListeners();
      });
    } on FirebaseAuthException catch (e) {
      showSnackBarWidget(context, e.message.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> storeFileToStorage(String ref, File file) async {
    UploadTask uploadTask = _firebaseStorage.ref().child(ref).putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future getDataFromFirestore() async {
  await _firebaseFirestore
      .collection("users")
      .doc(_firebaseAuth.currentUser!.uid)
      .get()
      .then((DocumentSnapshot snapshot) {
    print("AccountBalance from Firestore: ${snapshot['AccountBalance']}");
    _userModel = UserModel(
      name: snapshot['name'],
      email: snapshot['email'],
      createdAt: snapshot['createdAt'],
      bio: snapshot['bio'],
      uid: snapshot['uid'],
      ProfilePic: snapshot['profilePic'],
      phoneNumber: snapshot['phoneNumber'],
      AccountBalance: snapshot['AccountBalance'],
    );
    _uid = userModel.uid;
  });
}

  // STORING DATA LOCALLY
  Future saveUserDataToSP() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    await s.setString("user_model", jsonEncode(userModel.toMap()));
  }

  Future getDataFromSP() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    String data = s.getString("user_model") ?? '';
    if (data != null && data.isNotEmpty) {
      try {
        // Attempt to decode JSON data
        _userModel = UserModel.fromMap(jsonDecode(data));
      } catch (e) {
        // Handle JSON decoding error
        print("Error decoding JSON: $e");
      }
    } else {
      // Handle empty or null data
      print("JSON data is empty or null");
    }
if (_userModel != null) {
  _uid = _userModel!.uid;
  // Continue with other operations involving _userModel
} else {
  // Handle the case where _userModel is null
  print("_userModel is null");
}
    notifyListeners();
  }

  Future userSignOut() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    await _firebaseAuth.signOut();
    _isSignedIn = false;
    notifyListeners();
    s.clear();
  }

 Future<List<DocumentSnapshot>> getUserGames() async {
  try {
    final QuerySnapshot querySnapshot = await _firebaseFirestore
        .collection('games')
        .orderBy('created', descending: true) // Trie par date de création décroissante
        .get();

    return querySnapshot.docs;
  } catch (e) {
    print('Erreur lors de la récupération des jeux ouverts de l\'utilisateur : $e');
    return [];
  }
}

}
