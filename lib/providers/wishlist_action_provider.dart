import 'package:flutter/material.dart';

class WishlistactionProvider with ChangeNotifier {
  bool _isSelected = false;
  int _currentInd = -9999;

  bool get isSelected => _isSelected;
  int get currentInd => _currentInd;

  void selectProduct(int index) {
    _isSelected = true;
    _currentInd = index;
    notifyListeners();
  }

  void deSelectProduct() {
    _isSelected = false;
    _currentInd = -9999; // Reset the index when deselecting
    notifyListeners();
  }

  void setCurrentIndex(int index) {
    _currentInd = index;
    notifyListeners();
  }

  void resetSelection() {
    _isSelected = false;
    _currentInd = -9999;
    notifyListeners();
  }
}
