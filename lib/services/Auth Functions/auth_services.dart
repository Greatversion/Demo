

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// `AuthenticationService` handles user authentication with Google and Facebook.
class AuthenticationService {
  // Instance of GoogleSignIn to handle Google sign-in
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Handles Google login.
  ///
  /// Returns a [User] object if the login is successful, or `null` if the
  /// user cancels the sign-in process or an error occurs.
  Future<User?> googleLogin() async {
    try {
      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // Check if the user canceled the sign-in process
      if (googleUser == null) {
        debugPrint("User canceled the sign-in process.");
        return null;
      }

      // Obtain the authentication details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the obtained Google credential
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Return the signed-in user
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // Handle Firebase-specific exceptions
      debugPrint("Firebase Auth error: ${e.message}");
      return null;
    } catch (e) {
      // Handle general exceptions
      debugPrint("Google sign-in error: $e");
      return null;
    }
  }

  /// Handles Facebook login.
  ///
  /// Returns a [User] object if the login is successful, or `null` if an
  /// error occurs or the access token is not available.
  // Future<User?> facebookLogin() async {
  //   try {
  //     // Trigger the Facebook login flow
  //     final fbUser = await FacebookAuth.instance.login();
      
  //     // Check if the access token is available
  //     if (fbUser.accessToken != null) {
  //       // Create a credential for Firebase authentication
  //       final facebookAuthCredential =
  //           FacebookAuthProvider.credential(fbUser.accessToken!.tokenString);

  //       // Sign in to Firebase with the obtained Facebook credential
  //       final userCredential = await FirebaseAuth.instance
  //           .signInWithCredential(facebookAuthCredential);
  //       return userCredential.user;
  //     }
  //     return null;
  //   } catch (e) {
  //     // Handle any errors that occur during Facebook login
  //     debugPrint("Facebook sign-in error: $e");
  //     return null;
  //   }
  // }

  /// Signs out the user from both Google and Firebase.
  ///
  /// Also ensures that the user is logged out from Firebase.
  Future<void> signOut() async {
    try {
      // Sign out from Google
      await _googleSignIn.signOut();
      // Sign out from Firebase
      await FirebaseAuth.instance.signOut();
      
      // Ensure the current user is null after sign-out
      FirebaseAuth.instance.currentUser == null;
      
      // Optionally log out from Facebook as well if needed
      // await FacebookAuth.instance.logOut();
    } catch (e) {
      // Handle any errors that occur during sign-out
      debugPrint("Sign out error: $e");
    }
  }
}
