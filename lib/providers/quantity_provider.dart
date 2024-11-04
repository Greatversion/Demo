// import 'package:flutter/material.dart';
// import 'package:mambo/services/Database%20Functions/cart_service.dart';
// import 'package:mambo/view%20models/cart_view_model.dart';

// class QuantityProvider with ChangeNotifier {
//   final Map<String, int> _quantities = {};


//   int getQuantity(String productId) => _quantities[productId] ?? 1 ;

//   void increaseQty(String productId) {
//     _quantities[productId] = (getQuantity(productId) + 1);
//     notifyListeners();
//   }

//   void decreaseQty(String productId) {
//     if (getQuantity(productId) > 1) {
//       _quantities[productId] = (getQuantity(productId) - 1);
//       notifyListeners();
//     }
//   }

//   void setQuantity(String productId, int quantity) {
//     if (quantity > 0) {
//       _quantities[productId] = quantity;
//       notifyListeners();
//     }
//   }
// }

import 'package:flutter/material.dart';

class QuantityProvider with ChangeNotifier {
  // A Map to hold product quantities with the product ID as the key
  final Map<String, int> _quantities = {};

  // Getter method to get the quantity of a specific product
  int getQuantity(String productId) => _quantities[productId] ?? 1;

  // Method to increase the quantity of a specific product by 1
  void increaseQty(String productId) {
    _quantities[productId] = (getQuantity(productId) + 1);
    notifyListeners(); // Notify listeners about the change
  }

  // Method to decrease the quantity of a specific product by 1
  void decreaseQty(String productId) {
    if (getQuantity(productId) > 1) {
      _quantities[productId] = (getQuantity(productId) - 1);
      notifyListeners(); // Notify listeners about the change
    }
  }

  // Method to set a specific quantity for a product
  void setQuantity(String productId, int quantity) {
    if (quantity > 0) {
      _quantities[productId] = quantity;
      notifyListeners(); // Notify listeners about the change
    }
  }

  // Method to reset the quantity of a specific product to its default value
  void resetQuantity(String productId) {
    _quantities[productId] = 1; // Reset to default quantity (e.g., 1)
    notifyListeners(); // Notify listeners about the change
  }

  // Method to reset all product quantities to their default values
  void resetAllQuantities() {
    _quantities.clear(); // Clear all quantities
    notifyListeners(); // Notify listeners about the change
  }
}
