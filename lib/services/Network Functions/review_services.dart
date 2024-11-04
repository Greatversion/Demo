import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mambo/utils/app.baseurl.dart';

class ReviewService {
  // Base URL for WooCommerce API
  // final String baseUrl = BaseUrl.baseurl;

  // Consumer Key for API authentication
  final String consumerKey = dotenv.env['CONSUMER_KEY']!;

  // Consumer Secret for API authentication
  final String consumerSecret = dotenv.env['CONSUMER_SECRET']!;

  /// Adds a review for a specified product.
  ///
  /// [productId] is the ID of the product being reviewed.
  /// [review] is the content of the review.
  /// [name] is the name of the reviewer.
  /// [email] is the email of the reviewer.
  ///
  /// Returns `true` if the review was successfully added, otherwise `false`.
  Future<bool> addReview(
      int productId, String review, String name, String email) async {
    // URL for adding a review to the product
    print(BaseUrl.baseurl);
    final url = Uri.parse('${BaseUrl.baseurl}wp-json/wc/v3/products/reviews');

    // Making POST request to add the review
    final response = await http.post(
      url,
      body: jsonEncode({
        'product_id': productId,
        'review': review,
        'reviewer': name,
        'reviewer_email': email,
      }),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$consumerKey:$consumerSecret'))}',
      },
    );

    // Check if the review was successfully added
    if (response.statusCode == 201) {
      debugPrint("Successfully reviewed");
      return true; // Review successfully added
    } else {
      debugPrint("Failed to add review");
      return false; // Error occurred while adding the review
    }
  }
}
