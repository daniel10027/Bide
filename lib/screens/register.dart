import 'package:bide/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(

      body: SafeArea(child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 35),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/other/4.png", height: 300,),
              const SizedBox(height: 20,),
              const Text("Commencer", style: TextStyle(fontSize: 22, fontWeight:  FontWeight.bold),), 
              const SizedBox(height: 10,),
              const Text("C'est peu être votre jour de chance aujourd'hui", style: TextStyle(fontSize: 14, fontWeight:  FontWeight.bold, color: Colors.black38),), 
              const SizedBox(height: 20,),
              // SizedBox(
              //   width: double.infinity,
              //   height: 50,
              //   child: CustomButton(
              //     text: "Commencer",
              //     onPressed: (){
              //       Navigator.push(context, MaterialPageRoute(builder: (context)=> const RegisterScreen()));
              //     },
              //   ),
              //   )
              // custom button
            ],
          ),
          ),
      )),
    );
  }
}