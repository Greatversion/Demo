

import 'package:flutter/material.dart';
import 'package:mambo/models/Database%20models/wishlist_model.dart';
import 'package:mambo/models/Network%20models/product_model.dart';
import 'package:mambo/services/Database%20Functions/wishlist_service.dart';
import 'package:mambo/services/Network%20Functions/search_service.dart';
// import 'package:mambo/services/woo_commerce_service.dart';

/// [SearchProvider] manages the state and logic for searching and filtering products and wishlist items.
/// It interacts with [SearchService] for fetching products and [WishListService] for managing wishlist operations.
class SearchProvider with ChangeNotifier {
  final WishListService _wishListService = WishListService(); // Service for wishlist operations.
  final SearchService _wooCommerceService = SearchService(); // Service for searching products.
  
  List<ProductModel> _products = []; // List of all fetched products.
  List<ProductModel> _filteredProducts = []; // List of products filtered based on search query.
  List<WishListModel> _wishlist = []; // List of all fetched wishlist items.
  List<WishListModel> _filteredWishlist = []; // List of wishlist items filtered based on search query.
  bool _isLoading = false; // Indicates whether a loading operation is in progress.
  String _errorMessage = ''; // Stores error messages.

  /// Returns the list of all products.
  List<ProductModel> get products => _products;

  /// Returns the list of filtered wishlist items.
  List<WishListModel> get wishlist => _filteredWishlist;

  /// Returns the list of filtered products.
  List<ProductModel> get filteredProducts => _filteredProducts;

  /// Returns whether a loading operation is in progress.
  bool get isLoading => _isLoading;

  /// Returns the current error message.
  String get errorMessage => _errorMessage;

  /// Searches for products based on the given [query].
  /// Updates the [_products] and [_filteredProducts] lists.
  Future<void> searchProducts(String query) async {
    _isLoading = true;
    notifyListeners(); // Notify listeners that loading has started.

    try {
      _products = await _wooCommerceService.searchProducts(query);
      _filteredProducts = _products; // Initialize filtered list with all products.
    } catch (e) {
      _errorMessage = e.toString(); // Store error message if an exception occurs.
    } finally {
      _isLoading = false;
      notifyListeners(); // Notify listeners that loading has finished.
    }
  }

  /// Filters the [_products] list based on the given [query].
  /// Updates the [_filteredProducts] list.
  void filterProducts(String query) {
    if (query.isEmpty) {
      _filteredProducts = _products; // Show all products if query is empty.
    } else {
      _filteredProducts = _products.where((product) {
        final productName = product.name!.toLowerCase();
        return productName.contains(query.toLowerCase());
      }).toList(); // Filter products based on the query.
    }
    notifyListeners(); // Notify listeners that filtered data has changed.
  }

  /// Fetches the user's wishlist from the wishlist service.
  /// Updates the [_wishlist] and [_filteredWishlist] lists.
  Future<void> fetchWishlist() async {
    _isLoading = true;
    notifyListeners(); // Notify listeners that loading has started.
    
    try {
      _wishlist = await _wishListService.getUserWishlist(_wishListService.auth.currentUser!.email!);
      _filteredWishlist = _wishlist; // Initialize filtered wishlist with all items.
      _errorMessage = ''; // Clear any previous error messages.
    } catch (e) {
      _errorMessage = 'Error fetching wishlist: $e'; // Store error message if an exception occurs.
    } finally {
      _isLoading = false;
      notifyListeners(); // Notify listeners that loading has finished.
    }
  }

  /// Filters the [_wishlist] list based on the given [query].
  /// Updates the [_filteredWishlist] list.
  void filterWishlist(String query) {
    if (query.isEmpty) {
      _filteredWishlist = _wishlist; // Show all wishlist items if query is empty.
    } else {
      _filteredWishlist = _wishlist.where((item) {
        return item.product!.productName!.toLowerCase().contains(query.toLowerCase());
      }).toList(); // Filter wishlist items based on the query.
    }
    notifyListeners(); // Notify listeners that filtered data has changed.
  }
}
