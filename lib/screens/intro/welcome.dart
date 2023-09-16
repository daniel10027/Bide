import 'package:bide/provider/auth_provider.dart';
import 'package:bide/utils/colors.dart';
import 'package:bide/screens/main_home.dart';
import 'package:bide/screens/auths/register.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
      final ap = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: secondaryColor,
      body: SafeArea(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 35),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/other/5.png",
                height: 300,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Commencer",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "C'est peu être votre jour de chance aujourd'hui",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black38),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    ap.isSignedIn == true
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const HomeScreen(), // Remplacez WelcomeScreen() par le nom de votre classe WelcomeScreen
                            ),
                          )
                        : Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const RegisterScreen(), // Remplacez WelcomeScreen() par le nom de votre classe WelcomeScreen
                            ),
                          );
                  },
                  
                  style: ButtonStyle(
                    
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(primaryColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0))),
                  ),
                  child: Text(
                    "Commencer",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              )
              // custom button
            ],
          ),
        ),
      )),
    );
  }
}
