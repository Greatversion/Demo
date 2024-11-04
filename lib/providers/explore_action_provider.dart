import 'package:flutter/material.dart';

class ExploreactionProvider with ChangeNotifier {
  bool _isExploreButtonTapped = false;
  bool get isExploreButtonTapped => _isExploreButtonTapped;
  void exploreAllButtonTapped() {
    _isExploreButtonTapped = true;
    notifyListeners();
  }
}