import 'package:flutter/material.dart';
import 'package:mambo/routes/app.nameRoutes.dart';
import 'package:mambo/utils/Error%20Messages/error_widget.dart';
import 'package:mambo/utils/Search_Bar/product_search_screen.dart';
import 'package:mambo/utils/Search_Bar/wishlist_search_screen.dart';
import 'package:mambo/views/Screens/payment_screen.dart';
import 'package:mambo/views/Screens/return_screen.dart';
import 'package:mambo/views/Screens/saved_address_screen.dart';
import 'package:mambo/views/Screens/category_screen.dart';
import 'package:mambo/views/Screens/add_address_screen.dart';
import 'package:mambo/views/Screens/past_orders_screen.dart';

import 'package:mambo/views/Authentication/login_screen.dart';
import 'package:mambo/views/Screens/cart_screen.dart';
import 'package:mambo/views/Screens/checkout_screen.dart';
import 'package:mambo/views/Screens/explore_screen.dart';
import 'package:mambo/views/Home/main_screen.dart';
import 'package:mambo/views/Screens/product_screen.dart';
import 'package:mambo/views/Screens/test_screen.dart';
import 'package:mambo/views/Screens/welcome_screen.dart';
import 'package:mambo/views/Screens/wishlist_screen.dart';
import 'package:mambo/views/screens/User_Profile/profile_screen.dart';
import 'package:mambo/views/screens/account_screen.dart';

import '../views/Screens/shop_screen.dart';

ErrorMessages errorMessages = ErrorMessages();

class AppRoutes {
  static PageRoute? generatedRoute(RouteSettings settings) {
    switch (settings.name) {
      // Splash Decider...
      case RoutesName.splashDecider:
        return MaterialPageRoute(
          builder: (context) => const SplashDecider(),
        );
      // Login Screen...
      case RoutesName.loginScreen:
        return MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        );
      // Welcome Screen...
      // case RoutesName.welcome:
      //   final auth = FirebaseAuth.instance;
      //   return MaterialPageRoute(
      //     builder: (context) => WelcomeScreen(
      //       name: auth.currentUser!.displayName!,
      //     ),
      //   );
      // Main UI or Swipable Screen...
      case RoutesName.mainUi:
        // final args = settings.arguments as Map<String, dynamic>?;

        return MaterialPageRoute(
          builder: (context) => const MainUI(),
        );

      // Explore Screen...
      case RoutesName.exploreScreen:
        return NoAnimationPageRoute(
          builder: (context) => const ExploreScreen(),
        );
      case RoutesName.paymentSuccess:
        return NoAnimationPageRoute(
          builder: (context) => const PaymentSuccessScreen(),
        );
      case RoutesName.wishlistScreen:
        return NoAnimationPageRoute(
          builder: (context) => const WishListScreen(),
        );

      case RoutesName.cartScreen:
        return NoAnimationPageRoute(
          builder: (context) => const CartScreen(),
        );
      case RoutesName.productScreen:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => ProductScreen(
            isPushedFromReelScreen: args["isPushedFromReelScreen"] ?? false,
            productID: args['productID'] ?? 0,
            index: args['index'],
            screenName: args["screenName"] ?? '',
          ),
        );
      case RoutesName.accountScreen:
        return NoAnimationPageRoute(
          builder: (context) => const AccountScreen(),
        );

      case RoutesName.checkoutScreen:
        return MaterialPageRoute(
          builder: (context) => const CheckoutScreen(),
        );
      case RoutesName.swipeExamplePage:
        return MaterialPageRoute(
          builder: (context) => const SwipeExamplePage(),
        );

      // Route for the user profile screen
      case RoutesName.userProfileScreen:
        return MaterialPageRoute(
          builder: (context) => const UserProfileScreen(),
        );

      case RoutesName.categoryScreen:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => CategoryScreen(
            categoryName: args["categoryName"].toString(),
            index: args["index"],
            categoryID: args['categoryID'],
          ),
        );
      case RoutesName.shopScreen:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => ShopScreen(
            vendorId: args['vendorId'],
            index: args['index'],
          ),
        );
      case RoutesName.returnScreen:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => ReturnScreen(
            productID: args["productID"].toString(),
            orderID: args["orderID"].toString(),
            productName: args["productName"].toString(),
          ),
        );
      case RoutesName.addAddress:
        return MaterialPageRoute(
          builder: (context) => const NewAddressScreen(),
        );
      case RoutesName.address:
        return MaterialPageRoute(
          builder: (context) => const AddressScreen(),
        );
      case RoutesName.pastOrder:
        return MaterialPageRoute(
          builder: (context) => const PastOrderScreen(),
        );
      case RoutesName.productSearchScreen:
        return NoAnimationPageRoute(
          builder: (context) => const ProductSearchScreen(),
        );
      case RoutesName.wishlistSearchScreen:
        return NoAnimationPageRoute(
          builder: (context) => const WishlistSearchScreen(),
        );
      default:
        return NoAnimationPageRoute(
          builder: (context) => Scaffold(
            body: Center(
              child: ErrorDisplayWidget(
                msg: errorMessages.generalErrorPageError().message,
                desc: errorMessages.generalErrorPageError().description,
              ),
            ),
          ),
        );
    }
  }
}

class NoAnimationPageRoute<T> extends PageRouteBuilder<T> {
  final WidgetBuilder builder;
  NoAnimationPageRoute({required this.builder})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) =>
              builder(context),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        );
}
