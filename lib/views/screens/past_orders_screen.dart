// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mambo/models/Database%20models/cart_model.dart';
import 'package:mambo/providers/online_connectivity_provider.dart';
import 'package:mambo/routes/app.nameRoutes.dart';
import 'package:mambo/utils/Error%20Messages/error_widget.dart';
import 'package:mambo/utils/app.colors.dart';
import 'package:mambo/utils/app.styles.dart';
import 'package:mambo/view%20models/cart_view_model.dart';
import 'package:mambo/view%20models/order_view_model.dart';
import 'package:mambo/view%20models/product_view_model.dart';
import 'package:mambo/view%20models/return_request_view_model.dart';
import 'package:mambo/utils/No%20Internet/no_internet_widget.dart';
import 'package:provider/provider.dart';

/// `PastOrderScreen` displays a list of the user's past orders.
/// It allows users to view order details, reorder items, and request returns.
class PastOrderScreen extends StatefulWidget {
  const PastOrderScreen({super.key});

  @override
  State<PastOrderScreen> createState() => _PastOrderScreenState();
}

class _PastOrderScreenState extends State<PastOrderScreen> {
  bool _isReordering =
      false; // Indicates whether a reorder action is in progress
  ErrorMessages errorMessages =
      ErrorMessages(); // Utility to fetch error messages

  @override
  void initState() {
    super.initState();
    // Fetch the user's past orders once the widget is fully initialized.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<OrderViewModel>(context, listen: false);
      FirebaseAuth auth =
          FirebaseAuth.instance; // Obtain Firebase Auth instance

      // Fetch user's orders based on the current user's email
      provider.getUserOrders(auth.currentUser!.email!);
    });
  }

  /// Handles the reordering of a product.
  /// Fetches product details, adds the product to the cart, and navigates to the cart screen.
  void _reorderProduct(BuildContext context, ProductProvider provider,
      CartViewModel cartProvider, Map<String, dynamic> item) async {
    setState(() {
      _isReordering = true; // Set loading state to true
    });

    // Fetch product details by product ID
    await provider.fetchProductById(item["product_id"]);
    // Add the fetched product to the cart
    await cartProvider.addItemInCart(ProductCartModel(
      productName: provider.productByID!.name!,
      productPrice: (provider.productByID!.onSale!)
          ? provider.productByID!.salePrice!
          : provider.productByID!.price!,
      productID: provider.productByID!.id!,
      quantity: 1,
      productImgUrl: provider.productByID!.images.first.src!,
      vendorID: provider.productByID!.store!.id!,
      vendorName: provider.productByID!.store!.shopName!,
      attributes: provider.productByID!.attributes,
      selectedAttributes: {},
    ));

    setState(() {
      _isReordering = false; // Reset loading state after reordering
    });

    if (mounted) {
      // Navigate to the cart screen to review the reordered item
      Navigator.of(context, rootNavigator: true)
          .pushReplacementNamed(RoutesName.cartScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 14.0),
            child: Icon(
              Icons.arrow_back_ios,
              size: AppStyles.backIconSize, // Size of the back arrow icon
            ),
          ),
        ),
        title: const Text(
          "Past Orders", // Title of the screen
          style: TextStyle(fontSize: 24),
        ),
      ),
      body: Stack(
        children: [
          Consumer3<ProductProvider, CartViewModel, ReturnRequestViewModel>(
            builder: (context, provider, cartProvider, returnViewModel, child) {
              return Column(
                children: [
                  Expanded(
                    child: Consumer2<OrderViewModel, ConnectivityService>(
                      builder: (context, orderViewModel, connectivity, child) {
                        if (orderViewModel.isLoading) {
                          // Show loading indicator while fetching orders
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (orderViewModel.errorMessage.isNotEmpty) {
                          // Display error message if there was an issue fetching orders
                          return Center(
                              child: Text(orderViewModel.errorMessage));
                        } else if (orderViewModel.pastOrders.isEmpty) {
                          // Display error widget if no past orders are found
                          return Center(
                            child: ErrorDisplayWidget(
                                msg: errorMessages.profilePageError().message,
                                desc: errorMessages
                                    .profilePageError()
                                    .description),
                          );
                        } else if (!connectivity.isOnline) {
                          // Display no internet widget if the user is offline
                          return const NoInternetWidget();
                        } else {
                          // Display a list of past orders
                          return ListView.builder(
                            itemCount: orderViewModel.responseData.length,
                            itemBuilder: (context, index) {
                              final orderData =
                                  orderViewModel.responseData[index];
                              final lineItems = orderData["line_items"];
                              final orderNumber = orderData["number"];

                              return Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ...lineItems.map<Widget>((item) {
                                      // Display each product in the order
                                      return SizedBox(
                                        key: ValueKey(item["product_id"]),
                                        height: 170,
                                        width: double.maxFinite,
                                        child: Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(
                                                  18), // Rounded corners for product image
                                              child: GestureDetector(
                                                onTap: () {
                                                  if (connectivity.isOnline) {
                                                    Navigator.pushNamed(
                                                      context,
                                                      RoutesName.productScreen,
                                                      arguments: {
                                                        "isPushedFromReelScreen":
                                                            false,
                                                        "productID":
                                                            item["product_id"],
                                                        "index": index,
                                                        "screenName":
                                                            "Past Orders",
                                                      },
                                                    );
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                            const SnackBar(
                                                                duration:
                                                                    Duration(
                                                                        seconds:
                                                                            1),
                                                                content: Text(
                                                                    "Please Connect to the Internet")));
                                                  }
                                                },
                                                child: CachedNetworkImage(
                                                  imageUrl: item["image"]
                                                          ["src"] ??
                                                      '', // URL for product image
                                                  width: 140,
                                                  height: 150,
                                                  placeholder: (context, url) =>
                                                      Container(
                                                    width: 140,
                                                    height: 150,
                                                    color: Colors.grey[300],
                                                    child: const Center(
                                                        child:
                                                            CircularProgressIndicator()),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Container(
                                                    width: 140,
                                                    height: 150,
                                                    color: Colors.grey[300],
                                                    child:
                                                        const Icon(Icons.error),
                                                  ),
                                                  fit: BoxFit
                                                      .cover, // Fit the image within the area
                                                  // Error widget for image loading failure
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Flexible(
                                                        flex: 1,
                                                        child: Text(
                                                          item["name"] ??
                                                              'Unknown', // Product name
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                          style: AppStyles
                                                              .regularText
                                                              .copyWith(
                                                                  fontSize: 18),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    "₹ ${item["subtotal"]}, units: ${item["quantity"]}", // Product price and quantity
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Text(
                                                    "# $orderNumber", // Order number
                                                    style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  orderData["orderTime"] == null
                                                      ? const Text(
                                                          "Unavailable Timing")
                                                      : Text(orderData[
                                                              "orderTime"]
                                                          .toString()), // Order time
                                                  const SizedBox(height: 10),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      FilledButton(
                                                        style: FilledButton
                                                            .styleFrom(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      15),
                                                        ),
                                                        onPressed: () {
                                                          if (connectivity
                                                              .isOnline) {
                                                            _reorderProduct(
                                                                context,
                                                                provider,
                                                                cartProvider,
                                                                item);
                                                          } else {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(const SnackBar(
                                                                    duration: Duration(
                                                                        seconds:
                                                                            1),
                                                                    content: Text(
                                                                        "Please Connect to the Internet")));
                                                          }
                                                        },
                                                        child: const Text(
                                                          "Re-order",
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      returnViewModel
                                                              .isRequestSent(
                                                                  orderNumber)
                                                          ? ElevatedButton(
                                                              onPressed:
                                                                  () {}, // Disabled button if return request is already sent
                                                              child: const Icon(
                                                                  Icons
                                                                      .check_circle_rounded,
                                                                  color: AppColors
                                                                      .primary))
                                                          : OutlinedButton(
                                                              style: OutlinedButton.styleFrom(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          15),
                                                                  side: const BorderSide(
                                                                      width:
                                                                          1.5)),
                                                              onPressed: () {
                                                                // Navigate to return screen with necessary arguments
                                                                if (connectivity
                                                                    .isOnline) {
                                                                  Navigator
                                                                      .pushNamed(
                                                                    context,
                                                                    RoutesName
                                                                        .returnScreen,
                                                                    arguments: {
                                                                      "orderID":
                                                                          orderNumber,
                                                                      "productID":
                                                                          item["product_id"]
                                                                              .toString(),
                                                                      "productName":
                                                                          item[
                                                                              "name"],
                                                                    },
                                                                  );
                                                                } else {
                                                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                                      duration: Duration(
                                                                          seconds:
                                                                              1),
                                                                      content: Text(
                                                                          "Please Connect to the Internet")));
                                                                }
                                                              },
                                                              child: const Text(
                                                                "Return",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              );
            },
          ),
          if (_isReordering)
            // Display a loading overlay while a reorder action is in progress
            Container(
              color:
                  Colors.black.withOpacity(0.2), // Semi-transparent background
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
