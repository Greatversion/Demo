// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mambo/providers/online_connectivity_provider.dart';
import 'package:mambo/routes/app.nameRoutes.dart';
import 'package:mambo/utils/app.colors.dart';
import 'package:mambo/utils/app.constants.dart';
import 'package:mambo/utils/app.styles.dart';
import 'package:mambo/view%20models/auth_view_model.dart';
import 'package:provider/provider.dart';

import '../../utils/Reusable_widgets/app.buttons.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final AuthenticationProvider authProvider =
        Provider.of<AuthenticationProvider>(context);
    final ConnectivityService connectivityService =
        Provider.of<ConnectivityService>(context);

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            color: Colors.white,
            height: height,
            width: width,
          ),
          // Scrolling background images
          // Positioned widget with ClipPath
          Positioned(
            top: -height * 0.01,
            left: -width * 0.4,
            child: ClipPath(
              clipper: MyClipper(),
              child: Stack(
                children: [
                  Row(
                    children: List.generate(
                      3,
                      (index) => ScrollingImages(startingIndex: index),
                    ),
                  ),
                  // Overlapping Container
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: height * 0.73 + 5,
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black12,
                          Colors.black54,
                        ],
                      )),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            bottom:
                                25.0), // Adjust padding to position image above arc
                        child: Align(
                          alignment: Alignment
                              .bottomCenter, // Aligns the image at the bottom center
                          child: Image.asset(
                            width: width - 20,
                            'assets/images/mambo.png',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Main content
          Positioned(
            bottom: 0,
            child: SizedBox(
              width: width,
              child: Column(
                children: [
                  SizedBox(height: height * 0.04),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    child: Text(
                      "Create Your Account",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Raleway',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: height * 0.05),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                    child: connectivityService.isOnline
                        ? LoginButton('Google', 'google', () {
                            _loginWithGoogle(context, authProvider);
                          })
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Icon(
                                Icons.network_check_rounded,
                                color: Color.fromARGB(255, 195, 14, 1),
                              ),
                              SizedBox(
                                child: Text(
                                  "Please connect to the Network.",
                                  style: AppStyles.boldText,
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ],
                          ),
                  ),
                  // const Spacer(),
                  const SizedBox(height: 35),
                  Padding(
                    padding: EdgeInsets.all(height * 0.01),
                    child: Text(
                      "All Rights Reserved © MAMBO",
                      style: TextStyle(fontSize: height * 0.015),
                    ),
                  ),
                  SizedBox(height: height * 0.001),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _loginWithGoogle(
      BuildContext context, AuthenticationProvider authProvider) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    // Sign out from Firebase and Google before trying to log in again

    await auth.signOut();
    await authProvider.signOut();

    // Show the loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      ),
    );

    // Attempt to log in again with Google
    if (auth.currentUser == null) {
      authProvider.googleLogin().then((value) async {
        Navigator.of(context).pop(); // Close the loading dialog
        if (auth.currentUser != null) {
          await Navigator.pushReplacementNamed(
            context,
            RoutesName.mainUi,
            // arguments: {"userName": auth.currentUser!.displayName},
          );
        }
      }).onError((error, stackTrace) {
        Navigator.of(context).pop(); // Close the loading dialog on error
        if (kDebugMode) {
          print(error.toString());
        }
      });
    }
  }
}

class ScrollingImages extends StatefulWidget {
  final int startingIndex;

  const ScrollingImages({
    super.key,
    required this.startingIndex,
  });

  @override
  State<ScrollingImages> createState() => _ScrollingImagesState();
}

class _ScrollingImagesState extends State<ScrollingImages> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    _scrollController.addListener(() {
      if (_scrollController.offset ==
          _scrollController.position.minScrollExtent) {
        _autoScrollForward();
      } else if (_scrollController.offset ==
          _scrollController.position.maxScrollExtent) {
        _autoScrollbackward();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _autoScrollForward();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _autoScrollForward() {
    final currentPosition = _scrollController.offset;
    final endPosition = _scrollController.position.maxScrollExtent;
    scheduleMicrotask(() {
      _scrollController.animateTo(
        currentPosition == endPosition ? 0 : endPosition,
        duration: Duration(seconds: 20 + widget.startingIndex + 2),
        curve: Curves.linear,
      );
    });
  }

  void _autoScrollbackward() {
    final currentPosition = _scrollController.offset;
    final endPosition = _scrollController.position.minScrollExtent;
    scheduleMicrotask(() {
      _scrollController.animateTo(
        currentPosition == endPosition ? 0 : endPosition,
        duration: Duration(seconds: 20 + widget.startingIndex + 2),
        curve: Curves.linear,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Transform.rotate(
      angle: pi * 1.96,
      child: Stack(
        children: [
          Container(
            color: Colors.black,
            height: height * 0.85,
            width: width * 0.6,
            child: ListView.builder(
              controller: _scrollController,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(
                    vertical: height * 0.01,
                    horizontal: width * 0.02,
                  ),
                  height: height * 0.5,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.all(Radius.circular(width * 0.05)),
                    image: DecorationImage(
                      image: AssetImage(AppConst.images[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            height: height / 2,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Color.fromARGB(190, 0, 0, 0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double width = size.width;
    double height = size.height;
    final path = Path();
    path.lineTo(0, height - 200);
    path.quadraticBezierTo(width * 0.5, height, width, height - 200);
    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class SemiCircularClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double w = size.width;
    double h = size.height;
    final path = Path();
    path.lineTo(-25, h - 38);
    path.quadraticBezierTo(w * 0.5, h + 38, w, h - 31);
    path.lineTo(w, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
