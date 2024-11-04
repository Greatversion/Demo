

import 'package:flutter/material.dart';
import 'package:mambo/models/Database%20models/order_model.dart';
import 'package:mambo/services/Database%20Functions/past_order_services.dart';
import 'package:mambo/services/Network%20Functions/order_service.dart';

/// [OrderViewModel] is a [ChangeNotifier] class responsible for managing
/// the state of orders, including creating, adding, and fetching past orders.
class OrderViewModel extends ChangeNotifier {
  // Initialization of Services
  final OrderService orderService = OrderService(); // Service for creating orders through WooCommerce/Dokan APIs.
  final PastOrderService pastOrderService = PastOrderService(); // Service for managing past orders in Firestore.

// Initialization of variables to manage state and data.
  String _errorMessage = ''; // Stores error messages encountered during operations.
  bool _isLoading = false; // Indicates whether a loading operation is in progress.

  // List to store response data received from services.
  List<Map<String, dynamic>> _responseData = [];
  
  // List to store past orders fetched from Firestore.
  final List<Map<String, dynamic>> _pastOrders = [];
  
  // Map to store the response of order creation.
  Map<String, dynamic> _response = {};

  // Getter methods for accessing private variables.
  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> get pastOrders => _pastOrders;
  List<Map<String, dynamic>> get responseData => _responseData;
  Map<String, dynamic> get response => _response;
  String get errorMessage => _errorMessage;

  /// Creates an order using WooCommerce/Dokan APIs and updates the local state.
  /// [order] The [OrderModel] to be created.
  Future<void> createOrder(OrderModel order) async {
    _isLoading = true; // Set loading state to true.
    _errorMessage = ''; // Clear any existing error message.
    notifyListeners(); // Notify listeners to update the UI.

    try {
      // Attempt to create an order using the orderService.
      _response = await orderService.createOrder(order);
      debugPrint('Order created: $_response'); // Log the created order response.
    } catch (e) {
      // If an error occurs, capture and log the error message.
      debugPrint('ERROR:');
      _errorMessage = e.toString();
      debugPrint(_errorMessage);
    } finally {
      _isLoading = false; // Reset loading state after operation.
      notifyListeners(); // Notify listeners to update the UI.
    }
  }

  /// Adds the response of a successfully created order to Firestore.
  /// [orderModel] A map representation of the order data to be added.
  Future<void> addOrder(Map<String, dynamic> orderModel) async {
    _isLoading = true; // Set loading state to true.
    _errorMessage = ''; // Clear any existing error message.
    notifyListeners(); // Notify listeners to update the UI.

    try {
      // Attempt to add the order data to Firestore using the pastOrderService.
      await pastOrderService.addOrder(orderModel);
      debugPrint('Order created in FireBase.'); // Log successful addition.
    } catch (e) {
      // If an error occurs, capture and log the error message.
      debugPrint('ERROR:');
      _errorMessage = e.toString();
      debugPrint(_errorMessage);
    } finally {
      _isLoading = false; // Reset loading state after operation.
      notifyListeners(); // Notify listeners to update the UI.
    }
  }

  /// Fetches past orders for a specific user from Firestore and updates the local state.
  /// [userId] The ID of the user for whom to fetch past orders.
  Future<void> getUserOrders(String userId) async {
    _isLoading = true; // Set loading state to true.
    _errorMessage = ''; // Clear any existing error message.
    _pastOrders.clear(); // Clear the current list of past orders.
    notifyListeners(); // Notify listeners to update the UI.

    try {
      // Attempt to fetch past orders from Firestore using the pastOrderService.
      _responseData = await pastOrderService.getUserOrders(userId);

      // Iterate through fetched order data to extract line items.
      for (var pastorderData in _responseData) {
        for (var eachOrderData in pastorderData["line_items"]) {
          _pastOrders.add(eachOrderData); // Add each line item to the local list.
        }
      }
    } catch (e) {
      // If an error occurs, capture the error message.
      _errorMessage = 'Error fetching past orders: $e';
    } finally {
      _isLoading = false; // Reset loading state after operation.
      notifyListeners(); // Notify listeners to update the UI.
    }
  }
}
