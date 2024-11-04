// import 'package:flutter/material.dart';
// import 'package:mambo/models/Network%20models/product_model.dart';
// import 'package:mambo/services/Network%20Functions/filter_services.dart';

// /// [ProductFilterViewModel] is a [ChangeNotifier] class responsible for managing
// /// the state and logic for filtering products based on multiple criteria such as
// /// store names, category names, and price range.
// class ProductFilterViewModel extends ChangeNotifier {
//   // Service for filtering products based on various criteria.
//   final FilterServices _filterServices = FilterServices();

//   // Private variables to manage state and data.
//   bool _isLoading =
//       false; // Indicates whether a loading operation is in progress.
//   String _errorMessage =
//       ''; // Stores error messages encountered during operations.
//   List<ProductModel> _filteredProducts =
//       []; // Stores the list of filtered products.

// // Getter methods to provide access to private variables.

//   /// Returns the loading state to indicate whether data is being fetched.
//   bool get isLoading => _isLoading;

//   /// Returns the error message if an error occurs during filtering.
//   String get errorMessage => _errorMessage;

//   /// Returns the list of filtered products.
//   List<ProductModel> get filteredProducts => _filteredProducts;

//   /// Filters products based on the given store names, category names, and price range.
//   /// This method fetches products from a service based on the provided filter criteria.
//   ///
//   /// [storeNames] - List of store names to filter by.
//   /// [categoryNames] - List of category names to filter by.
//   /// [minPrice] - Minimum price range for filtering.
//   /// [maxPrice] - Maximum price range for filtering.
//   Future<void> filterProductsByMultipleStoresAndCategories({
//     required List<String> storeNames,
//     required List<String> categoryNames,
//     required double? minPrice,
//     required double? maxPrice,
//   }) async {
//     _isLoading = true; // Set loading state to true.
//     _errorMessage = ''; // Clear any previous error messages.
//     notifyListeners(); // Notify listeners to rebuild the UI with the loading state.

//     try {
//       _filteredProducts.clear(); // Clear previous filtered products list.

//       // Fetch new filtered products from the service.
//       _filteredProducts =
//           await _filterServices.filterProductsByMultipleStoresAndCategories(
//         storeNames: storeNames,
//         categoryNames: categoryNames,
//         minPrice: minPrice,
//         maxPrice: maxPrice,
//       );

//       // Debug print statements for development purposes.
//       debugPrint(
//           _filteredProducts.toString()); // Log the list of filtered products.
//       debugPrint(_filteredProducts.length
//           .toString()); // Log the count of filtered products.
//     } catch (e) {
//       // Handle errors by setting an error message.
//       _errorMessage = "Error: $e";
//     } finally {
//       _isLoading = false; // Reset loading state after operation.
//       notifyListeners(); // Notify listeners to rebuild the UI with the updated data.
//     }
//   }

//   /// Clears the list of filtered products.
//   /// Uncomment if needed to provide a way to reset or clear filtered data.
//   // void clearFilteredData() {
//   //   _filteredProducts = [];
//   // }

//   //New view-models...................................................

//   Future<void> NewfilterProductsByVendors(List<String> storeNames) async {
//     try {
//       _isLoading = true;
//       notifyListeners();
//       List<int> storeIds = await _filterServices.fetchStoreIds(storeNames);
//       _filteredProducts =
//           await _filterServices.NewfilterProductsByVendors(storeIds);
//     } catch (e) {
//       debugPrint(e.toString());
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//     // Step 1: Fetch the store IDs for the given store names

//     debugPrint(_filteredProducts.length.toString());
//     for (var i in _filteredProducts) {
//       debugPrint(i.name);
//     }
//   }

//   Future<void> NewfilterProductsByCategories(List<String> categoryNames) async {
//     try {
//       _isLoading = true;
//       notifyListeners();
//       List<int> categoriesIds =
//           await _filterServices.fetchCategoryIds(categoryNames);

//       _filteredProducts =
//           await _filterServices.NewfilterProductsByCategories(categoriesIds);
//     } catch (e) {
//       debugPrint(e.toString());
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//     // Step 1: Fetch the store IDs for the given store names

//     debugPrint(_filteredProducts.length.toString());
//     for (var i in _filteredProducts) {
//       debugPrint(i.name);
//     }
//   }

//   Future<void> NewfilterProductsByPriceRange(
//       double minPrice, double maxPrice) async {
//     try {
//       _isLoading = true;
//       notifyListeners();
//       _filteredProducts = await _filterServices.NewfilterProductsByPriceRange(
//           minPrice, maxPrice);
//     } catch (e) {
//       debugPrint(e.toString());
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }

//     for (var i in _filteredProducts) {
//       debugPrint(i.name);
//     }
//     debugPrint(_filteredProducts.length.toString());
//   }

// }

// import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
// import 'package:mambo/Services/Network%20Functions/product_services.dart';
// import 'package:mambo/models/Network%20models/product_model.dart';
// import 'package:mambo/services/Network%20Functions/filter_services.dart';

// class ProductFilterViewModel extends ChangeNotifier {
//   final FilterServices _filterServices = FilterServices();
//   final ProductService _productServices = ProductService();

//   bool _isLoading = false;
//   String _errorMessage = '';
//   List<ProductModel> _filteredProducts = [];

//   // Getter methods to provide access to private variables.
//   bool get isLoading => _isLoading;
//   String get errorMessage => _errorMessage;
//   List<ProductModel> get filteredProducts => _filteredProducts;

//   // Combined filter function
//   Future<void> applyFilters({
//     List<String>? vendorNames,
//     List<String>? categoryNames,
//     double? minPrice,
//     double? maxPrice,
//   }) async {
//     _isLoading = true;
//     _errorMessage = '';
//     notifyListeners();

//     try {
//       List<ProductModel> vendorFiltered = [];
//       List<ProductModel> categoryFiltered = [];
//       List<ProductModel> priceFiltered = [];

//       // Fetch all products if no filters are applied
//       bool hasVendorFilter = vendorNames != null && vendorNames.isNotEmpty;
//       bool hasCategoryFilter =
//           categoryNames != null && categoryNames.isNotEmpty;
//       bool hasPriceFilter = minPrice != null && maxPrice != null;

//       // Fetch all products initially
//       // List<ProductModel> allProducts = await fetchAllProducts();

//       // Apply vendor filter if applicable
//       if (hasVendorFilter) {
//         List<int> storeIds = await _filterServices.fetchStoreIds(vendorNames);
//         vendorFiltered =
//             await _filterServices.NewfilterProductsByVendors(storeIds);
//       } else {
//         _filteredProducts = vendorFiltered;
//       }

//       // Apply category filter if applicable
//       if (hasCategoryFilter) {
//         List<int> categoryIds =
//             await _filterServices.fetchCategoryIds(categoryNames);
//         categoryFiltered =
//             await _filterServices.NewfilterProductsByCategories(categoryIds);
//       } else {
//          _filteredProducts = categoryFiltered;
//       }

//       // Apply price filter if applicable
//       if (hasPriceFilter) {
//         priceFiltered = await _filterServices.NewfilterProductsByPriceRange(
//             minPrice, maxPrice);
//       } else {
//          _filteredProducts = priceFiltered;
//       }

//     } catch (e) {
//       _errorMessage = 'Error: $e';
//       debugPrint(e.toString());
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

// }

import 'package:flutter/material.dart';
import 'package:mambo/Services/Network%20Functions/product_services.dart';
import 'package:mambo/models/Network%20models/product_model.dart';
import 'package:mambo/services/Network%20Functions/filter_services.dart';

class ProductFilterViewModel extends ChangeNotifier {
  final FilterServices _filterServices = FilterServices();
  final ProductService _product = ProductService();

  bool _isLoading = false;
  String _errorMessage = '';
  List<ProductModel> _filteredProducts = [];

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  List<ProductModel> get filteredProducts => _filteredProducts;

  Future<void> applyFilters({
    List<String>? vendorNames,
    List<String>? categoryNames,
    double? minPrice,
    double? maxPrice,
  }) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Fetch all products initially
      List<ProductModel> allProducts = await fetchAllProducts();

      // Initialize filtered results with all products
      List<ProductModel> vendorFiltered = allProducts;
      List<ProductModel> categoryFiltered = allProducts;
      List<ProductModel> priceFiltered = allProducts;

      // Apply vendor filter if provided
      if (vendorNames != null && vendorNames.isNotEmpty) {
        List<int> storeIds = await _filterServices.fetchStoreIds(vendorNames);
        vendorFiltered =
            await _filterServices.NewfilterProductsByVendors(storeIds);
      }

      // Apply category filter if provided
      if (categoryNames != null && categoryNames.isNotEmpty) {
        List<int> categoryIds =
            await _filterServices.fetchCategoryIds(categoryNames);
        categoryFiltered =
            await _filterServices.NewfilterProductsByCategories(categoryIds);
      }

      // Apply price filter if provided
      if (minPrice != null && maxPrice != null) {
        priceFiltered = await _filterServices.NewfilterProductsByPriceRange(
            minPrice, maxPrice);
      }

      // Intersect results from all filters
      _filteredProducts = _intersect(
          _intersect(vendorFiltered, categoryFiltered), priceFiltered);

      debugPrint('Filtered products count: ${_filteredProducts.length}');
      for (var product in _filteredProducts) {
        debugPrint(product.name);
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
      debugPrint(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Helper method to intersect lists
  List<ProductModel> _intersect(
      List<ProductModel> list1, List<ProductModel> list2) {
    Set<int> ids1 = list1.map((p) => p.id!).toSet();
    Set<int> ids2 = list2.map((p) => p.id!).toSet();
    List<ProductModel> commonProducts =
        list1.where((p) => ids2.contains(p.id)).toList();
    return commonProducts;
  }

  // Fetch all products as a fallback
  Future<List<ProductModel>> fetchAllProducts() async {
    try {
      return await _product.fetchProducts(); // Assuming this method exists
    } catch (e) {
      debugPrint('Error fetching all products: $e');
      return [];
    }
  }
}
