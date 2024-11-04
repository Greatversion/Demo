

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mambo/models/Database%20models/address_model.dart';
// import 'package:mambo/models/Network%20models/product_model.dart';

/// `AddressService` provides methods to manage user addresses in Firestore.
class AddressService {
  // Firebase Authentication instance
  FirebaseAuth auth = FirebaseAuth.instance;

  // Firestore collection reference for user addresses
  final CollectionReference _addressCollection =
      FirebaseFirestore.instance.collection('Users');

  /// Adds a new address for the current user.
  ///
  /// Takes an [AddressModel] object as a parameter and saves it to the Firestore
  /// collection 'Addresses' under the document of the current user's email.
  /// 
  /// Throws an error if the address could not be added.
  Future<void> addUserAddress(AddressModel addressModel) async {
    try {
      await _addressCollection
          .doc(auth.currentUser!.email)
          .collection('Addresses')
          .doc(addressModel.addressId.toString())
          .set(addressModel.toJson());
      debugPrint('Address added');
    } catch (e) {
      debugPrint('Error adding user address: $e');
    }
  }

  /// Updates an existing address in Firestore.
  ///
  /// Takes a [documentId] to specify which address to update and a [data] map
  /// containing the new address data. It updates the address in the Firestore
  /// collection 'Addresses' under the specified document ID.
  /// 
  /// Throws an error if the address could not be updated.
  Future<void> updateUserAddress(
      String documentId, Map<String, dynamic> data) async {
    try {
      await _addressCollection.doc(documentId).update(data);
      debugPrint('Address updated');
    } catch (e) {
      debugPrint('Error updating user data: $e');
    }
  }

  /// Retrieves a list of addresses for a specified user.
  ///
  /// Takes a [userId] to specify which user's addresses to fetch. It returns
  /// a list of [AddressModel] objects obtained from the Firestore collection 
  /// 'Addresses' for the specified user.
  /// 
  /// Returns an empty list if an error occurs or no addresses are found.
  Future<List<AddressModel>> getUserAddresses(String userId) async {
    try {
      QuerySnapshot snapshot =
          await _addressCollection.doc(userId).collection('Addresses').get();
      debugPrint('Address fetched');
      return snapshot.docs
          .map((doc) =>
              AddressModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error fetching user addresses: $e');
      return [];
    }
  }

  /// Deletes an address for the current user.
  ///
  /// Takes an [AddressModel] object specifying which address to delete. It
  /// removes the address from the Firestore collection 'Addresses' under
  /// the current user's email.
  /// 
  /// Throws an error if the address could not be deleted.
  Future<void> deleteUserAddress(AddressModel addressModel) async {
    try {
      await _addressCollection
          .doc(auth.currentUser!.email)
          .collection("Addresses")
          .doc(addressModel.addressId.toString())
          .delete();
      debugPrint('Address deleted');
    } catch (e) {
      debugPrint('Error deleting user address: $e');
    }
  }
}
