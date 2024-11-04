import 'package:flutter/material.dart';



class SelectedAddressProvider with ChangeNotifier {
  Map<String, String> _selectedAddress = {};

  Map<String, String> get selectedAddress => _selectedAddress;

  void setSelectedAddress(Map<String, String> address) {
    _selectedAddress = address;
    notifyListeners();
  }
}
