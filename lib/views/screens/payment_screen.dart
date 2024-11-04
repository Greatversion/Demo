import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mambo/providers/selected_address_provider.dart';
import 'package:mambo/routes/app.nameRoutes.dart';
import 'package:mambo/services/Payment%20Functions/payment_services.dart';
import 'package:mambo/utils/Reusable_widgets/app.snackBar.dart';
import 'package:mambo/utils/app.styles.dart';
import 'package:mambo/view%20models/cart_view_model.dart';
import 'package:mambo/services/Payment%20Functions/payment_view_model.dart';
import 'package:provider/provider.dart';

/// `PaymentSuccessScreen` displays a success animation after a payment has been processed.
/// It transitions to the main UI screen after a short delay.
class PaymentSuccessScreen extends StatefulWidget {
  const PaymentSuccessScreen({super.key});

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  double animationHeight = 0; // Height for the animation container
  double animationWidth = 0; // Width for the animation container

  @override
  void initState() {
    super.initState();
    // Initialize animation dimensions
    if (animationHeight == 0) {
      animationHeight = 400;
      animationWidth = 400;
      setState(() {});
    }
    // Timer to shrink animation after 1.9 seconds
    Timer(
      const Duration(milliseconds: 1900),
      () {
        if (animationHeight == 400) {
          animationHeight = 0;
          animationWidth = 0;
          setState(() {});
        }
      },
    );
    // Timer to navigate to the main UI after 3 seconds
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, RoutesName.mainUi);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedContainer(
          duration: const Duration(seconds: 3),
          height: animationHeight,
          width: animationWidth,
          child: Lottie.asset("assets/animations/order_done.json",
              fit: BoxFit.fitWidth), // Lottie animation for order success
        ),
      ),
    );
  }
}

/// `PayButton` is a widget that initiates the payment process when tapped.
/// It verifies that an address is selected and opens the payment checkout.
class PayButton extends StatefulWidget {
  final void Function(bool) setLoading; // Function to set the loading state

  const PayButton({required this.setLoading, super.key});

  @override
  State<PayButton> createState() => _PayButtonState();
}

class _PayButtonState extends State<PayButton> {
  PaymentService _paymentService = PaymentService(); // Payment service instance

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<PaymentViewModel>(context, listen: false);
    provider.initRazorpay(
        context, widget.setLoading); // Initialize payment provider
  }

  @override
  void dispose() {
    super.dispose();
    final provider = Provider.of<PaymentViewModel>(context, listen: false);
    provider.disposeRazorpay(); // Clean up payment provider
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final selectedAddressProvider =
            Provider.of<SelectedAddressProvider>(context, listen: false);

        if (selectedAddressProvider.selectedAddress.isNotEmpty) {
          int amount =
              (Provider.of<CartViewModel>(context, listen: false).totalPrice *
                      100)
                  .toInt(); // Convert total price to integer for payment

          // Open payment checkout with the specified amount
          Provider.of<PaymentViewModel>(context, listen: false)
              .openCheckOut(context, amount);
        } else {
          // Show snack bar if no address is selected
          // customSnackBar(context, 'Please Select an address to proceed.');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Please Select an address to proceed.')),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 10),
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Center(
              child: Text(
                "Proceed to pay", // Button text
                style: AppStyles.whiteColoredText.copyWith(fontSize: 16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
