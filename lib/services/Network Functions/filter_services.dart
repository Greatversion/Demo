import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as https;
import 'package:mambo/models/Network%20models/product_model.dart';
import 'package:mambo/utils/app.baseurl.dart';

/// `FilterServices` provides methods to filter products based on store names,
/// category names, and price range.
class FilterServices {
  // Consumer Key for API authentication
  final String consumerKey = dotenv.env['CONSUMER_KEY']!;

  // Consumer Secret for API authentication
  final String consumerSecret = dotenv.env['CONSUMER_SECRET']!;

  /// Filters products based on multiple stores, categories, and price range.
  ///
  /// Fetches store IDs and category IDs from their respective names,
  /// then retrieves products that match the given filters.
  ///
  /// Returns a list of `ProductModel` objects if successful.
  /// Throws an exception if any error occurs during the process.
  /// Not using..

  Future<List<ProductModel>> filterProductsByMultipleStoresAndCategories({
    required List<String> storeNames,
    required List<String> categoryNames,
    required double? minPrice,
    required double? maxPrice,
  }) async {
    try {
      // Step 1: Fetch the store IDs for the given store names
      List<int> storeIds = await fetchStoreIds(storeNames);

      // Step 2: Fetch the category IDs for the given category names
      List<int> categoriesIds = await fetchCategoryIds(categoryNames);

      // Step 3: Fetch products based on the filters
      return await fetchFilteredProducts(
        categoryIds: categoriesIds,
        storeIds: storeIds,
        minPrice: minPrice,
        maxPrice: maxPrice,
      );
    } catch (e) {
      debugPrint("Error in filterProductsByMultipleStoresAndCategories: $e");
      return [];
    }
  }

  /// Fetches filtered products based on category IDs, store IDs, and price range.
  ///
  /// Sends a GET request to the API with query parameters for categories,
  /// stores, minimum price, and maximum price.
  ///
  /// Returns a list of `ProductModel` objects if the request is successful.
  /// Throws an exception if the request fails.
  Future<List<ProductModel>> fetchFilteredProducts({
    required List<int> categoryIds,
    required List<int> storeIds,
    required double? minPrice,
    required double? maxPrice,
  }) async {
    String baseUrl = '${BaseUrl.baseurl}wp-json/wc/v3/products';

    // Construct query parameters
    final String categories = categoryIds.join(',');
    final String vendors = storeIds.join(',');

    final Uri uri = Uri.parse(baseUrl).replace(queryParameters: {
      if (minPrice != null) 'min_price': minPrice.toString(),
      if (maxPrice != null) 'max_price': maxPrice.toString(),
      'category': categories,
      'vendor': vendors,
    });

    try {
      final response = await https.get(
        uri,
        headers: {
          'Authorization':
              'Basic ${base64Encode(utf8.encode('$consumerKey:$consumerSecret'))}',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(response.body);
        return jsonResponse.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        debugPrint(
            'Failed to load products. Status code: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
        throw Exception('Failed to load products');
      }
    } catch (e) {
      debugPrint('Exception in fetchFilteredProducts: $e');
      throw e;
    }
  }

  /// Fetches category IDs based on the provided category names.
  ///
  /// Sends a GET request to the API for each category name to retrieve its ID.
  /// Assumes that the first result is the correct category ID.
  ///
  /// Returns a list of category IDs if successful.
  /// Logs warnings if categories are not found or requests fail.
  Future<List<int>> fetchCategoryIds(List<String> categoryNames) async {
    final List<int> categoryIds = [];
    String baseUrl = '${BaseUrl.baseurl}wp-json/wc/v3/products/categories';

    for (String categoryName in categoryNames) {
      try {
        final response = await https.get(
          Uri.parse('$baseUrl?search=$categoryName'),
          headers: {
            'Authorization':
                'Basic ${base64Encode(utf8.encode('$consumerKey:$consumerSecret'))}',
          },
        );

        if (response.statusCode == 200) {
          List<dynamic> categories = jsonDecode(response.body);
          if (categories.isNotEmpty) {
            categoryIds.add(
                categories.first['id']); // Assuming the first match is correct
          } else {
            debugPrint('No categories found for name: $categoryName');
          }
        } else {
          debugPrint(
              'Failed to load category ID for $categoryName. Status code: ${response.statusCode}');
          debugPrint('Response body: ${response.body}');
          throw Exception('Failed to load category ID for $categoryName');
        }
      } catch (e) {
        debugPrint(
            'Exception occurred while fetching category ID for $categoryName: $e');
        // Continue to next category
      }
    }

    debugPrint('Fetched category IDs: $categoryIds');
    return categoryIds;
  }

  /// Fetches store IDs based on the provided store names.
  ///
  /// Sends a GET request to the API for each store name to retrieve its ID.
  /// Assumes that the first result is the correct store ID.
  ///
  /// Returns a list of store IDs if successful.
  /// Logs warnings if stores are not found or requests fail.
  Future<List<int>> fetchStoreIds(List<String> storeNames) async {
    final List<int> storeIds = [];
    String baseUrl = '${BaseUrl.baseurl}wp-json/dokan/v1/stores';

    for (String storeName in storeNames) {
      try {
        final response = await https.get(
          Uri.parse('$baseUrl?search=$storeName'),
          headers: {
            'Authorization':
                'Basic ${base64Encode(utf8.encode('$consumerKey:$consumerSecret'))}',
          },
        );

        if (response.statusCode == 200) {
          List<dynamic> stores = jsonDecode(response.body);
          if (stores.isNotEmpty) {
            storeIds
                .add(stores.first['id']); // Assuming the first match is correct
          } else {
            debugPrint('No stores found for name: $storeName');
          }
        } else {
          debugPrint(
              'Failed to load store ID for $storeName. Status code: ${response.statusCode}');
          debugPrint('Response body: ${response.body}');
          throw Exception('Failed to load store ID for $storeName');
        }
      } catch (e) {
        debugPrint(
            'Exception occurred while fetching store ID for $storeName: $e');
        // Continue to next store
      }
    }

    debugPrint('Fetched store IDs: $storeIds');
    return storeIds;
  }

//Filters Service............................

  Future<List<ProductModel>> NewfilterProductsByCategories(
      List<int> categoryIds) async {
    // Join the category IDs into a comma-separated string
    int page = 1;
    bool hasMore = true;
    List<ProductModel> allProducts = [];

    while (hasMore) {
      final String categories = categoryIds.join(',');

      final String url =
          '${BaseUrl.baseurl}wp-json/wc/v3/products?category=$categories&per_page=100&page=$page';

      try {
        final response = await https.get(
          Uri.parse(url),
          headers: {
            'Authorization':
                'Basic ${base64Encode(utf8.encode('$consumerKey:$consumerSecret'))}',
          },
        );

        if (response.statusCode == 200) {
          List<dynamic> data = jsonDecode(response.body);
          if (data.isEmpty) {
            hasMore = false;
          } else {
            allProducts.addAll(
                data.map((item) => ProductModel.fromJson(item)).toList());
            page++; // Move to the next page
          }
        } else {
          throw Exception('Failed to load products by categories');
        }
      } catch (e) {
        throw Exception('Failed to connect to the server: $e');
      }
    }
    return allProducts;
  }

  Future<List<ProductModel>> NewfilterProductsByVendors(
      List<int> vendorIds) async {
    // Prepare an empty list to accumulate all products from all vendors
    int page = 1;
    bool hasMore = true;
    List<ProductModel> allProducts = [];

    // Iterate through each vendor ID and fetch products separately
    for (int vendorId in vendorIds) {
      while (hasMore) {
        final String url =
            '${BaseUrl.baseurl}wp-json/dokan/v1/stores/$vendorId/products?per_page=100&page=$page'; // Dokan-specific endpoint
        try {
          final response = await https.get(
            Uri.parse(url),
            headers: {
              'Authorization':
                  'Basic ${base64Encode(utf8.encode('$consumerKey:$consumerSecret'))}',
            },
          );

          if (response.statusCode == 200) {
            List<dynamic> data = jsonDecode(response.body);
            // Convert each product JSON to ProductModel and add it to the list
            if (data.isEmpty) {
              hasMore = false;
            } else {
              allProducts.addAll(
                  data.map((item) => ProductModel.fromJson(item)).toList());
              page++;
            }
          } else {
            throw Exception('Failed to load products for vendor $vendorId');
          }
        } catch (e) {
          throw Exception('Failed to connect to the server: $e');
        }
      }
    }

    // Return all products fetched from all vendors
    return allProducts;
  }

  Future<List<ProductModel>> NewfilterProductsByPriceRange(
      double minPrice, double maxPrice) async {
    int page = 1;
    bool hasMore = true;
    List<ProductModel> allProducts = [];

    while (hasMore) {
      final String url =
          '${BaseUrl.baseurl}wp-json/wc/v3/products?min_price=$minPrice&max_price=$maxPrice&per_page=100&page=$page';
      try {
        final response = await https.get(
          Uri.parse(url),
          headers: {
            'Authorization':
                'Basic ${base64Encode(utf8.encode('$consumerKey:$consumerSecret'))}',
          },
        );

        if (response.statusCode == 200) {
          List<dynamic> data = jsonDecode(response.body);
          if (data.isEmpty) {
            hasMore = false;
          } else {
            allProducts.addAll(
                data.map((item) => ProductModel.fromJson(item)).toList());
            page++;
          }
        } else {
          throw Exception('Failed to load products by price range');
        }
      } catch (e) {
        throw Exception('Failed to connect to the server: $e');
      }
    }
    return allProducts;
  }
}
