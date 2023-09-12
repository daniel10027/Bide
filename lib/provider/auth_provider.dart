import 'package:bide/screens/opt_screen.dart';
import 'package:bide/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;

   bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _uid;
  String get uid => _uid!;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFireStore = FirebaseFirestore.instance;

  AuthProvider() {
    checkSign();
  }

  void checkSign() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _isSignedIn = s.getBool("is_signedin") ?? false;
    notifyListeners();
  }

  void signInWithPhone(BuildContext context, String phoneNumber) async {
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
          },
          codeAutoRetrievalTimeout: ((verificationId) {}));
    } on FirebaseAuthException catch (e) {
      showSnackBarWidget(context, e.message.toString());
    }
  }

  void verifyOtp({
    required BuildContext context, 
    required String verificationId,
    required String userOtp, 
    required Function onSuccess
  }) async {
    _isLoading = true;
    notifyListeners();
    try{
      PhoneAuthCredential creds = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: userOtp);
      User? user = (await _firebaseAuth.signInWithCredential(creds)).user!;
      if(user!=null){
        _uid = user.uid;
        onSuccess();
      }

      _isLoading = false;
      notifyListeners();

    } on FirebaseAuthException catch(e){
      showSnackBarWidget(context, e.message.toString());
       _isLoading = false;
      notifyListeners();
    }
  }

  // Operation sur la db
  Future<bool>checkExinstingUser() async {
    DocumentSnapshot snapshot = await _firebaseFireStore.collection("users").doc(_uid).get();
    if(snapshot.exists){
      print("******************************USER EXISTS***************************");
      return true;
    }else{
      print("******************************NEW USER***************************");
      return false;
    }
  }
}
