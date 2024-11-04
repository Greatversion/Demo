import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mambo/models/Network%20models/product_model.dart';
import 'package:mambo/models/Network%20models/review_model.dart';
import 'package:mambo/utils/app.baseurl.dart';

/// `ProductService` provides methods to interact with the WooCommerce
/// products and reviews endpoints.
class ProductService {
  // Base URL for WooCommerce products endpoint, with a default page size of 100
  final String baseUrl =
      '${BaseUrl.baseurl}wp-json/wc/v3/products?per_page=100';

  // Consumer Key for API authentication
  final String consumerKey = dotenv.env['CONSUMER_KEY']!;

  // Consumer Secret for API authentication
  final String consumerSecret = dotenv.env['CONSUMER_SECRET']!;

  /// Fetches all products from WooCommerce, handling pagination.
  ///
  /// Returns a list of `ProductModel` objects representing all products.
  /// Throws an exception if the request fails.
  Future<List<ProductModel>> fetchProducts() async {
    int page = 1;
    bool hasMore = true;
    List<ProductModel> allProducts = [];

    while (hasMore) {
      final response = await http.get(
        Uri.parse("$baseUrl&page=$page"),
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
          allProducts
              .addAll(data.map((item) => ProductModel.fromJson(item)).toList());
          page++; // Move to the next page
        }
      } else {
        throw Exception('Failed to load all products');
      }
    }

    return allProducts;
  }

  /// Fetches products based on filters such as price range and category IDs.
  ///
  /// Returns a list of `ProductModel` objects that match the filter criteria.
  /// Throws an exception if the request fails.
  Future<List<ProductModel>> fetchFilteredProducts({
    required int minPrice,
    required int maxPrice,
    List<String>? categoryIds,
  }) async {
    int page = 1;
    bool hasMore = true;
    List<ProductModel> allProducts = [];
    final String categories = categoryIds!.join(',');

    // final Uri uri = Uri.parse(
    //     '$baseUrl&min_price=$minPrice&max_price=$maxPrice&category=$categories?per_page=100&page=$page');

    while (hasMore) {
      final response = await http.get(
        Uri.parse(
            '$baseUrl&min_price=$minPrice&max_price=$maxPrice&category=$categories&page=$page'),
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
          allProducts
              .addAll(data.map((item) => ProductModel.fromJson(item)).toList());
          page++;
        }
      } else {
        throw Exception('Failed to load filtered products');
      }
    }
    return allProducts;
  }

  /// Fetches reviews for a specific product by its ID.
  ///
  /// Returns a list of `ReviewModel` objects associated with the product.
  /// Throws an exception if the request fails.
  Future<List<ReviewModel>> fetchReviews(int productId) async {
    // Pagination is not working in this request : WOOCOMMERCE END-POINT ISSUE
    final response = await http.get(
      Uri.parse("${BaseUrl.baseurl}wp-json/wc/v2/products/$productId/reviews"),
      headers: {
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$consumerKey:$consumerSecret'))}',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);

      return jsonResponse.map((data) => ReviewModel.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load reviews for product ID $productId');
    }
  }

  /// Fetches all categories of products.
  ///
  /// Returns a list of `ProductModel` objects representing the categories.
  /// Throws an exception if the request fails.
  Future<List<ProductModel>> fetchCategories() async {
    int page = 1;
    bool hasMore = true;
    List<ProductModel> allcategories = [];
    while (hasMore) {
      final response = await http.get(
        Uri.parse("$baseUrl&page=$page"),
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
          allcategories
              .addAll(data.map((item) => ProductModel.fromJson(item)).toList());
          page++;
        }
      } else {
        throw Exception('Failed to load categories');
      }
    }
    return allcategories;
  }

  /// Fetches products by category ID.
  ///
  /// Returns a list of `ProductModel` objects that belong to the specified category.
  /// Throws an exception if the request fails.
  Future<List<ProductModel>> fetchProductsByCategory(int categoryId) async {
    int page = 1;
    bool hasMore = true;
    List<ProductModel> allProducts = [];
    final String url =
        '${BaseUrl.baseurl}wp-json/wc/v3/products?category=$categoryId?per_page=100';

    while (hasMore) {
      final response = await http.get(
        Uri.parse("$url&page=$page"),
        headers: {
          'Authorization':
              'Basic ${base64Encode(utf8.encode('$consumerKey:$consumerSecret'))}',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        if (data.isEmpty) {
          hasMore = false;
        } else {}
        allProducts
            .addAll(data.map((item) => ProductModel.fromJson(item)).toList());
        page++;
      } else {
        throw Exception('Failed to load products for category ID $categoryId');
      }
    }
    return allProducts;
  }

  /// Fetches details of a single product by its ID.
  ///
  /// Returns a `ProductModel` object representing the product.
  /// Returns `null` if the product could not be found.
  Future<ProductModel?> fetchProductById(int productId) async {
    final String url = '${BaseUrl.baseurl}wp-json/wc/v3/products/$productId';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$consumerKey:$consumerSecret'))}',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return ProductModel.fromJson(data);
    } else {
      print('Failed to load product details for ID $productId');
      return null;
    }
  }
}
