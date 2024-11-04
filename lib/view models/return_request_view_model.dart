

import 'package:flutter/material.dart';
import 'package:mambo/services/Network%20Functions/return_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// [ReturnRequestViewModel] manages the state and logic for handling return requests.
/// It interacts with the [ReturnService] to send return requests and updates the return status.
class ReturnRequestViewModel extends ChangeNotifier {
  final ReturnService _returnService = ReturnService(); // Service for handling return requests.
  bool _isLoading = false; // Indicates whether a loading operation is in progress.
  Map<String, bool> _isRequestSentMap = {}; // Maps order IDs to whether a return request has been sent.

  /// Returns whether a loading operation is in progress.
  bool get isLoading => _isLoading;

  /// Constructor initializes the ViewModel by loading the return statuses.
  ReturnRequestViewModel() {
    _loadReturnStatus(); // Load return status on initialization.
  }

  /// Checks if a return request has been sent for a specific order.
  ///
  /// [orderId] - The ID of the order to check.
  /// Returns true if a return request has been sent, otherwise false.
  bool isRequestSent(String orderId) {
    return _isRequestSentMap[orderId] ?? false;
  }

  /// Sends a return request for a specific order.
  ///
  /// [orderId] - The ID of the order to request a return for.
  /// [note] - A note to be added to the return request.
  /// [status] - The status to update for the return request.
  Future<void> requestReturn(String orderId, String note, String status) async {
    _isLoading = true;
    notifyListeners(); // Notify listeners that loading has started.

    try {
      // Send the return request and update the return status.
      final response = await _returnService.addOrderNote(orderId, note);
      final response2 = await _returnService.updateReturnStatus(orderId, status);

      // Check if both requests were successful.
      if (response.statusCode == 201 && response2.statusCode == 200) {
        debugPrint('Return Request sent successfully');
        _isRequestSentMap[orderId] = true; // Update the map to reflect the successful request.
        _saveReturnStatus(); // Save the updated return statuses.
      }
    } catch (e) {
      debugPrint(e.toString()); // Log errors.
    } finally {
      _isLoading = false;
      notifyListeners(); // Notify listeners that loading has finished.
    }
  }

  /// Saves the current return statuses to persistent storage.
  Future<void> _saveReturnStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('return_status', _isRequestSentMap.keys.join(',')); // Save order IDs with sent requests.
  }

  /// Loads the return statuses from persistent storage.
  Future<void> _loadReturnStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedStatus = prefs.getString('return_status'); // Retrieve the saved order IDs.

    if (savedStatus != null && savedStatus.isNotEmpty) {
      List<String> orderIds = savedStatus.split(','); // Split the saved string into individual order IDs.
      for (String orderId in orderIds) {
        _isRequestSentMap[orderId] = true; // Update the map with the saved statuses.
      }
      notifyListeners(); // Notify listeners that the data has changed.
    }
  }
}
