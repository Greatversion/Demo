

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mambo/models/Database%20models/cart_model.dart';

/// `CartService` provides methods to manage the user's cart in Firestore.
class CartService {
  // Firebase Authentication instance
  FirebaseAuth auth = FirebaseAuth.instance;

  // Firestore collection reference for user carts
  final CollectionReference _cartCollection =
      FirebaseFirestore.instance.collection('Users');

  /// Adds a product to the user's cart.
  ///
  /// Takes a [ProductCartModel] object as a parameter and saves it to the Firestore
  /// collection 'Cart' under the document of the current user's email.
  ///
  /// Throws an error if the cart item could not be added.
  Future<void> addItemInCart(ProductCartModel productCartModel) async {
    try {
      await _cartCollection
          .doc(auth.currentUser!.email)
          .collection('Cart')
          .doc(productCartModel.productID.toString())
          .set(productCartModel.toJson());
    } catch (e) {
      debugPrint('Error creating cart item: $e');
    }
  }

  /// Deletes a product from the user's cart.
  ///
  /// Takes a [productID] to specify which cart item to delete. It removes
  /// the item from the Firestore collection 'Cart' under the current user's email.
  ///
  /// Throws an error if the cart item could not be deleted.
  Future<void> deleteCartItem(String productID) async {
    try {
      await _cartCollection
          .doc(auth.currentUser!.email)
          .collection('Cart')
          .doc(productID)
          .delete();
    } catch (e) {
      debugPrint('Error deleting cart item: $e');
    }
  }

  /// Updates a specific field of a cart item.
  ///
  /// Takes a [productId] to specify which cart item to update, a [fieldName] to specify
  /// which field to update, and a [newValue] map containing the new value for the field.
  /// 
  /// Throws an error if the cart item field could not be updated.
  Future<void> updateCartItemField(
      int productId, String fieldName, Map<String, String> newValue) async {
    try {
      await _cartCollection
          .doc(auth.currentUser!.email)
          .collection('Cart')
          .doc(productId.toString())
          .update({fieldName: newValue});
    } catch (e) {
      debugPrint('Error updating cart item field: $e');
    }
  }

  /// Updates the quantity of a product in the cart.
  ///
  /// Takes a [productId] to specify which cart item to update and a [quantity] to
  /// specify the new quantity. It updates the quantity field of the cart item in Firestore.
  ///
  /// Throws an error if the cart item quantity could not be updated.
  Future<void> updateProductQuantity(String productId, int quantity) async {
    try {
      await _cartCollection
          .doc(auth.currentUser!.email)
          .collection('Cart')
          .doc(productId.toString())
          .update({'quantity': quantity});
    } catch (e) {
      debugPrint('Error updating cart item field: $e');
    }
  }

  /// Retrieves the list of products in the user's cart.
  ///
  /// Takes a [userId] to specify which user's cart to fetch. It returns a list
  /// of [ProductCartModel] objects obtained from the Firestore collection 'Cart'
  /// for the specified user.
  ///
  /// Returns an empty list if an error occurs or no items are found.
  Future<List<ProductCartModel>> getUserCart(String userId) async {
    try {
      QuerySnapshot snapshot =
          await _cartCollection.doc(userId).collection('Cart').get();
      return snapshot.docs
          .map((doc) =>
              ProductCartModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error fetching user cart: $e');
      return [];
    }
  }
}
