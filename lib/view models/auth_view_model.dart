

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mambo/services/Database%20Functions/user_service.dart';
import 'package:mambo/services/Auth%20Functions/auth_services.dart';
import 'package:mambo/models/Database%20models/auth_user_model.dart';

/// [AuthenticationProvider] is a [ChangeNotifier] class that manages
/// user authentication state and provides methods for logging in, logging out,
/// and deleting user accounts using different authentication services (Google, Facebook).
/// It interacts with [AuthenticationService] for authentication operations
/// and [FirestoreService] for user-related database operations.
class AuthenticationProvider extends ChangeNotifier {
  // Service instances for handling authentication and Firestore operations.
  final AuthenticationService _authService =
      AuthenticationService(); // Instance of authentication service
  final FirestoreService _firestoreService =
      FirestoreService(); // Instance of Firestore service

  // The current authenticated user's data model.
  UserModel? _user;

  // Getter to access the current authenticated user.
  UserModel? get user => _user;

  /// Logs in the user using Google Sign-In.
  /// Upon successful login, it fetches the Firebase user details,
  /// creates a [UserModel] instance, and stores the user in Firestore.
  /// If an error occurs during login, it prints an error message.
  Future<void> googleLogin() async {
    try {
      // Perform Google login and get the Firebase user.
      User? firebaseUser = await _authService.googleLogin();

      if (firebaseUser != null) {
        // Create a UserModel instance with Firebase user details.
        _user = UserModel(
            uid: firebaseUser.uid,
            email: firebaseUser.email!,
            displayName: firebaseUser.displayName!,
            photoUrl: firebaseUser.photoURL!,
            lastlogIn: DateTime.now());

        // Add user to Firestore.
        await _firestoreService.addUser(_user!);
      }
    } catch (e) {
      // Log error if Google login fails.
      debugPrint("Google login error: $e");
    }
    // Notify listeners to update UI after login attempt.
    notifyListeners();
  }

  /// Logs in the user using Facebook Sign-In.
  /// Upon successful login, it fetches the Firebase user details,
  /// creates a [UserModel] instance, and stores the user in Firestore.
  /// If an error occurs during login, it prints an error message.
  // Future<void> facebookLogin() async {
  //   try {
  //     // Perform Facebook login and get the Firebase user.
  //     User? firebaseUser = await _authService.facebookLogin();

  //     if (firebaseUser != null) {
  //       // Create a UserModel instance with Firebase user details.
  //       _user = UserModel(
  //           uid: firebaseUser.uid,
  //           email: firebaseUser.email!,
  //           displayName: firebaseUser.displayName!,
  //           photoUrl: firebaseUser.photoURL!,
  //           lastlogIn: DateTime.now());

  //       // Add user to Firestore.
  //       await _firestoreService.addUser(_user!);
  //     }
  //   } catch (e) {
  //     // Log error if Facebook login fails.
  //     debugPrint("Facebook login error: $e");
  //   }
  //   // Notify listeners to update UI after login attempt.
  //   notifyListeners();
  // }

  /// Signs the user out of the application.
  /// It calls the sign-out method from [AuthenticationService] and sets
  /// the [_user] to null. If an error occurs during sign-out, it prints an error message.
  Future<void> signOut() async {
    try {
      // Perform sign out.
      await _authService.signOut();
      _user = null; // Reset the user model after sign out.
    } catch (e) {
      // Log error if sign out fails.
      debugPrint("Sign out error: $e");
    } finally {
      // Notify listeners to update UI after sign-out attempt.
      notifyListeners();
    }
  }

  /// Deletes the user's account from Firebase and Firestore.
  /// It checks if the current user is not null and then deletes the user
  /// data from Firestore. If an error occurs during deletion, it prints an error message.
  Future<void> deleteUser() async {
    try {
      // Check if the current user is logged in.
      if (FirebaseAuth.instance.currentUser != null) {
        // Delete the user data from Firestore using their email.
        await _firestoreService
            .deleteUser(FirebaseAuth.instance.currentUser!.email!);
      }
      _user = null; // Reset the user model after account deletion.
    } catch (e) {
      // Log error if account deletion fails.
      debugPrint("Account Deletion error: $e");
    } finally {
      // Notify listeners to update UI after deletion attempt.
      notifyListeners();
    }
  }
}
