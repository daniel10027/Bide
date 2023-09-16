import 'package:bide/provider/auth_provider.dart';
import 'package:bide/utils/colors.dart';
import 'package:bide/screens/main_home.dart';
import 'package:bide/screens/user_info.dart';
import 'package:bide/utils/utils.dart';
import 'package:bide/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';


class OtpScreen extends StatefulWidget {
  final String verificationId;
  const OtpScreen({super.key, required this.verificationId});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String? otpCode;
  @override
  Widget build(BuildContext context) {
    final isLoading = Provider.of<AuthProvider>(context, listen:true).isLoading;
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
            child: isLoading == true ? const Center(child: CircularProgressIndicator(color: Colors.orange)) :  Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 30),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.arrow_back_ios),
                  ),
                ),
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blueAccent,
                  ),
                  child: Image.asset("assets/images/other/4.png"),
                ),
                SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Vérification OTP",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Entrez le code OTP recu par Sms",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black38),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                Pinput(
                  length: 6,
                  showCursor: true,
                  defaultPinTheme: PinTheme(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: primaryColor)),
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      )),
                  onCompleted: (value) {
                    setState(() {
                      otpCode = value;
                    });
                    print(otpCode);
                  },
                ),
                const SizedBox(
                  height: 25,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: CustomButton(
                      text: "Vérifier",
                      onPressed: () {
                        if (otpCode != null) {
                          verifyOtp(context, otpCode!);
                        } else {
                          showSnackBarWidget(context, "Entrez le code à 6 Chiffres");
                        }
                      }),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Vous n'avez pas recu de code ? ",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black38),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  "Renvoyer un nouveau code",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange),
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }

  // verification du code Otp
  void verifyOtp(BuildContext context, String userOtp) {
    final ap = Provider.of<AuthProvider>(context, listen:false);
    ap.verifyOtp(context: context, verificationId: widget.verificationId , userOtp: userOtp, onSuccess: (){
      // verification de l'existance de l'utilisateur dans la base de données db
    ap.checkExinstingUser().then((value) async {
      if(value == true){
        // utilisateur exiatant
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const HomeScreen()), (route) => false);

      }else{
        //nouvel utilisateur
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const UserInformationScreen()), (route) => false);
      }
    } );
    });
  }
}
