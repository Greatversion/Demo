
import 'package:flutter/material.dart';
import 'package:mambo/models/Database%20models/address_model.dart';
import 'package:mambo/services/Database%20Functions/address_service.dart';

/// [AddressViewModel] is a ChangeNotifier class that manages the state of
/// user addresses for the application. It interacts with the [AddressService]
/// to perform CRUD operations on user addresses and provides methods to
/// manage addresses effectively within the app's UI.
class AddressViewModel extends ChangeNotifier {
  // An instance of [AddressService] to perform address-related operations.
  final AddressService _addressService = AddressService();

  // List to store user's saved addresses fetched from the database.
  List<AddressModel> _usersavedAddresses = [];

  // String to store error messages in case of failures.
  String _errorMessage = '';

  // Boolean flag to indicate if a loading operation is in progress.
  bool _isLoading = false;

  // Public getter to access the list of user's saved addresses.
  List<AddressModel> get usersavedAddresses => _usersavedAddresses;

  // Public getter to access the error message.
  String get errorMessage => _errorMessage;

  // Public getter to check if the loading operation is in progress.
  bool get isLoading => _isLoading;

  /// Adds a new user address to the database using [AddressService].
  /// After the address is added, it notifies listeners to rebuild the UI
  /// to reflect the changes.
  ///
  /// [addressModel] The address model to be added.
  Future<void> addUserAddress(AddressModel addressModel) async {
    await _addressService.addUserAddress(addressModel);
    notifyListeners();  // Notify listeners that the state has changed.
  }

  /// Deletes an existing user address from the database using [AddressService].
  /// After the address is deleted, it notifies listeners to rebuild the UI
  /// to reflect the changes.
  ///
  /// [addressModel] The address model to be deleted.
  Future<void> deleteAddress(AddressModel addressModel) async {
    await _addressService.deleteUserAddress(addressModel);
    notifyListeners();  // Notify listeners that the state has changed.
  }

  /// Fetches the list of addresses associated with a specific user from
  /// the database using [AddressService]. While fetching, it sets the
  /// loading state to true and resets any existing error messages.
  /// If an error occurs during fetching, it sets an error message.
  ///
  /// [userId] The ID of the user whose addresses are to be fetched.
  Future<void> getUerAddresses(String userId) async {
    _isLoading = true;  // Set loading state to true while fetching data.
    _errorMessage = '';  // Reset error message.
    notifyListeners();  // Notify listeners to update the UI.

    try {
      // Fetch user addresses from the database.
      _usersavedAddresses = await _addressService.getUserAddresses(userId);
    } catch (e) {
      // If an error occurs, set the error message.
      _errorMessage = 'Error fetching addresses: $e';
    } finally {
      // Set loading state to false after fetching is complete.
      _isLoading = false;
      notifyListeners();  // Notify listeners to update the UI.
    }
  }
}

