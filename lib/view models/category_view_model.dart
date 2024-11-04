// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:mambo/models/Network%20models/product_model.dart';
import 'package:mambo/services/Network%20Functions/category_services.dart';
import 'package:mambo/models/Network%20models/category_model.dart';
import 'package:mambo/view%20models/vendor_view_model.dart';
import 'package:provider/provider.dart'; // Import ConnectivityService

/// [CategoryProvider] is a [ChangeNotifier] class responsible for managing
/// the state of categories and fetching them from the [CategoryService].
class CategoryProvider extends ChangeNotifier {
  // Service instance to handle fetching categories from the network.
  final CategoryService _categoryService = CategoryService();

  // List to store the fetched categories in their raw model form.
  List<CategoryModel> _categories = [];

  // List to store new categories fetched in a different form or endpoint.
  List<Category> _newcategories = [];

  // List to store category IDs.
  List<int> _categoriesID = [];

  // String to store any error messages encountered during operations.
  String _errorMessage = '';

  // Boolean flag to indicate if a loading operation is in progress.
  bool _isLoading = false;

  // List to store category names for UI display.
  List<String> _categoriesList = [];

  // Getters for accessing private variables.
  List<CategoryModel> get categories => _categories;
  List<Category> get newcategories => _newcategories;
  String get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  List<int> get categoriesID => _categoriesID;
  List<String> get categoriesList => _categoriesList;

  /// Fetches categories from the service and updates the local state.
  /// Also extracts category names and IDs for easier access in the UI.
  Future<void> fetchCategories(BuildContext context) async {
    _isLoading = true; // Set loading state to true.
    notifyListeners();

    try {
      // Fetch categories from the CategoryService.
      _categories = await _categoryService.fetchCategories();

      // Extract names and IDs for easier access.
      _categoriesList = categories.map((e) => e.name!).toList();
      _categoriesID = _categories.map((e) => e.id!).toList();
      notifyListeners(); // Notify listeners after updating state.
    } catch (e) {
      // Log and store error message if fetching categories fails.
      _errorMessage = e.toString();
      debugPrint(e.toString());
    } finally {
      _isLoading = false; // Reset loading state after operation.
      notifyListeners();
    }
  }

  /// Fetches categories from a different endpoint or format using [CategoryService].
  /// Updates the local state with the new categories.
  Future<void> fetchCategoriesii(BuildContext context) async {
    _isLoading = true; // Set loading state to true.
    notifyListeners();

    try {
      // Fetch new categories from the CategoryService.
      _newcategories = await _categoryService.fetchCategoriesii();

      notifyListeners(); // Notify listeners after updating state.
    } catch (e) {
      // Log and store error message if fetching new categories fails.
      _errorMessage = e.toString();
      debugPrint(e.toString());
    } finally {
      _isLoading = false; // Reset loading state after operation.
      notifyListeners();
    }
  }
}

/// [BrandsViewModel] is a [ChangeNotifier] class that manages the state
/// of brands and vendor-related data in the application.
class BrandsViewModel with ChangeNotifier {
  // List to store vendor names fetched from the network.
  List<String> vendorsList = [];

  // List to store matched query results for search functionality.
  List<String> matchQuery = [];

  // Controller for handling search input in the UI.
  TextEditingController brandSearchController = TextEditingController();

  /// Constructor for [BrandsViewModel]. It initializes the vendors list
  /// by fetching data from [VendorProvider].
  BrandsViewModel(BuildContext context) {
    final vendorProvider = Provider.of<VendorProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchVendors(vendorProvider, context);
    });

    // Add listener to search controller to filter items based on input.
    brandSearchController.addListener(filterItems);
  }

  /// Fetches vendor data using the [VendorProvider] and updates the state.
  ///
  /// [vendorProvider] The provider to fetch vendor data.
  /// [context] The build context used for fetching data.
  Future<void> _fetchVendors(
      VendorProvider vendorProvider, BuildContext context) async {
    await vendorProvider.fetchVendors();
    if (vendorProvider.allvendors != null) {
      // Update vendors list and matched query list.
      vendorsList =
          vendorProvider.allvendors.map((vendor) => vendor.storeName!).toList();
      matchQuery = vendorsList;
    }
    notifyListeners(); // Notify listeners to update the UI.
  }

  /// Filters the items in the vendors list based on the search input.
  void filterItems() {
    String query = brandSearchController.text.toLowerCase();
    matchQuery = vendorsList.where((item) {
      return item.toLowerCase().contains(query);
    }).toList();
    notifyListeners(); // Notify listeners to update the UI.
  }

  /// Clears the search input and resets the filtered list.
  void clear() {
    brandSearchController.clear();
    brandSearchController.removeListener(filterItems);
    notifyListeners(); // Notify listeners to update the UI.
  }

  @override
  void dispose() {
    // Dispose of the search controller when the view model is disposed.
    brandSearchController.dispose();
    super.dispose();
  }
}

/// [CategoriesViewModel] is a [ChangeNotifier] class that manages the state
/// of categories and category-related data in the application.
class CategoriesViewModel with ChangeNotifier {
  // List to store category names for search functionality.
  List<String> categoryList = [];

  // List to store matched query results for search functionality.
  List<String> matchQuery = [];

  // Controller for handling search input in the UI.
  TextEditingController categorySearchController = TextEditingController();

  /// Constructor for [CategoriesViewModel]. It initializes the categories list
  /// by fetching data from [CategoryProvider].
  CategoriesViewModel(BuildContext context) {
    final categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchCategories(categoryProvider, context);
    });

    // Add listener to search controller to filter items based on input.
    categorySearchController.addListener(filterItems);
  }

  /// Fetches category data using the [CategoryProvider] and updates the state.
  ///
  /// [categoryProvider] The provider to fetch category data.
  /// [context] The build context used for fetching data.
  Future<void> _fetchCategories(
      CategoryProvider categoryProvider, BuildContext context) async {
    await categoryProvider.fetchCategories(context);
    // If categories are successfully fetched, update the category list.
    if (categoryProvider.categories != null) {
      categoryList = categoryProvider.categories
          .map((category) => category.name!)
          .toList();
      matchQuery = categoryList;
    }
    notifyListeners(); // Notify listeners to update the UI.
  }

  /// Filters the items in the category list based on the search input.
  void filterItems() {
    String query = categorySearchController.text.toLowerCase();
    matchQuery = categoryList.where((item) {
      return item.toLowerCase().contains(query);
    }).toList();
    notifyListeners(); // Notify listeners to update the UI.
  }

  /// Clears the search input and resets the filtered list.
  void clear() {
    categorySearchController.clear();
    filterItems(); // Reset the filtered list.
  }

  @override
  void dispose() {
    // Dispose of the search controller when the view model is disposed.
    categorySearchController.dispose();
    super.dispose();
  }
}
