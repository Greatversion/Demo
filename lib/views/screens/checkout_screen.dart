// ignore_for_file: unnecessary_null_comparison

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mambo/models/Database%20models/cart_model.dart';
import 'package:mambo/providers/selected_address_provider.dart';
import 'package:mambo/routes/app.nameRoutes.dart';
import 'package:mambo/utils/Cart/product_card_widget.dart';
import 'package:mambo/utils/Error%20Messages/error_widget.dart';
import 'package:mambo/utils/app.colors.dart';
import 'package:mambo/utils/app.constants.dart';
import 'package:mambo/utils/app.styles.dart';
import 'package:mambo/view%20models/address_view_model.dart';
import 'package:mambo/view%20models/cart_view_model.dart';
import 'package:mambo/views/Screens/payment_screen.dart';
import 'package:provider/provider.dart';

/// CheckoutScreen class for displaying the checkout page.
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool _isLoading = false; // State for loading status during payment process
  ErrorMessages errorMessages = ErrorMessages(); // Error messages handler

  /// Method to set loading state
  void _setLoading(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cartViewModel = Provider.of<CartViewModel>(context,
          listen: false); // Access the cart view model
      FirebaseAuth auth =
          FirebaseAuth.instance; // Initialize Firebase Auth instance
      cartViewModel.getUserCart(
          context, auth.currentUser!.email!); // Fetch user's cart items
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      // Display loading screen after payment success
      return const PaymentSuccessScreen();
    }
    // Display checkout screen with cart items and total price
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 80, // Set AppBar height
        title: const Text(
          "Checkout Page",
          style: TextStyle(fontSize: 24), // Title style
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context); // Navigate back on icon press
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: AppStyles.backIconSize, // Back icon size
          ),
        ),
      ),
      body: Consumer<CartViewModel>(
        builder: (context, cartViewModel, child) {
          if (cartViewModel.userCart.isEmpty) {
            return Center(
              child: ErrorDisplayWidget(
                  msg: errorMessages
                      .checkoutPageError()
                      .message, // Error message if cart is empty
                  desc: errorMessages.checkoutPageError().description),
            );
          } else if (cartViewModel.userCart == null) {
            return const Center(
              child:
                  CircularProgressIndicator(), // Show loading indicator while fetching cart
            );
          } else {
            return Scrollbar(
              child: ListView.builder(
                itemCount:
                    cartViewModel.userCart.length, // Display products in cart
                itemBuilder: (context, index) {
                  return ProductCard(
                    index: index,
                    isCartScreen: false,
                    products: ProductCartModel(
                        productName: cartViewModel.userCart[index]
                            .productName, // Display product name
                        productPrice: cartViewModel.userCart[index]
                            .productPrice, // Display product price
                        productID: cartViewModel
                            .userCart[index].productID, // Product ID
                        quantity: cartViewModel
                            .userCart[index].quantity, // Product quantity
                        productImgUrl: cartViewModel
                            .userCart[index].productImgUrl, // Product image URL
                        vendorID:
                            cartViewModel.userCart[index].vendorID, // Vendor ID
                        vendorName: cartViewModel
                            .userCart[index].vendorName, // Vendor name
                        attributes: cartViewModel
                            .userCart[index].attributes, // Product attributes
                        selectedAttributes: cartViewModel.userCart[index]
                            .selectedAttributes), // Selected attributes
                    onDelete: () {}, // Callback for delete action
                  );
                },
              ),
            );
          }
        },
      ),
      bottomNavigationBar: Consumer<CartViewModel>(
        builder: (context, cartViewModel, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(
                color: Colors.grey, // Divider line
              ),
              const SelectAddressButton(), // Button to select shipping address
              const Divider(
                color: Colors.grey, // Divider line
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween, // Display total price and payment button
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total",
                          style: AppStyles.semiBoldText, // Text style for total
                        ),
                        Text(
                            'Rs.${cartViewModel.totalPrice.toInt()}') // Display total price
                      ],
                    ),
                    PayButton(setLoading: _setLoading), // Payment button
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

/// Button widget to select address
class SelectAddressButton extends StatefulWidget {
  const SelectAddressButton({
    super.key,
  });

  @override
  State<SelectAddressButton> createState() => _SelectAddressButtonState();
}

class _SelectAddressButtonState extends State<SelectAddressButton> {
  @override
  void initState() {
    super.initState();
    FirebaseAuth auth =
        FirebaseAuth.instance; // Initialize Firebase Auth instance
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AddressViewModel>(context, listen: false)
          .getUerAddresses(auth.currentUser!.email!); // Fetch user addresses
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _showAddressBottomSheet(context); // Show address bottom sheet on tap
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<SelectedAddressProvider>(
          builder: (context, addressProvider, child) {
            return SizedBox(
              width: double.maxFinite,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    addressProvider.selectedAddress.isEmpty
                        ? "Select address" // Display message if no address is selected
                        : addressProvider.selectedAddress['localAddress'] ??
                            'Select address', // Display selected address
                    style: AppStyles.semiBoldText.copyWith(
                        fontSize:
                            AppConst.isDeviceAPhone() ? 15 : 16), // Text style
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: AppStyles.backIconSize, // Icon size
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Show bottom sheet for selecting an address
  void _showAddressBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Enable scrolling
      builder: (context) {
        return AddressBottomSheet(
          onselected: (address) {
            Provider.of<SelectedAddressProvider>(context, listen: false)
                .setSelectedAddress(address); // Set selected address
          },
          selectedAddresses: const [], // Pass selected addresses
        );
      },
    );
  }
}

/// Bottom sheet widget for displaying and selecting addresses
class AddressBottomSheet extends StatefulWidget {
  final Function(Map<String, String>)
      onselected; // Callback for when an address is selected
  final List<String> selectedAddresses; // List of selected addresses

  const AddressBottomSheet({super.key, 
    required this.onselected,
    required this.selectedAddresses,
  });

  @override
  State<AddressBottomSheet> createState() => _AddressBottomSheetState();
}

class _AddressBottomSheetState extends State<AddressBottomSheet> {
  List<String> selectedAddresses = []; // State for selected addresses

  /// Handle address selection change
  void _onSelectionChanged(Map<String, String> newSelectedAddress) {
    widget.onselected(
        newSelectedAddress); // Trigger callback with new selected address
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15), // Set padding
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Select Shipping Address', // Title for bottom sheet
              style: AppStyles.boldText.copyWith(fontSize: 22), // Text style
            ),
          ),
          Consumer<AddressViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.isLoading) {
                return const Center(
                    child:
                        CircularProgressIndicator()); // Show loading indicator while fetching addresses
              } else if (viewModel.errorMessage.isNotEmpty) {
                return Center(
                    child: Text(
                        viewModel.errorMessage)); // Show error message if any
              } else if (viewModel.usersavedAddresses.isEmpty) {
                return Center(
                    heightFactor: 1.0,
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        const Text(
                          'No Address found', // Message if no address is found
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 18),
                        ),
                        const SizedBox(height: 25),
                        ElevatedButton(
                            style: const ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                    Colors.black)), // Button style
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context,
                                  RoutesName
                                      .addAddress); // Navigate to add address screen
                            },
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.add,
                                  color: Colors.white, // Add icon color
                                ),
                                Text(
                                  'Add',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight
                                          .w500), // Text style for button
                                ),
                              ],
                            )),
                      ],
                    ));
              } else {
                return SizedBox(
                  height: 300, // Set a fixed height for the bottom sheet
                  child: ListView.builder(
                    itemCount: viewModel.usersavedAddresses
                        .length, // List of user saved addresses
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          dense: true,
                          selectedColor: AppColors.primary,
                          shape: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 1.5,
                              color: Color.fromARGB(255, 81, 81,
                                  81), // Border color for address item
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          title: Text(
                            "Address ${index + 1}", // Title for address
                            style: AppStyles.boldText,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(viewModel.usersavedAddresses[index]
                                  .name!), // User's name
                              Text(viewModel.usersavedAddresses[index]
                                  .phoneNumber!), // User's phone number
                              Text(
                                "${viewModel.usersavedAddresses[index].localAddress!}, ${viewModel.usersavedAddresses[index].postcode}", // User's address and postcode
                              ),
                            ],
                          ),
                          onTap: () {
                            _onSelectionChanged({
                              'name': viewModel.usersavedAddresses[index].name!,
                              'phoneNumber': viewModel
                                  .usersavedAddresses[index].phoneNumber!,
                              'localAddress': viewModel
                                  .usersavedAddresses[index].localAddress!,
                              'postcode':
                                  viewModel.usersavedAddresses[index].postcode!,
                              'state':
                                  viewModel.usersavedAddresses[index].state!,
                              'email':
                                  FirebaseAuth.instance.currentUser!.email!,
                              'country':
                                  viewModel.usersavedAddresses[index].country!,
                              'city': viewModel.usersavedAddresses[index]
                                  .city! // User's selected address details
                            });
                            Navigator.pop(
                                context); // Close the bottom sheet after selection
                          },
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
