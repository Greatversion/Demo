

import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mambo/models/Database%20models/order_model.dart';
import 'package:mambo/utils/app.baseurl.dart';

/// `OrderService` provides methods to interact with the order-related
/// endpoints of a WooCommerce API.
class OrderService {
  // Base URL for the API
  final String baseUrl = BaseUrl.baseurl;
  
  // Consumer Key for API authentication
  final String consumerKey = dotenv.env['CONSUMER_KEY']!;
  
  // Consumer Secret for API authentication
  final String consumerSecret = dotenv.env['CONSUMER_SECRET']!;

  /// Creates a new order in WooCommerce.
  ///
  /// Sends a POST request to the WooCommerce API with the order data.
  ///
  /// Returns a `Map<String, dynamic>` containing the response data if successful.
  /// Throws an exception if the request fails.
  Future<Map<String, dynamic>> createOrder(OrderModel order) async {
    // Construct the URL for the WooCommerce orders endpoint
    final url = Uri.parse('${baseUrl}wp-json/wc/v3/orders');
    
    // Encode credentials for Basic Authentication
    final credentials = base64Encode(utf8.encode('$consumerKey:$consumerSecret'));
    
    // Define headers for the HTTP request
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $credentials',
    };

    // Send the POST request with the order data in the request body
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(order.toJson()),
    );

    // Check the response status code
    if (response.statusCode == 201) {
      // Parse and return the JSON response if successful
      return jsonDecode(response.body);
    } else {
      // Throw an exception if the request fails
      throw Exception('Failed to create an order: ${response.body}');
    }
  }
}
