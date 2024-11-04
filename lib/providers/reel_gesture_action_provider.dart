import 'package:flutter/material.dart';

class ReelGestureActionProvider with ChangeNotifier {
  bool _isDobleTapped = false;
  bool get isDobleTapped => _isDobleTapped;
  void addToWishList() {
    _isDobleTapped = true;
    notifyListeners();
  }

  void removeFromWishList() {
    if (isDobleTapped) {
      _isDobleTapped = false;
    }
    notifyListeners();
  }
}