import 'package:flutter/material.dart';
import 'package:mambo/utils/app.colors.dart';

void customSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(
    backgroundColor: AppColors.primary,
    content: Text(
      message,
      style: const TextStyle(
          color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
    ),
    duration: const Duration(seconds: 3),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
