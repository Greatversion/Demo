// ignore_for_file: prefer_final_fields

import 'package:flutter/foundation.dart';
import 'package:mambo/Services/Network%20Functions/product_services.dart';
import 'package:mambo/models/Network%20models/product_model.dart';
import 'package:mambo/models/Network%20models/review_model.dart';
import 'package:mambo/services/Network%20Functions/vendor_services.dart';

/// [ProductProvider] manages the state and logic related to products in the application.
/// It handles fetching, filtering, and managing product data and associated reviews.
class ProductProvider extends ChangeNotifier {
  // Service instances for fetching products and vendor information.
  final ProductService productService = ProductService();
  final VendorService vendorService = VendorService();

  // Private variables to manage the state and data.
  bool _isLoading =
      false; // Indicates whether a loading operation is in progress.
  String _videoURL = " "; // URL for the featured video of a product.
  List<ProductModel> _products = []; // List of all fetched products.
  ProductModel? _productByID; // Specific product fetched by its ID.
  List<ProductModel> _categoryProducts =
      []; // Products belonging to a specific category.
  List<ProductModel> _filteredProducts =
      []; // List of products after applying filters.
  List<ProductModel> _vendorProducts =
      []; // Products associated with specific vendors.
  List<String> _productsList = []; // List of product names for quick reference.
  List<int> _productsIDList = []; // List of product IDs for quick reference.
  List<ReviewModel> _reviews = []; // List of reviews for products.
  bool _isFetchingReviews =
      false; // Indicates whether reviews are being fetched.

  // Getter methods for accessing private variables.

  /// Returns the list of reviews for products.
  List<ReviewModel> get reviews => _reviews;

  /// Returns whether a loading operation is in progress.
  bool get isLoading => _isLoading;

  /// Returns the URL of the featured video for a product.
  String get videoURL => _videoURL;

  /// Returns the list of all fetched products.
  List<ProductModel>? get products => _products;

  /// Returns a specific product fetched by its ID.
  ProductModel? get productByID => _productByID;

  /// Returns the list of products in a specific category.
  List<ProductModel> get categoryProducts => _categoryProducts;

  /// Returns the list of products associated with specific vendors.
  List<ProductModel> get vendorProducts => _vendorProducts;

  /// Returns the list of product names.
  List<String> get productsList => _productsList;

  /// Returns the list of product IDs.
  List<int> get productsIDList => _productsIDList;

  /// Returns the list of filtered products based on applied filters.
  List<ProductModel> get filteredProducts => _filteredProducts;

  /// Returns whether reviews are currently being fetched.
  bool get isFetchingReviews => _isFetchingReviews;

  /// Fetches all products and updates the internal list and references.
  Future<void> fetchProducts() async {
    if (_isLoading) return; // Prevent multiple calls.

    _isLoading = true;
    notifyListeners(); // Notify listeners that loading has started.

    try {
      _products = await productService.fetchProducts();
      _productsList = _products.map((product) => product.name!).toList();
      _productsIDList = _products.map((product) => product.id!).toList();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString()); // Log error in debug mode.
      }
    } finally {
      _isLoading = false;
      notifyListeners(); // Notify listeners that loading has finished.
    }
  }

  /// Retrieves the featured video URL from a product's metadata.
  ///
  /// [product] - The product from which to extract the featured video URL.
  /// Returns the URL if present, otherwise returns null.
  String? getFeaturedVideo(ProductModel product) {
    try {
      var featuredVideoMeta = product.metaData.firstWhere(
        (meta) => meta.key == 'woostify_product_video_metabox',
        // Handle case where the key is not found.
      );
      return featuredVideoMeta.value;
    } catch (e) {
      return null; // Return null if an exception occurs.
    }
  }

  /// Fetches products that belong to a specific category.
  ///
  /// [categoryId] - The ID of the category to fetch products from.
  Future<void> fetchProductsByCategory(int categoryId) async {
    _isLoading = true;
    notifyListeners(); // Notify listeners that loading has started.

    try {
      _categoryProducts.clear(); // Clear previous category products.
      _categoryProducts =
          await productService.fetchProductsByCategory(categoryId);
      _filteredProducts = List.from(
          _categoryProducts); // Set filtered products to category products.
    } catch (e) {
      debugPrint("Error fetching products: $e");
    } finally {
      _isLoading = false;
      notifyListeners(); // Notify listeners that loading has finished.
    }
  }

  /// Loads reviews for a specific product by its ID.
  ///
  /// [productId] - The ID of the product for which to load reviews.
  Future<void> loadAllReviews(int productId) async {
    if (_isFetchingReviews) return; // Prevent multiple review fetches.

    _isFetchingReviews = true;
    notifyListeners(); // Notify listeners that review fetching has started.

    _reviews = [];

    try {
      _reviews = await productService.fetchReviews(productId);
    } catch (error) {
      debugPrint(error.toString());
    } finally {
      _isFetchingReviews = false;
      notifyListeners(); // Notify listeners that review fetching has finished.
    }
  }

  /// Fetches a specific product by its ID.
  ///
  /// [productId] - The ID of the product to fetch.
  Future<void> fetchProductById(int productId) async {
    _isLoading = true;
    notifyListeners(); // Notify listeners that loading has started.

    try {
      _productByID = await productService.fetchProductById(productId);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners(); // Notify listeners that loading has finished.
    }
  }

  /// Clears the data related to the currently fetched product by ID.
  void clearData() {
    _productByID = null;
    notifyListeners();
  }

  /// Clears the list of filtered products and resets it to the category products list.
  void clearFilteredProducts() {
    _filteredProducts = List.from(
        _categoryProducts); // Reset filtered products to all vendor products.
    notifyListeners(); // Notify listeners that filtered data has changed.
  }

  void resetFilteredProducts() {
    _filteredProducts = List.from(_categoryProducts);
    notifyListeners();
  }

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

  /// Filters the list of products by a specified price range.
  ///
  /// [priceRange] - A map containing 'min' and 'max' price values for filtering.
  List<ProductModel> getFilteredProductsByPriceRange(
      Map<String, dynamic> priceRange) {
    return _categoryProducts.where((product) {
      final price = double.tryParse(product.regularPrice ?? '0') ?? 0.0;
      return price >= priceRange['min'] && price <= priceRange['max'];
    }).toList();
  }

  /// Filters the list of products to include only those that are on sale.
  List<ProductModel> getFilteredProductsByOnSale() {
    return _categoryProducts.where((product) {
      return product.onSale ?? false;
    }).toList();
  }

  /// Filters the list of products by a specified rating range.
  ///
  /// [ratingRange] - A map containing 'min' and 'max' rating values for filtering.
  List<ProductModel> getFilteredProductsByRatingRange(
      Map<String, dynamic> ratingRange) {
    return _categoryProducts.where((product) {
      final rating = double.tryParse(product.averageRating ?? '0') ?? 0.0;
      return rating >= ratingRange['min'] && rating <= ratingRange['max'];
    }).toList();
  }

  /// Filters the list of products by a specified vendor ID.
  ///
  /// [vendorId] - The ID of the vendor to filter products by.
  List<ProductModel> getFilteredProductsByVendors(int vendorId) {
    return _categoryProducts.where((product) {
      return product.store!.id == vendorId;
    }).toList();
  }
}
