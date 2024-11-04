import 'dart:convert';

// ignore: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mambo/utils/app.baseurl.dart';

import '../../models/Network models/product_model.dart';
import '../../models/Network models/vendors_model.dart';

class VendorService {
  // Base URL for the API endpoint to fetch vendor data
  final String baseUrl = '${BaseUrl.baseurl}wp-json/dokan/v1/stores';
  final String consumerKey = dotenv.env['CONSUMER_KEY']!;
  final String consumerSecret = dotenv.env['CONSUMER_SECRET']!;

  /// Retrieves a list of all vendors.
  ///
  /// Sends a GET request to the vendor API endpoint and parses the response into a list of `Vendors` objects.
  ///
  /// Throws an [Exception] if the request fails.
  Future<List<Vendors>> fetchVendors() async {
    int page = 1;
    bool hasMore = true;
    List<Vendors> allVendors = [];
    while (hasMore) {
      final response = await http.get(
        Uri.parse("$baseUrl?per_page=100&page=$page"),
        headers: {
          'Authorization':
              'Basic ${base64Encode(utf8.encode('$consumerKey:$consumerSecret'))}',
        },
      );

      if (response.statusCode == 200) {
        // Successfully received a response, parse the JSON data
        List<dynamic> data = jsonDecode(response.body);
        if (data.isEmpty) {
          hasMore = false;
        } else {
          allVendors
              .addAll(data.map((item) => Vendors.fromJson(item)).toList());
          page++;
        }
      } else {
        // Request failed, throw an exception
        throw Exception('Failed to load all vendors');
      }
    }
    return allVendors;
  }

  /// Retrieves a specific vendor by its ID.
  ///
  /// Sends a GET request to the vendor API endpoint for the specified vendor ID and parses the response into a `Vendors` object.
  ///
  /// Throws an [Exception] if the request fails.
  Future<Vendors> fetchVendorById(int vendorId) async {
    final url = '$baseUrl/$vendorId';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$consumerKey:$consumerSecret'))}',
      },
    );

    if (response.statusCode == 200) {
      // Successfully received a response, parse the JSON data
      return Vendors.fromJson(json.decode(response.body));
    } else {
      // Request failed, throw an exception
      throw Exception('Failed to load vendor by its ID.');
    }
  }

  /// Retrieves a list of products associated with a specific vendor.
  ///
  /// Sends a GET request to the vendor's products API endpoint and parses the response into a list of `ProductModel` objects.
  ///
  /// Throws an [Exception] if the request fails.

  Future<List<ProductModel>> fetchProductsByVendor(int vendorId) async {
    int page = 1;
    bool hasMore = true;
    List<ProductModel> allvendorProducts = [];

    final url =
        '$baseUrl/$vendorId/products?per_page=100'; // Check this endpoint

    // Debugging: Print the initial URL and headers

    while (hasMore) {
      try {
        final response = await http.get(
          Uri.parse("$url&page=$page"),
          headers: {
            'Authorization':
                'Basic ${base64Encode(utf8.encode('$consumerKey:$consumerSecret'))}',
          },
        );

        // Debugging: Print the response status code and body

        if (response.statusCode == 200) {
          final List<dynamic> jsonResponse = json.decode(response.body);

          // Check if the response is empty
          if (jsonResponse.isEmpty) {
            hasMore = false;
          } else {
            allvendorProducts.addAll(
              jsonResponse.map((data) => ProductModel.fromJson(data)).toList(),
            );
            page++; // Increment page to fetch next set of products
          }
        } else {
          // Log different error cases for better understanding
          if (response.statusCode == 401) {
            debugPrint('Unauthorized request: Check your API credentials.');
          } else if (response.statusCode == 404) {
            debugPrint('Endpoint not found: Check the endpoint URL.');
          } else {
            debugPrint(
                'Failed to load products by vendor ID with status code: ${response.statusCode}');
          }
          hasMore = false; // Stop fetching on error
          throw Exception('Failed to load products by vendor ID');
        }
      } catch (e) {
        // Catch and log any exception that occurs during the request
        debugPrint('Error fetching products: $e');
        hasMore = false; // Ensure we break the loop on error
      }
    }

    // Debugging: Print the total number of products fetched
    debugPrint('Total products fetched: ${allvendorProducts.length}');

    return allvendorProducts;
  }
}
