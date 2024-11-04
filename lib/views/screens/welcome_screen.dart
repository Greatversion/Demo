// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mambo/routes/app.nameRoutes.dart';
// import 'package:mambo/views/Home/main_screen.dart';


// class WelcomeScreen extends StatefulWidget {
//   final String name;
//   const WelcomeScreen({super.key, required this.name});
//
//   @override
//   State<WelcomeScreen> createState() => _WelcomeScreenState();
// }
//
// class _WelcomeScreenState extends State<WelcomeScreen>
//     with TickerProviderStateMixin {
//   late AnimationController controller;
//   final String _tagLine = "Get to discover the best designs";
//   @override
//   void initState() {
//     // checkCurrentUser(context);
//     controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 3300),
//     )..addListener(() {
//         setState(() {});
//       });
//     controller.repeat(max: 1);
//
//     Future.delayed(const Duration(milliseconds: 3210), () {
//
//         Navigator.pushReplacementNamed(context, RoutesName.mainUi);
//
//     });
//     super.initState();
//   }
//
//   // Future<void> checkCurrentUser(BuildContext context) async {
//   //   final FirebaseAuth auth = FirebaseAuth.instance;
//   //   final user = auth.currentUser;
//   //   if (user == null) {
//   //     Timer(const Duration(seconds: 3), () {
//   //       Navigator.pushReplacementNamed(context, RoutesName.loginScreen);
//   //     });
//   //   } else {
//   //     Timer(const Duration(seconds: 3), () {
//   //       Navigator.pushReplacementNamed(context, RoutesName.welcome,
//   //           arguments: {"userName": user.displayName});
//   //     });
//   //   }
//   // }
//
//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(30.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Welcome ${widget.name},",
//               style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
//             ),
//             const SizedBox(height: 15),
//             Text(
//               _tagLine,
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
//             ),
//             const SizedBox(height: 60),
//             SizedBox(
//               width: double.maxFinite,
//               child: LinearProgressIndicator(
//                 minHeight: 6,
//                 borderRadius: BorderRadius.circular(20),
//                 value: controller.value,
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

class SplashDecider extends StatelessWidget {
  const SplashDecider({super.key});

  @override
  Widget build(BuildContext context) {
    // Check current user's authentication status
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // No user is signed in, navigate to the login screen
      Future.microtask(() {
        Navigator.pushReplacementNamed(context, RoutesName.loginScreen);
      });
    } else {
      // User is signed in, show welcome screen first, then navigate to the main UI
      Future.microtask(() {
        Navigator.pushReplacementNamed(
          context,
          RoutesName.mainUi,
          // arguments:{ user.displayName ?? "User"},
        );
      });
    }

    // Return an empty container or loading screen while decision is being made
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
