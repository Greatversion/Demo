import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:mambo/routes/app.nameRoutes.dart';

class NavBarProvider with ChangeNotifier {
  int _currentPageIndex = 0;
  int get currentPageIndex => _currentPageIndex;

  void tapOnNavBarItem(int index, BuildContext context) {
    if (index != _currentPageIndex) {
      _currentPageIndex = index;
      log('$_currentPageIndex');
      navigateToPage(_currentPageIndex, context);
      notifyListeners();
    }
  }

  void navigateToPage(int index, BuildContext context) {
    switch (index) {
      // MainUI or Home or Reels Screen
      case 0:
        Navigator.pushReplacementNamed(context, RoutesName.mainUi);
        break;
      // Explore Screen
      case 1:
        Navigator.pushReplacementNamed(context, RoutesName.exploreScreen);
        break;
      // Wishlist Screen
      case 2:
        Navigator.pushReplacementNamed(context, RoutesName.wishlistScreen);
        break;
      // Cart Screen
      case 3:
        Navigator.pushReplacementNamed(context, RoutesName.cartScreen);
        break;
      // Profile Screen
      case 4:
        Navigator.pushReplacementNamed(context, RoutesName.accountScreen);
        break;
      default:
        Navigator.pushReplacementNamed(context, RoutesName.mainUi);
    }
  }
}
