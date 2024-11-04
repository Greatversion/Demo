import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mambo/models/Network%20models/product_model.dart';
import 'package:mambo/utils/app.baseurl.dart';

class SearchService {
  // Base URL for WooCommerce API with a limit of 100 products per page
  final String baseUrl = '${BaseUrl.baseurl}wp-json/wc/v3/products';

  // Consumer Key for API authentication
  final String consumerKey = dotenv.env['CONSUMER_KEY']!;

  // Consumer Secret for API authentication
  final String consumerSecret = dotenv.env['CONSUMER_SECRET']!;

  /// Searches for products based on the query string.
  ///
  /// [query] is the search term used to find products.
  ///
  /// Returns a list of [ProductModel] objects that match the search query.
  Future<List<ProductModel>> searchProducts(String query) async {
    int page = 1;
    bool hasMore = true;
    List<ProductModel> allProducts = [];

    while (hasMore) {
      // Corrected URL for the search endpoint, including the search query and pagination parameters
      final String url = "$baseUrl?per_page=100&search=$query&page=$page";

      try {
        // Making GET request to fetch products matching the search query and current page
        final response = await http.get(
          Uri.parse(url),
          headers: {
            'Authorization':
                'Basic ${base64Encode(utf8.encode('$consumerKey:$consumerSecret'))}',
          },
        );

        // Check if the request was successful
        if (response.statusCode == 200) {
          // Decode the JSON response and convert it to a list of ProductModel objects
          List<dynamic> data = jsonDecode(response.body);
          if (data.isEmpty) {
            // No more products to fetch
            hasMore = false;
          } else {
            // Add fetched products to the list
            allProducts.addAll(
                data.map((item) => ProductModel.fromJson(item)).toList());
            page++; // Move to the next page
          }
        } else {
          // Throw an exception if the status code is not 200
          throw Exception('Failed to load products: ${response.statusCode}');
        }
      } catch (e) {
        // Handle any exceptions that occur during the request
        throw Exception('Failed to connect to the server: $e');
      }
    }

    return allProducts;
  }
}
