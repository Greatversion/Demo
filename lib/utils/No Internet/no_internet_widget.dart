import 'package:flutter/material.dart';
import 'package:mambo/utils/app.colors.dart';

class NoInternetWidget extends StatelessWidget {
  const NoInternetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    String msg = "Seems that you're offline";
    String desc = "Kindly check your internet connection and retry";
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // SizedBox(height: 30),/
          const Icon(Icons.network_check_rounded,
              size: 50, color: AppColors.primary), // No internet icon
          const SizedBox(height: 10),
          Text(msg,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(desc.toUpperCase(),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 120, 120, 120),
              )), // No internet message
        ],
      ),
    );
  }
}
