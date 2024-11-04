

import 'package:flutter/material.dart';
import 'package:mambo/services/Database%20Functions/wishlist_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mambo/models/Database%20models/wishlist_model.dart';

/// [WishlistViewModel] manages the state and operations related to the user's wishlist.
/// It handles adding, removing, and retrieving wishlist items and synchronizes with shared preferences.
class WishlistViewModel extends ChangeNotifier {
  final WishListService _wishlistService = WishListService(); // Service for wishlist-related operations.
  bool _isAdded = false; // Indicates whether an item was successfully added.
  bool _isLiked = false; // Indicates whether an item is liked.
  Set<String> _likedProductIds = {}; // Set of liked product IDs.
  List<WishListModel> _userwishlist = []; // List of user's wishlist items.
  bool _isLoading = false; // Indicates whether a loading operation is in progress.
  String? _errorMessage; // Holds error messages if any.

  // Getters for exposing internal state.
  bool get isAdded => _isAdded;
  bool get isLiked => _isLiked;
  List<WishListModel> get userwishlist => _userwishlist;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Constructor that loads liked products from shared preferences when the ViewModel is initialized.
  WishlistViewModel() {
    _loadLikedProducts();
  }

  /// Loads liked product IDs from shared preferences and updates [_likedProductIds].
  Future<void> _loadLikedProducts() async {
    final prefs = await SharedPreferences.getInstance();
    _likedProductIds = prefs.getStringList('likedProducts')?.toSet() ?? {};
    notifyListeners(); // Notify listeners about changes.
  }

  /// Saves liked product IDs to shared preferences and notifies listeners.
  Future<void> _saveLikedProducts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('likedProducts', _likedProductIds.toList());
    notifyListeners(); // Notify listeners about changes.
  }

  /// Adds a new item to the wishlist and updates the state.
  Future<void> createWishlistItem(WishListModel wishlistItem) async {
    _setLoading(true); // Start loading.
    try {
      _isAdded = true; // Set the added state to true.
      _likedProductIds.add(wishlistItem.product!.productId!.toString()); // Add product ID to liked set.
      await _wishlistService.createWishlistItem(wishlistItem); // Create wishlist item in the service.
      await _saveLikedProducts(); // Save the updated liked products to shared preferences.
    } catch (e) {
      _setErrorMessage(e.toString()); // Set error message if operation fails.
    } finally {
      _setLoading(false); // End loading.
    }
  }

  /// Removes an item from the wishlist and updates the state.
  Future<void> deleteWishlistItem(WishListModel wishlistItem) async {
    _setLoading(true); // Start loading.
    _isAdded = false; // Set the added state to false.
    try {
      _userwishlist.removeWhere(
          (item) => item.product!.productId == wishlistItem.product!.productId); // Remove item locally.

      _likedProductIds.remove(wishlistItem.product!.productId!.toString()); // Remove product ID from liked set.

      await _wishlistService.deleteWishlistItem(wishlistItem); // Delete wishlist item from the service.
      await _saveLikedProducts(); // Save the updated liked products to shared preferences.
    } catch (e) {
      _setErrorMessage(e.toString()); // Set error message if operation fails.
    } finally {
      _setLoading(false); // End loading.
    }
  }

  /// Fetches the user's wishlist based on the provided [userId].
  Future<void> getUserWishlist(String userId) async {
    _setLoading(true); // Start loading.
    try {
      _userwishlist = await _wishlistService.getUserWishlist(userId); // Fetch wishlist items from the service.
      notifyListeners(); // Notify listeners about changes.
    } catch (e) {
      _setErrorMessage(e.toString()); // Set error message if operation fails.
    } finally {
      _setLoading(false); // End loading.
    }
  }

  /// Checks if a product with the given [productId] is in the wishlist.
  bool isItemInWishlist(String productId) {
    return _likedProductIds.contains(productId); // Check if product ID is in the liked set.
  }

  /// Updates the [_isLiked] state and notifies listeners.
  void updateIsLiked(bool value) {
    _isLiked = value;
    notifyListeners(); // Notify listeners about changes.
  }

  /// Sets the loading state and notifies listeners.
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners(); // Notify listeners about changes.
  }

  /// Sets the error message and notifies listeners.
  void _setErrorMessage(String message) {
    _errorMessage = message;
    notifyListeners(); // Notify listeners about changes.
  }

  /// Clears the error message and notifies listeners.
  void clearErrorMessage() {
    _errorMessage = null;
    notifyListeners(); // Notify listeners about changes.
  }
}
