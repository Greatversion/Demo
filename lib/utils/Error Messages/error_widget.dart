// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:mambo/utils/app.colors.dart';

class ErrorData {
  final String message;
  final String description;
  final IconData icon;

  ErrorData(
      {required this.message, required this.description, required this.icon});
}

class ErrorMessages {
  final SizedBox errorLogo = SizedBox(
      height: 60, width: 60, child: Image.asset("assets/images/errorlogo.png"));
  ErrorData homeScreenError() {
    return ErrorData(
      message: "Oops! No reels to show right now.",
      description: "Check back soon for new products!",
      icon: Icons.hourglass_empty,
    );
  }

  ErrorData wishlistError() {
    return ErrorData(
      message: "Your wishlist is looking a bit lonely!",
      description: "Start exploring and save the things you love!",
      icon: Icons.favorite_border,
    );
  }

  ErrorData cartPageError() {
    return ErrorData(
      message: "Your cart is currently empty.",
      description: "Fill your cart with awesome finds NOW!",
      icon: Icons.shopping_cart,
    );
  }

  ErrorData productPageError() {
    return ErrorData(
      message: "Whoops! This product seems to be missing.",
      description: "It might be out of stock or removed.",
      icon: Icons.warning,
    );
  }

  ErrorData checkoutPageError() {
    return ErrorData(
      message: "Uh-oh, No products for Checkout.",
      description: "Please add something to Cart for checkout.",
      icon: Icons.error,
    );
  }

  ErrorData profilePageError() {
    return ErrorData(
      message: "You haven't made any purchases yet!",
      description: "Start shopping to view your orders here.",
      icon: Icons.book,
    );
  }

  ErrorData notificationsError() {
    return ErrorData(
      message: "No new notifications.",
      description: "Check back later for updates.",
      icon: Icons.notifications_none,
    );
  }

  ErrorData searchResultsError() {
    return ErrorData(
      message: "Oops! We couldn't find any results.",
      description: "Try different keywords or browse categories.",
      icon: Icons.search,
    );
  }

  ErrorData checkoutAddressPageError() {
    return ErrorData(
      message: "No addresses saved.",
      description: "Add an address to proceed with checkout.",
      icon: Icons.location_city,
    );
  }

  ErrorData generalErrorPageError() {
    var errorData = ErrorData(
      message: "Something went wrong.",
      description: "Please refresh or try again later.",
      icon: Icons.refresh,
    );
    return errorData;
  }
}

class ErrorDisplayWidget extends StatelessWidget {
  final String msg;
  final String desc;
  const ErrorDisplayWidget({
    super.key,
    required this.msg,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    ErrorMessages errorMessages = ErrorMessages();
    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          errorMessages.errorLogo,
          const SizedBox(height: 10),
          Text(
            msg,
            style: const TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(
            desc.toUpperCase(),
            style: const TextStyle(
                color: Color.fromARGB(255, 120, 120, 120),
                fontSize: 12,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
