// ignore_for_file: deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart'; // Importing Firebase authentication package
import 'package:flutter/material.dart'; // Importing Flutter material design package
import 'package:mambo/models/Database%20models/cart_model.dart'; // Importing Cart model for data structure
import 'package:mambo/providers/nav_bar_provider.dart';
import 'package:mambo/routes/app.nameRoutes.dart';
import 'package:mambo/utils/Cart/checkout_button.dart'; // Importing custom checkout button widget
import 'package:mambo/utils/Cart/product_card_widget.dart'; // Importing custom product card widget
import 'package:mambo/utils/Error%20Messages/error_widget.dart'; // Importing custom error widget for displaying errors
import 'package:mambo/utils/Reusable_widgets/nav_bar/bottom_nav_bar.dart'; // Importing reusable bottom navigation bar widget
import 'package:mambo/utils/app.styles.dart'; // Importing app styles for consistent text and UI styling
import 'package:mambo/view%20models/cart_view_model.dart'; // Importing CartViewModel for managing cart state and logic
import 'package:provider/provider.dart'; // Importing Provider for state management

// CartScreen widget that displays the user's shopping cart
class CartScreen extends StatefulWidget {
  const CartScreen({super.key}); // Constructor for CartScreen widget

  @override
  State<CartScreen> createState() =>
      _CartScreenState(); // Creates state for the CartScreen widget
}

class _CartScreenState extends State<CartScreen> {
  ErrorMessages errorMessages =
      ErrorMessages(); // Instance of ErrorMessages to display errors

  @override
  void initState() {
    super.initState(); // Calling the superclass's initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Adds a callback after the first frame is rendered
      final auth = FirebaseAuth.instance; // Getting instance of FirebaseAuth
      final viewModel = Provider.of<CartViewModel>(context,
          listen: false); // Accessing CartViewModel
      viewModel.getUserCart(context,
          auth.currentUser!.email!); // Fetches user cart data using email
    });
  }

  @override
  Widget build(BuildContext context) {
    final navBarProvider = Provider.of<NavBarProvider>(context, listen: false);
    return WillPopScope(
      onWillPop: () async {
        navBarProvider.tapOnNavBarItem(0, context);
        // Navigator.pushReplacementNamed(context, RoutesName.mainUi);

        return false; // Prevent the default pop behavior
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true, // Centers the title in the AppBar
          title: const Text(
            "My Cart", // Title text for the AppBar
            style: TextStyle(fontSize: 24), // Font size for the title
          ),
          toolbarHeight: 80, // Modified toolbar height
          leading: IconButton(
            onPressed: () {
              navBarProvider.tapOnNavBarItem(0, context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: AppStyles.backIconSize, // Custom size for the back icon
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              // Expands the child to fill the available space
              child: Consumer<CartViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.isLoading) {
                    // Checks if the cart is loading
                    return const Center(
                        child:
                            CircularProgressIndicator()); // Shows a loading spinner
                  } else if (viewModel.errorMessage.isNotEmpty) {
                    // Checks if there is an error message
                    debugPrint(viewModel
                        .errorMessage); // Prints the error message to the debug console
                    return const Center(
                        child: Text("Something went wrong, please restart the app.")); // Displays the error message
                  } else if (viewModel.userCart.isEmpty) {
                    // Checks if the user's cart is empty
                    return Center(
                      child: ErrorDisplayWidget(
                          msg: errorMessages
                              .cartPageError()
                              .message, // Error message to display
                          desc: errorMessages
                              .cartPageError()
                              .description), // Description of the error
                    );
                  } else {
                    return ListView.builder(
                      // Builds a list of cart items
                      itemCount: viewModel.userCart.length +
                          1, // Number of items in the cart + checkout summary
                      itemBuilder: (context, index) {
                        if (index < viewModel.userCart.length) {
                          // Checks if the current index is less than the number of cart items
                          final cartItem = viewModel.userCart[
                              index]; // Gets the cart item at the current index
                          return Padding(
                            padding: const EdgeInsets.all(
                                8.0), // Padding around each cart item
                            child: ProductCard(
                              products: ProductCartModel(
                                  productName:
                                      cartItem.productName, // Product name
                                  productPrice:
                                      cartItem.productPrice, // Product price
                                  productID: cartItem.productID, // Product ID
                                  quantity:
                                      cartItem.quantity, // Product quantity
                                  productImgUrl: cartItem
                                      .productImgUrl, // Product image URL
                                  vendorID: cartItem.vendorID, // Vendor ID
                                  vendorName:
                                      cartItem.vendorName, // Vendor name
                                  attributes:
                                      cartItem.attributes, // Product attributes
                                  selectedAttributes: cartItem
                                      .selectedAttributes), // Selected attributes
                              onDelete: () {
                                viewModel.deleteCartItem(cartItem.productID
                                    .toString()); // Deletes the item from the cart
                                setState(() {
                                  viewModel.userCart.removeAt(
                                      index); // Removes the item from the UI list
                                });
                              },
                              isCartScreen:
                                  true, // Indicates that the product card is in the cart screen
                              index: index, // Index of the product card
                            ),
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.all(
                                8.0), // Padding around checkout summary
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[
                                    100], // Background color of the summary container
                                borderRadius: BorderRadius.circular(
                                    12), // Rounded corners for the summary container
                              ),
                              child: Column(
                                children: [
                                  // Display item total
                                  Padding(
                                    padding: const EdgeInsets.all(
                                        10.0), // Padding around total row
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween, // Space between total label and value
                                      children: [
                                        const Text(
                                          "Item(s) total :", // Total label
                                          style: TextStyle(
                                              fontSize:
                                                  18), // Font size for the total label
                                        ),
                                        Text(
                                          "Rs. ${viewModel.totalPrice} ", // Total value
                                          style: const TextStyle(
                                              fontSize:
                                                  18), // Font size for the total value
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Display item discount
                                  const Padding(
                                    padding: EdgeInsets.all(
                                        10.0), // Padding around discount row
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween, // Space between discount label and value
                                      children: [
                                        Text(
                                          "Item(s) discount :", // Discount label
                                          style: TextStyle(
                                              fontSize:
                                                  18), // Font size for the discount label
                                        ),
                                        Text(
                                          "Not Applicable", // Discount value
                                          style: TextStyle(
                                              fontSize:
                                                  16), // Font size for the discount value
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Divider line
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal:
                                            6.0), // Padding around divider line
                                    child: Divider(
                                      color: Colors.grey[
                                          400], // Color of the divider line
                                    ),
                                  ),
                                  // Display total amount after discount
                                  Padding(
                                    padding: const EdgeInsets.all(
                                        10.0), // Padding around final total row
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween, // Space between total label and value
                                      children: [
                                        const Text(
                                          "Item(s) total:", // Final total label
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight
                                                  .w600), // Font size and weight for the label
                                        ),
                                        Text(
                                          "Rs. ${viewModel.totalPrice} ", // Final total value
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight
                                                  .w600), // Font size and weight for the value
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height:
                                        5, // Spacing below the summary section
                                  )
                                ],
                              ),
                            ),
                          );
                        }
                      },
                    );
                  }
                },
              ),
            ),
            Consumer<CartViewModel>(builder: (context, cartViewModel, child) {
              // Builds checkout button if cart is not empty
              if (cartViewModel.userCart.isNotEmpty) {
                return const CheckOutButton(); // Displays the checkout button
              } else {
                return const SizedBox(); // Empty space if cart is empty
              }
            }),
          ],
        ),
        bottomNavigationBar:
            const BottomNavBarWidget(), // Reusable bottom navigation bar
      ),
    );
  }
}
