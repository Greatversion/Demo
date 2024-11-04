

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:mambo/models/Database%20models/order_model.dart';

/// `PastOrderService` provides methods to manage past orders in Firestore.
class PastOrderService {
  // Firebase Authentication instance
  FirebaseAuth auth = FirebaseAuth.instance;

  // Firestore collection reference for user orders
  final CollectionReference _orderCollection =
      FirebaseFirestore.instance.collection('Users');

  /// Adds a new order to the user's past orders.
  ///
  /// Takes a [orderModel] map containing the order details and saves it to the Firestore
  /// collection 'Past Orders' under the document of the current user's email.
  ///
  /// Throws an error if the order could not be added.
  Future<void> addOrder(Map<String, dynamic> orderModel) async {
    try {
      await _orderCollection
          .doc(auth.currentUser!.email)
          .collection('Past Orders')
          .doc()
          .set(orderModel);
      debugPrint('Order added successfully');
    } catch (e) {
      debugPrint('Error creating order: $e');
    }
  }

  /// Retrieves the list of past orders for a user.
  ///
  /// Takes a [userId] to specify which user's orders to fetch. It returns a list of maps
  /// containing the order details obtained from the Firestore collection 'Past Orders'
  /// for the specified user.
  ///
  /// Returns an empty list if an error occurs or no orders are found.
  Future<List<Map<String, dynamic>>> getUserOrders(String userId) async {
    try {
      QuerySnapshot snapshot =
          await _orderCollection.doc(userId).collection('Past Orders').get();
      debugPrint('Orders fetched successfully');
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      debugPrint('Error fetching user orders: $e');
      return [];
    }
  }
}
