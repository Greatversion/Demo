import 'package:flutter/material.dart';
import 'package:mambo/Services/Network%20Functions/vendor_services.dart';
import 'package:mambo/models/Network%20models/product_model.dart';
import '../models/Network%20models/vendors_model.dart';

/// [VendorProvider] manages the state and logic related to vendors and their products.
/// It interacts with [VendorService] to fetch vendor and product data and apply various filters.
class VendorProvider extends ChangeNotifier {
  final VendorService _vendorService =
      VendorService(); // Service for vendor-related operations.
  bool _isLoading =
      false; // Indicates whether a loading operation is in progress.
  Vendors? _vendor; // Currently selected vendor.
  List<ProductModel> _vendorProducts =
      []; // List of products from the currently selected vendor.
  List<ProductModel> _filteredProducts =
      []; // List of products filtered based on search criteria.
  List<Vendors> _allvendors = []; // List of all vendors.

  /// Returns whether a loading operation is in progress.
  bool get isLoading => _isLoading;

  /// Returns the list of products from the currently selected vendor.
  List<ProductModel> get vendorProducts => _vendorProducts;

  /// Returns the list of all vendors.
  List<Vendors> get allvendors => _allvendors;

  /// Returns the list of filtered products.
  List<ProductModel> get filteredProducts => _filteredProducts;

  /// Returns the currently selected vendor.
  Vendors? get vendor => _vendor;

  /// Fetches the list of all vendors and updates [_allvendors].
  Future<void> fetchVendors() async {
    _isLoading = true;
    notifyListeners(); // Notify listeners that loading has started.

    try {
      _allvendors.clear(); // Clear existing vendor list.
      _allvendors = await _vendorService
          .fetchVendors(); // Fetch vendors from the service.
    } catch (e) {
      debugPrint(e.toString()); // Log any errors.
    } finally {
      _isLoading = false;
      notifyListeners(); // Notify listeners that loading has finished.
    }
  }

  /// Fetches a vendor by its [vendorId] and updates [_vendor].
  Future<void> fetchVendorById(int vendorId) async {
    _isLoading = true;
    notifyListeners(); // Notify listeners that loading has started.

    try {
      _vendor = null; // Clear the current vendor.
      _vendor = await _vendorService
          .fetchVendorById(vendorId); // Fetch vendor from the service.
    } catch (e) {
      debugPrint(e.toString()); // Log any errors.
    } finally {
      _isLoading = false;
      notifyListeners(); // Notify listeners that loading has finished.
    }
  }

  /// Fetches products from the vendor with [vendorId] and updates [_vendorProducts] and [_filteredProducts].
  Future<void> fetchProductsByVendor(int vendorId) async {
    _isLoading = true;
    notifyListeners(); // Notify listeners that loading has started.

    try {
    
      _vendorProducts.clear(); // Clear existing product list.
      _filteredProducts.clear(); // Clear filtered products list.
      _vendorProducts = await _vendorService
          .fetchProductsByVendor(vendorId); // Fetch products from the service.
    
      _filteredProducts = List.from(
          _vendorProducts); // Initialize filtered products with all vendor products.
    
    } catch (e) {
      debugPrint(e.toString()); // Log any errors.
    } finally {
      _isLoading = false;
      notifyListeners(); // Notify listeners that loading has finished.
    }
  }

  /// Filters [_filteredProducts] based on the given [priceRange] map.
  /// The map should contain 'min' and 'max' keys for price range.

  // Get filtered products by price range
  // Clear filtered products and reset to full list

  // Reset to all products if no filter is selected
  void resetFilteredProducts() {
    _filteredProducts = List.from(_vendorProducts);
    notifyListeners();
  }

  // Set filtered products
  void setFilteredProducts(List<ProductModel> filteredProducts) {
    if (_filteredProducts.isEmpty) {
      // Start with the initial filtered products
      _filteredProducts = filteredProducts;
    } else {
      // Keep only products that match all filters applied so far
      _filteredProducts = _filteredProducts
          .where((product) => filteredProducts.contains(product))
          .toList();
    }
    notifyListeners(); // Update UI
  }

  /// Clears the filter and resets [_filteredProducts] to include all products from [_vendorProducts].
  void clearFilteredProducts() {
    _filteredProducts = List.from(
        _vendorProducts); // Reset filtered products to all vendor products.
    notifyListeners(); // Notify listeners that filtered data has changed.
  }

  // Get filtered products by price range
  List<ProductModel> getFilteredProductsByPriceRange(
      Map<String, dynamic> priceRange) {
    return _vendorProducts.where((product) {
      final price = double.tryParse(product.regularPrice ?? '0') ?? 0.0;
      return price >= priceRange['min'] && price <= priceRange['max'];
    }).toList();
  }

  // Get filtered products by category
  List<ProductModel> getFilteredProductsByCategory(int categoryId) {
    return _vendorProducts.where((product) {
      return product.categories.any((category) => category.id == categoryId);
    }).toList();
  }

  // Get filtered products that are on sale
  List<ProductModel> getFilteredProductsByOnSale() {
    return _vendorProducts.where((product) {
      return product.onSale ?? false;
    }).toList();
  }

  // Get filtered products by rating range
  List<ProductModel> getFilteredProductsByRatingRange(
      Map<String, dynamic> ratingRange) {
    return _vendorProducts.where((product) {
      final rating = double.tryParse(product.averageRating ?? '0') ?? 0.0;
      return rating >= ratingRange['min'] && rating <= ratingRange['max'];
    }).toList();
  }
}
