import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

void showSnackBarWidget(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(content),
  ));
}

Future<File?> pickImage(BuildContext context) async {
  File? image;
  try {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    showSnackBarWidget(context, e.toString());
  }

  return image;
}
