

import 'package:flutter/material.dart';
import 'package:mambo/providers/quantity_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mambo/models/Database%20models/cart_model.dart';
import 'package:mambo/services/Database%20Functions/cart_service.dart';

/// [CartViewModel] is a [ChangeNotifier] class that manages the state of
/// the user's shopping cart. It interacts with the [CartService] to perform
/// CRUD operations on the cart items and provides methods to manage cart items
/// within the app's UI.
class CartViewModel extends ChangeNotifier {
  // Service instance for handling cart-related operations.
  final CartService _cartService = CartService();

  // Boolean flag to indicate if an item is added to the cart.
  bool _isAdded = false;

  // Total price of all items in the cart.
  double _totalPrice = 0.0;

  // Set to store product IDs of items in the cart.
  Set<String> _cartProductIds = {};

  // List to store the user's cart items fetched from the database.
  List<ProductCartModel> _userCart = [];

  // String to store error messages in case of failures.
  String _errorMessage = '';

  // Boolean flag to indicate if a loading operation is in progress.
  bool _isLoading = false;

  // Getters to access the private properties.
  bool get isAdded => _isAdded;
  double get totalPrice => _totalPrice;
  List<ProductCartModel> get userCart => _userCart;
  String get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  // Constructor to load cart products from SharedPreferences.
  CartViewModel() {
    _loadCartProducts();
  }

  /// Loads cart products from [SharedPreferences] to retain cart state
  /// between app sessions.
  Future<void> _loadCartProducts() async {
    final prefs = await SharedPreferences.getInstance();
    _cartProductIds = prefs.getStringList('cartProducts')?.toSet() ?? {};
    notifyListeners();
  }

  /// Saves cart products to [SharedPreferences] to maintain the cart state
  /// for future sessions.
  Future<void> _saveCartProducts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('cartProducts', _cartProductIds.toList());
  }

  /// Adds an item to the user's cart. It updates the local cart state,
  /// saves the cart state in [SharedPreferences], and adds the item to the
  /// database using [CartService].
  ///
  /// [cartItem] The cart item to be added.
  Future<void> addItemInCart(ProductCartModel cartItem) async {
    _isLoading = true;  // Set loading state to true while adding an item.
    notifyListeners();
    try {
      // Add product ID to the cart products set.
      _cartProductIds.add(cartItem.productID.toString());

      // Add the item to the cart in the database.
      await _cartService.addItemInCart(cartItem);

      // Save cart products to SharedPreferences.
      await _saveCartProducts();

      // Add item to the local cart list.
      _userCart.add(cartItem);

      // Recalculate the total price of items in the cart.
      _calculateTotalPrice();
    } catch (e) {
      // Log and store error message if adding to cart fails.
      _errorMessage = 'Error adding cart item: $e';
      debugPrint(e.toString());
    } finally {
      _isLoading = false;  // Reset loading state after operation is complete.
      notifyListeners();  // Notify listeners to update the UI.
    }
  }

  /// Deletes an item from the user's cart. It updates the local cart state,
  /// removes the item from [SharedPreferences], and deletes the item from
  /// the database using [CartService].
  ///
  /// [productID] The ID of the product to be removed.
  Future<void> deleteCartItem(String productID) async {
    try {
      // Remove product ID from the cart products set.
      _cartProductIds.remove(productID);

      // Delete the item from the cart in the database.
      await _cartService.deleteCartItem(productID);

      // Remove the item from the local cart list.
      _userCart.removeWhere((item) => item.productID.toString() == productID);

      // Recalculate the total price of items in the cart.
      _calculateTotalPrice();

      // Save cart products to SharedPreferences.
      await _saveCartProducts();

      notifyListeners();  // Notify listeners to update the UI.
    } catch (e) {
      // Log and store error message if deleting from cart fails.
      _errorMessage = 'Error deleting cart item: $e';
      notifyListeners();  // Notify listeners to update the UI.
    }
  }

  /// Fetches the user's cart items from the database and updates the local cart state.
  /// It also syncs the quantity of each item with the [QuantityProvider].
  ///
  /// [context] The build context used to access the [QuantityProvider].
  /// [userId] The ID of the user whose cart is to be fetched.
  Future<void> getUserCart(BuildContext context, String userId) async {
    _isLoading = true;  // Set loading state to true while fetching data.
    _errorMessage = '';  // Reset error message.
    notifyListeners();

    try {
      // Fetch user cart from the database.
      _userCart = await _cartService.getUserCart(userId);

      // Recalculate the total price of items in the cart.
      _calculateTotalPrice();

      // Update quantities in the QuantityProvider.
      final quantityProvider =
          Provider.of<QuantityProvider>(context, listen: false);
      for (var item in _userCart) {
        quantityProvider.setQuantity(item.productID.toString(), item.quantity);
      }
    } catch (e) {
      // Log and store error message if fetching cart items fails.
      _errorMessage = 'Error fetching cart items: $e';
    } finally {
      _isLoading = false;  // Reset loading state after operation is complete.
      notifyListeners();  // Notify listeners to update the UI.
    }
  }

  /// Checks if a specific item is in the user's cart.
  ///
  /// [productId] The ID of the product to check.
  /// Returns `true` if the product is in the cart, otherwise `false`.
  bool isItemInCart(String productId) {
    return _cartProductIds.contains(productId);
  }

  /// Calculates the total price of all items in the user's cart.
  /// It loops through all items in the cart, multiplies their prices
  /// by their quantities, and sums them up.
  void _calculateTotalPrice() {
    double total = 0.0;
    for (var item in _userCart) {
      try {
        // Parse item price and quantity to calculate total.
        double itemPrice = double.parse(item.productPrice.toString());
        int itemQuantity = int.parse(item.quantity.toString());
        total += itemPrice * itemQuantity;
      } catch (e) {
        // Log error if parsing item price or quantity fails.
        debugPrint('Error parsing item price or quantity: $e');
      }
    }
    _totalPrice = total;  // Update the total price.
    notifyListeners();  // Notify listeners to update the UI.
  }

  /// Updates the selected attributes of a cart item in the database and locally.
  ///
  /// [productId] The ID of the product to update.
  /// [selectedAttributes] The new selected attributes to set for the item.
  Future<void> updateSelectedAttributes(
      int productId, Map<String, String> selectedAttributes) async {
    try {
      // Update the selected attributes in the database.
      await _cartService.updateCartItemField(
          productId, 'selectedAttributes', selectedAttributes);

      // Update the local cart model.
      final index = _userCart.indexWhere((item) => item.productID == productId);
      if (index != -1) {
        _userCart[index].selectedAttributes = selectedAttributes;
        notifyListeners();  // Notify listeners to update the UI.
      } else {
        _errorMessage = 'Cart item not found';  // Set error if item is not found.
        notifyListeners();
      }
    } catch (e) {
      // Log and store error message if updating attributes fails.
      _errorMessage = 'Error updating selected attributes: $e';
      notifyListeners();  // Notify listeners to update the UI.
    }
  }

  /// Updates the quantity of a specific product in the user's cart.
  /// It updates the quantity in the database and updates the local model.
  ///
  /// [productId] The ID of the product to update.
  /// [quantity] The new quantity to set for the product.
  Future<void> updateProductQuantity(String productId, int quantity) async {
    try {
      // Update the product quantity in the database.
      await _cartService.updateProductQuantity(productId, quantity);

      // Update the local cart model.
      final index = _userCart
          .indexWhere((item) => item.productID.toString() == productId);
      if (index != -1) {
        _userCart[index].quantity = quantity;
        _calculateTotalPrice();  // Recalculate the total price.
        notifyListeners();  // Notify listeners to update the UI.
      } else {
        _errorMessage = 'Cart item not found';  // Set error if item is not found.
        notifyListeners();
      }
    } catch (e) {
      // Log and store error message if updating product quantity fails.
      _errorMessage = 'Error updating product quantity: $e';
      notifyListeners();  // Notify listeners to update the UI.
    }
  }
}
