
// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mambo/models/Database%20models/auth_user_model.dart';
import 'package:mambo/services/Auth%20Functions/auth_services.dart';


/// `FireStoreService` provides methods to interact with FireStore and manage user data.
class FirestoreService {
  // Firestore instance for database operations
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Authentication service instance for user management
  AuthenticationService authenticationProvider = AuthenticationService();

  /// Adds a new user to the Firestore database.
  ///
  /// Takes a [UserModel] object, converts it to a map, and saves it in the 'Users' collection
  /// using the user's email as the document ID.
  ///
  /// Throws an error if the user could not be added.
  Future<void> addUser(UserModel user) async {
    try {
      await _db.collection('Users').doc(user.email).set(user.toMap());
      debugPrint('User added successfully');
    } catch (e) {
      debugPrint('Error adding user: $e');
      rethrow; // Rethrow the error to be handled by the caller
    }
  }

  /// Fetches a user's data from Firestore.
  ///
  /// Takes the user's email as a parameter and retrieves the corresponding user data
  /// from the 'Users' collection. Returns the user data as a [UserModel] object.
  ///
  /// Throws an error if the user could not be fetched.
  Future<UserModel?> getUser(String email) async {
    try {
      final doc = await _db.collection('Users').doc(email).get();
      if (doc.exists) {
        final userData = doc.data()!;
        return UserModel.fromMap(userData);
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching user data: $e');
      return null;
    }
  }

  /// Updates a user's data in Firestore.
  ///
  /// Takes a [UserModel] object, converts it to a map, and updates the corresponding document
  /// in the 'Users' collection using the user's email as the document ID.
  ///
  /// Throws an error if the user data could not be updated.
  Future<void> updateUser(UserModel user) async {
    try {
      await _db.collection('Users').doc(user.email).update(user.toMap());
      debugPrint('User updated successfully');
    } catch (e) {
      debugPrint('Error updating user: $e');
      rethrow;
    }
  }

  /// Deletes a user from Firestore and Firebase Authentication.
  ///
  /// Takes the user's email as a parameter, deletes the user's document from Firestore,
  /// and removes the user's related sub-collections if they exist. Finally, it deletes
  /// the user from Firebase Authentication.
  ///
  /// If the user needs to reauthenticate, it calls `_reauthenticateAndDelete()`.
  ///
  /// Throws an error if any operation fails.
  Future<void> deleteUser(String userEmail) async {
    try {
      // Reference to the user's document in Firestore
      final docRef =
          FirebaseFirestore.instance.collection('Users').doc(userEmail);

      // Delete user document from Firestore
      await docRef.delete();

      // Optional: Delete sub-collections (if any)
      final subCollections = ['Cart', 'Addresses', 'Past Orders', 'Wishlists'];
      for (final subCollection in subCollections) {
        final collectionRef = docRef.collection(subCollection);
        final snapshot = await collectionRef.get();
        for (final doc in snapshot.docs) {
          await doc.reference.delete();
        }
      }

      // Delete user from Firebase Authentication
      try {
        await FirebaseAuth.instance.currentUser!.delete();
        if (FirebaseAuth.instance.currentUser != null) {
          await authenticationProvider.signOut();
        }
      } on FirebaseAuthException catch (e) {
        debugPrint(e.toString());
        if (e.code == "requires-recent-login") {
          await _reAuthenticateAndDelete();
        } else {
          debugPrint("Error in Firebase Auth");
        }
      }
      debugPrint('User deleted successfully!');
    } catch (e) {
      debugPrint('Error deleting user: ${e.toString()}');
    }
  }

  /// ReAuthenticates the current user and then deletes the user.
  ///
  /// If the user is authenticated with Google, it reAuthenticates the user with Google
  /// and then attempts to delete the user. It also signs out the user after deletion.
  ///
  /// Throws an error if reAuthentication or deletion fails.
  _reAuthenticateAndDelete() async {
    try {
      final providerData =
          FirebaseAuth.instance.currentUser!.providerData.first;
      if (GoogleAuthProvider().providerId == providerData.providerId) {
        await FirebaseAuth.instance.currentUser!
            .reauthenticateWithProvider(GoogleAuthProvider());
      }

      await FirebaseAuth.instance.currentUser!.delete();
      if (FirebaseAuth.instance.currentUser != null) {
        await authenticationProvider.signOut();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
