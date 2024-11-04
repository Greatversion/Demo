import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PaymentService {
  late Razorpay _razorpay;

  void initRazorpay({
    required void Function(PaymentSuccessResponse) onPaymentSuccess,
    required void Function(PaymentFailureResponse) onPaymentError,
    required void Function(ExternalWalletResponse) onExternalWallet,
  }) {
    _razorpay = Razorpay();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, onPaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, onPaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, onExternalWallet);
  }

  void dispose() {
    _razorpay.clear();
  }

  Future<String?> createRazorpayOrder(int amount) async {
    // Replace with your Razorpay key ID and key secret

    try {
      // Make the POST request

      const url = 'https://api.razorpay.com/v1/orders/';
      final authHeader =
          'Basic ${base64Encode(utf8.encode('${dotenv.env['RAZORPAY_KEY_ID']}:${dotenv.env['RAZORPAY_KEY_SECRET']}'))}';

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': authHeader,
        },
        body: jsonEncode({
          'amount': amount, // Amount in paise (e.g., 50000 paise = ₹500.00)
          'currency': 'INR',
        }),
      );
      // Check for success
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        debugPrint('Order created successfully: ${responseData['id']}');
        // orderID = responseData['id'];
        return responseData['id']; // Return the Razorpay order ID
      } else {
        debugPrint(
            'Failed to create order. Status code: ${response.statusCode}');
        debugPrint('Response: ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  void openCheckOut(int amount, String contact, String email) async {
    String? orderID = await createRazorpayOrder(amount);
    var options = {
      'key': dotenv.env['RAZORPAY_KEY_ID'], // Razorpay Key ID
      'amount': amount, // Amount
      'name': 'Mambo',
      'description': 'Payment',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      "order_id": orderID,
      'prefill': {
        'contact': contact,
        'email': email,
      },
      'external': {
        'wallets': ['paytm', 'gpay']
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
