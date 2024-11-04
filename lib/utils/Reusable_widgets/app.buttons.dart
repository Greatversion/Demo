import 'package:flutter/material.dart';
import 'package:mambo/utils/app.colors.dart';
import 'package:mambo/utils/app.styles.dart';

// ignore: non_constant_identifier_names
OutlinedButton LoginButton(String name, String logo, Function() onpressed) {
  return OutlinedButton(
      style: OutlinedButton.styleFrom(side: const BorderSide(width: 1.0)),
      onPressed: onpressed,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 20,
                child: Image.asset("assets/images/$logo.png")),
            Text(
              'Continue with $name',
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: AppColors.black),
            )
          ],
        ),
      ));
}

class BackbuttonWidget extends StatelessWidget {
  const BackbuttonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white38,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Icon(
              Icons.arrow_back_ios,
              size: AppStyles.backIconSize,
            ),
          ),
        ),
      ),
    );
  }
}
