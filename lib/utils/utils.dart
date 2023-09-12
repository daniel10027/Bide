import 'package:flutter/material.dart';

void showSnackBarWidget(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(content),
  ));
}
