import 'dart:io';
import 'package:bide/model/user_model.dart';
import 'package:bide/provider/auth_provider.dart';
import 'package:bide/screens/main_home.dart';
import 'package:bide/utils/utils.dart';
import 'package:bide/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../utils/colors.dart';

class UserInformationScreen extends StatefulWidget {
  const UserInformationScreen({Key? key}) : super(key: key);

  @override
  _UserInformationScreenState createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends State<UserInformationScreen> {
  String imageUrl = "";
  File? image;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final bioController = TextEditingController();
  bool isLoading = false; // Ajout de la variable isLoading

  @override
  void initState() {
    super.initState();
    final ap = Provider.of<AuthProvider>(context, listen: false);
    ap.getDataFromSP();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    bioController.dispose();
  }

  // for selecting image
  void selectImage() async {
    image = await pickImage(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: secondaryColor,
      body: SafeArea(
        child: FutureBuilder(
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
              nameController.text = ap.userModel.name ?? "";
              emailController.text = ap.userModel.email ?? "";
              bioController.text = ap.userModel.bio ?? "";
              imageUrl = ap.userModel.ProfilePic ?? "";

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  vertical: 25.0,
                  horizontal: 5.0,
                ),
                child: Center(
                  child: Column(
                    children: [
                      InkWell(
                        // onTap: () => selectImage(),
                        child: imageUrl.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10000.0),
                                child: CachedNetworkImage(
                                  imageUrl: imageUrl,
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                  fit: BoxFit.cover,
                                  width: 100, // Set the desired width
                                  height: 100, // Set the desired height
                                ),
                              )
                            : (image != null
                                ? CircleAvatar(
                                    backgroundImage: FileImage(image!),
                                    radius: 50,
                                  )
                                : CircleAvatar(
                                    backgroundColor: primaryColor,
                                    radius: 50,
                                    child: Icon(
                                      Icons.account_circle,
                                      size: 50,
                                      color: Colors.white,
                                    ),
                                  )),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 15,
                        ),
                        margin: const EdgeInsets.only(top: 20),
                        child: Column(
                          children: [
                            // name field
                            textField(
                              hintText: "Dip Anda",
                              icon: Icons.account_circle,
                              inputType: TextInputType.name,
                              maxLines: 1,
                              controller: nameController,
                            ),

                            // email
                            textField(
                              hintText: "dipanda@example.com",
                              icon: Icons.email,
                              inputType: TextInputType.emailAddress,
                              maxLines: 1,
                              controller: emailController,
                            ),

                            // bio
                            textField(
                              hintText: "Votre Bio ici...",
                              icon: Icons.edit,
                              inputType: TextInputType.name,
                              maxLines: 2,
                              controller: bioController,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.90,
                        child: isLoading
                            ? CircularProgressIndicator(
                                color: primaryColor,
                              )
                            : CustomButton(
                                text: "Continuer",
                                onPressed: () => storeData(),
                              ),
                      )
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget textField({
    required String hintText,
    required IconData icon,
    required TextInputType inputType,
    required int maxLines,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        cursorColor: Colors.blueAccent,
        controller: controller,
        keyboardType: inputType,
        maxLines: maxLines,
        decoration: InputDecoration(
          prefixIcon: Container(
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: primaryColor,
            ),
            child: Icon(
              icon,
              size: 20,
              color: Colors.white,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
          hintText: hintText,
          alignLabelWithHint: true,
          border: InputBorder.none,
          fillColor: const Color.fromARGB(255, 229, 245, 245),
          filled: true,
        ),
      ),
    );
  }

  // store user data to database
  void storeData() async {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    UserModel userModel = UserModel(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      bio: bioController.text.trim(),
      ProfilePic: "",
      createdAt: "",
      phoneNumber: "",
      uid: "",
      AccountBalance: 0,
    );
    setState(() {
      isLoading =
          true; // Affichez l'indicateur de progression pendant la sauvegarde
    });

    ap.saveUserDataToFirebase(
      context: context,
      userModel: userModel,
      onSuccess: () {
        ap.saveUserDataToSP().then(
              (value) => ap.setSignIn().then(
                    (value) => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                      (route) => false,
                    ),
                  ),
            );
      },
    );

    setState(() {
      isLoading =
          false; // Masquez l'indicateur de progression après la sauvegarde
    });
  }
}
