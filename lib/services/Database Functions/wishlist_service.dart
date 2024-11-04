


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:mambo/models/Database%20models/wishlist_model.dart';

/// `WishListService` provides methods to manage wishlist items in Firestore.
class WishListService {
  // Firebase Authentication instance for managing user authentication
  FirebaseAuth auth = FirebaseAuth.instance;

  // Firestore collection reference for user-specific data
  final CollectionReference _wishlistCollection =
      FirebaseFirestore.instance.collection('Users');

  /// Creates a new wishlist item or updates an existing one in Firestore.
  ///
  /// Takes a [WishListModel] object, converts it to a map, and saves it in the 'Wishlists' 
  /// sub-collection of the current user's document in Firestore.
  ///
  /// Throws an error if the item could not be created or updated.
  Future<void> createWishlistItem(WishListModel wishlist) async {
    try {
      await _wishlistCollection
          .doc(auth.currentUser!.email)
          .collection('Wishlists')
          .doc(wishlist.product!.productId.toString())
          .set(wishlist.toJson());
    } catch (e) {
      debugPrint('Error creating wishlist item: $e');
    }
  }

  /// Retrieves a specific wishlist item from Firestore.
  ///
  /// Takes the item's `id` as a parameter, fetches the document from the 'Wishlists' 
  /// sub-collection of the current user's document, and returns a [WishListModel] object 
  /// if the document exists. Returns `null` if the item does not exist or an error occurs.
  Future<WishListModel?> getWishlistItem(String id) async {
    try {
      DocumentSnapshot doc = await _wishlistCollection
          .doc(auth.currentUser!.email)
          .collection('Wishlists')
          .doc(id)
          .get();
      if (doc.exists) {
        return WishListModel.fromJson(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      debugPrint('Error fetching wishlist item: $e');
    }
    return null;
  }

  /// Deletes a specific wishlist item from Firestore.
  ///
  /// Takes a [WishListModel] object, and removes the document corresponding to the 
  /// item's `productId` from the 'Wishlists' sub-collection of the current user's document.
  ///
  /// Throws an error if the item could not be deleted.
  Future<void> deleteWishlistItem(WishListModel wishlist) async {
    try {
      await _wishlistCollection
          .doc(auth.currentUser!.email)
          .collection('Wishlists')
          .doc(wishlist.product!.productId!.toString())
          .delete();
    } catch (e) {
      debugPrint('Error deleting wishlist item: $e');
    }
  }

  /// Retrieves all wishlist items for a specific user from Firestore.
  ///
  /// Takes the `userId` as a parameter, fetches all documents from the 'Wishlists' 
  /// sub-collection of the user's document, and returns a list of [WishListModel] objects.
  ///
  /// Returns an empty list if no items are found or an error occurs.
  Future<List<WishListModel>> getUserWishlist(String userId) async {
    try {
      QuerySnapshot snapshot =
          await _wishlistCollection.doc(userId).collection('Wishlists').get();
      return snapshot.docs
          .map((doc) =>
              WishListModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error fetching user wishlist: $e');
      return [];
    }
  }
}
