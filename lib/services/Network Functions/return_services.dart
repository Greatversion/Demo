
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mambo/utils/app.baseurl.dart';

/// `ReturnService` handles operations related to WooCommerce orders,
/// including adding notes and updating return statuses.
class ReturnService {
  // Base URL for WooCommerce API
  final String baseUrl = BaseUrl.baseurl;
  
  // Consumer Key for API authentication
  final String consumerKey = '${dotenv.env['CONSUMER_KEY']}';
  
  // Consumer Secret for API authentication
  final String consumerSecret = '${dotenv.env['CONSUMER_SECRET']}';

  /// Adds a note to a specified order.
  ///
  /// [orderId] is the ID of the order to which the note should be added.
  /// [note] is the content of the note.
  ///
  /// Returns an `http.Response` object representing the result of the request.
  Future<http.Response> addOrderNote(String orderId, String note) async {
    final url = '${baseUrl}wp-json/wc/v3/orders/$orderId/notes';
    final authHeader = 'Basic ${base64Encode(utf8.encode('$consumerKey:$consumerSecret'))}';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': authHeader,
      },
      body: jsonEncode({
        'note': note,
        'customer_note': true,
      }),
    );

    return response;
  }

  /// Updates the status of a specified order.
  ///
  /// [orderId] is the ID of the order to be updated.
  /// [status] is the new status for the order.
  ///
  /// Returns an `http.Response` object representing the result of the request.
  Future<http.Response> updateReturnStatus(String orderId, String status) async {
    final url = '${baseUrl}wp-json/wc/v3/orders/$orderId'; // Corrected URL formatting
    final authHeader = 'Basic ${base64Encode(utf8.encode('$consumerKey:$consumerSecret'))}';

    final response = await http.put( // Changed POST to PUT to correctly update an order
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': authHeader,
      },
      body: jsonEncode({
        'status': status,
      }),
    );

    return response;
  }
}
