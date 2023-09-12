import 'dart:io';
import 'package:bide/model/user_model.dart';
import 'package:bide/provider/auth_provider.dart';
import 'package:bide/utils/utils.dart';
import 'package:bide/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserInformationScreen extends StatefulWidget {
  const UserInformationScreen({super.key});

  @override
  State<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends State<UserInformationScreen> {
  File? image;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final bioController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    bioController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 5.0),
        child: Center(
          child: Column(
            children: [
              InkWell(
                onTap: () {},
                child: image == null
                    ? const CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        radius: 50,
                        child: Icon(
                          Icons.account_circle,
                          size: 50,
                          color: Colors.white,
                        ),
                      )
                    : CircleAvatar(
                        backgroundImage: FileImage(image!),
                        backgroundColor: Colors.blueAccent,
                        radius: 50,
                        child: Icon(
                          Icons.account_circle,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                margin: const EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    textField(
                        hinText: "Panda Dipanda",
                        icon: Icons.account_circle,
                        inputType: TextInputType.name,
                        maxLines: 1,
                        controller: nameController),
                    textField(
                        hinText: "dipanda@gmail.com",
                        icon: Icons.email,
                        inputType: TextInputType.emailAddress,
                        maxLines: 1,
                        controller: emailController),
                    textField(
                        hinText: "Votre Bio ici ......",
                        icon: Icons.edit,
                        inputType: TextInputType.name,
                        maxLines: 2,
                        controller: bioController)
                  ],
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.90,
                child: CustomButton(
                  text: "Continuer",
                  onPressed: () => storeData(),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Widget textField({
    required String hinText,
    required IconData icon,
    required TextInputType inputType,
    required int maxLines,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        cursorColor: Color.fromARGB(255, 215, 223, 238),
        controller: controller,
        keyboardType: inputType,
        maxLines: maxLines,
        decoration: InputDecoration(
          prefixIcon: Container(
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.blueAccent),
            child: Icon(
              icon,
              size: 20,
              color: Colors.white,
            ),
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.transparent)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.blueAccent)),
          hintText: hinText,
          alignLabelWithHint: true,
          border: InputBorder.none,
          fillColor: Color.fromARGB(255, 187, 206, 237),
          filled: true,
        ),
      ),
    );
  }

  // enregistrer les données de l'utilisateur
  void storeData() async {
    print('Soumission**********************************');
    final ap = Provider.of<AuthProvider>(context, listen: false);
    UserModel userModel = UserModel(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        bio: bioController.text.trim(),
        ProfilePic: "",
        createdAt: "",
        phoneNumber: "",
        uid: "uid",
        AccountBalance: 0);
    if (image != null) {
    } else {
      showSnackBarWidget(context, "Merci de chosir une Photo de Profil");
    }
  }
}
