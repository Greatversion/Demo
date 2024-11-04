import 'package:flutter/material.dart';
import 'package:mambo/models/Database%20models/cart_model.dart';
import 'package:mambo/services/Payment%20Functions/payment_services.dart';
import 'package:provider/provider.dart';
import 'package:mambo/view%20models/order_view_model.dart';
import 'package:mambo/view%20models/cart_view_model.dart';
import 'package:mambo/providers/selected_address_provider.dart';
import 'package:mambo/models/Database%20models/order_model.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentViewModel with ChangeNotifier {
  final PaymentService _paymentService = PaymentService();

  void initRazorpay(BuildContext context, void Function(bool) setLoading) {
    _paymentService.initRazorpay(
      onPaymentSuccess: (response) =>
          _handlePaymentSuccess(response, context, setLoading),
      onPaymentError: _handlePaymentError,
      onExternalWallet: _handleExternalWallet,
    );
  }

  void disposeRazorpay() {
    _paymentService.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response,
      BuildContext context, void Function(bool) setLoading) async {
    setLoading(true);
    final orderViewModel = Provider.of<OrderViewModel>(context, listen: false);
    final cartViewModel = Provider.of<CartViewModel>(context, listen: false);
    final selectedAddressProvider =
        Provider.of<SelectedAddressProvider>(context, listen: false);

    if (cartViewModel.userCart.isNotEmpty) {
      try {
        OrderModel orderModel = OrderModel(
          paymentMethod: "bacs",
          paymentMethodTitle: "Direct Bank Transfer",
          setPaid: true,
          billing: Ing(
            firstName: selectedAddressProvider.selectedAddress['name'],
            lastName: "",
            address1: selectedAddressProvider.selectedAddress['localAddress'],
            address2: "",
            city: selectedAddressProvider.selectedAddress['city'],
            state: selectedAddressProvider.selectedAddress['state'],
            postcode: selectedAddressProvider.selectedAddress['postcode'],
            country: selectedAddressProvider.selectedAddress['country'],
            email: selectedAddressProvider.selectedAddress['email'],
            phone: selectedAddressProvider.selectedAddress['phoneNumber'],
          ),
          shipping: Ing(
            firstName: selectedAddressProvider.selectedAddress['name'],
            lastName: "",
            address1: selectedAddressProvider.selectedAddress['localAddress'],
            address2: "",
            city: selectedAddressProvider.selectedAddress['city'],
            state: selectedAddressProvider.selectedAddress['state'],
            postcode: selectedAddressProvider.selectedAddress['postcode'],
            country: selectedAddressProvider.selectedAddress['country'],
            email: selectedAddressProvider.selectedAddress['email'],
            phone: selectedAddressProvider.selectedAddress['phoneNumber'],
          ),
          lineItems: convertCartToLineItems(cartViewModel.userCart),
          shippingLines: [
            ShippingLine(
              methodId: "flat_rate",
              methodTitle: "Flat Rate",
              total: cartViewModel.totalPrice.toString(),
            )
          ],
          paymentID: response.paymentId ?? "none",
          orderID: response.orderId ?? "none",
          orderTime: DateTime.now().toUtc(),
        );

        // Create the order
        await orderViewModel.createOrder(orderModel);

        // Save the order data into FireStore Database
        await orderViewModel.addOrder((orderViewModel.response)
            .putIfAbsent(
                "razorPayOrderID", () => response.orderId ?? "No payment")
            .putIfAbsent(
                "razorPayPaymentID", () => response.paymentId ?? "No payment"));

        // Clear the cart after order processed
        for (var i in cartViewModel.userCart) {
          cartViewModel.deleteCartItem(i.productID.toString());
        }
      } catch (e) {
        debugPrint("Failed to create order: $e");
      } finally {
        setLoading(false);
      }
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger(
        child: SnackBar(
            content:
                Text("Payment Error: ${response.code} - ${response.message}")));

    debugPrint("Payment Error: ${response.code} - ${response.message}");
    // Handle payment error
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger(
        child:
            SnackBar(content: Text("External Wallet: ${response.walletName}")));
    debugPrint("External Wallet: ${response.walletName}");
    // Handle external wallet
  }

  void openCheckOut(BuildContext context, int amount) {
    final selectedAddressProvider =
        Provider.of<SelectedAddressProvider>(context, listen: false);

    _paymentService.openCheckOut(
      amount,
      selectedAddressProvider.selectedAddress['phoneNumber']!,
      selectedAddressProvider.selectedAddress['email']!,
    );
  }

  List<LineItem> convertCartToLineItems(List<ProductCartModel> cartItems) {
    return cartItems.map((cartItem) {
      return LineItem(
        productId: cartItem.productID,
        quantity: cartItem.quantity,
        variationId: 0,
      );
    }).toList();
  }
}
