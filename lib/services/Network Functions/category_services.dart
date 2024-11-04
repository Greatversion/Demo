import 'dart:convert';
// import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mambo/models/Network%20models/category_model.dart';
import 'package:mambo/models/Network%20models/product_model.dart';
import 'package:mambo/utils/app.baseurl.dart';

/// `CategoryService` is responsible for fetching category data from an external API.
class CategoryService {
  // Base URL for the API endpoint to fetch product categorie
  final String baseUrl =
      '${BaseUrl.baseurl}wp-json/wc/v3/products/categories?per_page=100';

  // Consumer Key for API authentication
  final String consumerKey = dotenv.env['CONSUMER_KEY']!;

  // Consumer Secret for API authentication
  final String consumerSecret = dotenv.env['CONSUMER_SECRET']!;

  /// Fetches a list of categories from the API.
  ///
  /// Sends a GET request to the API using basic authentication with consumer key and secret.
  /// Parses the response JSON into a list of `CategoryModel` objects.
  ///
  /// Returns a list of `CategoryModel` objects if the request is successful.
  /// Throws an exception if the request fails.
  Future<List<CategoryModel>> fetchCategories() async {
    int page = 1;
    bool hasMore = true;
    List<CategoryModel> allcategories = [];
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
          allcategories.addAll(
              data.map((item) => CategoryModel.fromJson(item)).toList());
          page++;
        }
      } else {
        throw Exception('Failed to load categories');
      }
    }
    return allcategories;
  }

  /// Fetches a list of categories from the API with a different model.
  ///
  /// Sends a GET request to the API using basic authentication with consumer key and secret.
  /// Parses the response JSON into a list of `Category` objects.
  ///
  /// Returns a list of `Category` objects if the request is successful.
  /// Throws an exception if the request fails.
  Future<List<Category>> fetchCategoriesii() async {
    int page = 1;
    bool hasMore = true;
    List<Category> allcategoriies = [];
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
          allcategoriies
              .addAll(data.map((item) => Category.fromJson(item)).toList());
          page++;
        }
      } else {
        throw Exception('Failed to load categories');
      }
    }
    return allcategoriies;
  }
}
