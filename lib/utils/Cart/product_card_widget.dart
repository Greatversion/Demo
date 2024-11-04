// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mambo/providers/online_connectivity_provider.dart';
import 'package:provider/provider.dart';

import 'package:mambo/models/Database%20models/cart_model.dart';
import 'package:mambo/providers/quantity_provider.dart';
import 'package:mambo/routes/app.nameRoutes.dart';
import 'package:mambo/utils/Cart/selection_option_widget.dart';
import 'package:mambo/utils/app.constants.dart';
import 'package:mambo/utils/app.styles.dart';
import 'package:mambo/view%20models/cart_view_model.dart';

class ProductCard extends StatelessWidget {
  final int index;
  final bool isCartScreen;
  final void Function() onDelete;
  final ProductCartModel products;

  const ProductCard({
    super.key,
    required this.index,
    required this.isCartScreen,
    required this.onDelete,
    required this.products,
  });

  void _onOptionSelected(
      BuildContext context, String attribute, String option) {
    final cartViewModel = Provider.of<CartViewModel>(context, listen: false);
    products.selectedAttributes[attribute] = option;
    cartViewModel.updateSelectedAttributes(
        products.productID, products.selectedAttributes);
  }

  @override
  Widget build(BuildContext context) {
    final String productId = products.productID.toString();
    final quantityProvider = Provider.of<QuantityProvider>(context);

    return SingleChildScrollView(
      child: Consumer2<CartViewModel, ConnectivityService>(
        builder: (context, cartViewModel, connectivityService, child) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: double.maxFinite,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start, //modified
                    children: [
                      Expanded(
                        flex: 2,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: InkWell(
                            onTap: () {
                              if (connectivityService.isOnline) {
                                Navigator.pushNamed(
                                  context,
                                  RoutesName.productScreen,
                                  arguments: {
                                    "isPushedFromReelScreen": false,
                                    "productID": products.productID,
                                    "index": index,
                                    "screenName": "My Cart"
                                  },
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        duration: Duration(seconds: 1),
                                        content: Text(
                                            "Please Connect to the Internet")));
                              }
                            },
                            child: CachedNetworkImage(
                              imageUrl: products.productImgUrl,
                              height:
                                  AppConst.isDeviceAPhone() ? 155 : 150 + 40,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                height:
                                    AppConst.isDeviceAPhone() ? 155 : 150 + 40,
                                color: Colors.grey[300],
                                child: const Center(
                                    child: CircularProgressIndicator()),
                              ),
                              errorWidget: (context, url, error) => Container(
                                height:
                                    AppConst.isDeviceAPhone() ? 155 : 150 + 40,
                                width: double.infinity,
                                color: Colors.grey[300],
                                child: const Icon(
                                  Icons.image_not_supported_rounded,
                                  size: 40,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    products.productName,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: AppStyles.semiBoldText
                                        .copyWith(fontSize: 15),
                                  ),
                                ),
                                Text(
                                  "Rs. ${products.productPrice}",
                                  style: AppStyles.regularText
                                      .copyWith(fontSize: 15),
                                ),
                              ],
                            ),
                            Text(products.vendorName),
                            const SizedBox(height: 10),
                            // Differentiate between Cart and Checkout Screen
                            isCartScreen
                                ? Column(
                                    children: List.generate(
                                      products.attributes.length,
                                      (index) {
                                        final attribute =
                                            products.attributes[index];
                                        return attribute != null
                                            ? Column(
                                                children: [
                                                  SelectionOptionCartWidget(
                                                    optionLabel: products
                                                                .selectedAttributes[
                                                            attribute.name] ??
                                                        attribute.options.first,
                                                    optionList:
                                                        attribute.options,
                                                    onOptionSelected:
                                                        (selectedAttribute) {
                                                      _onOptionSelected(
                                                          context,
                                                          attribute.name!,
                                                          selectedAttribute);
                                                    },
                                                  ),
                                                  const SizedBox(height: 8),
                                                ],
                                              )
                                            : const SizedBox.shrink();
                                      },
                                    ),
                                  )
                                : Column(
                                    children: List.generate(
                                      products.attributes.length,
                                      (index) {
                                        final attribute =
                                            products.attributes[index];
                                        final selectedOption = products
                                            .selectedAttributes[attribute.name];
                                        return selectedOption != null
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Text(
                                                        "${attribute.name} : ",
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      )
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text(
                                                        selectedOption,
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      )
                                                    ],
                                                  ),
                                                  // const SizedBox(height: 6),
                                                ],
                                              )
                                            : const SizedBox.shrink();
                                      },
                                    ),
                                  ),
                            // const SizedBox(height: 2),
                            isCartScreen
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              quantityProvider
                                                  .decreaseQty(productId);
                                              cartViewModel
                                                  .updateProductQuantity(
                                                      productId,
                                                      quantityProvider
                                                          .getQuantity(
                                                              productId));
                                            },
                                            child: Icon(
                                              Icons.remove,
                                              color: Colors.black54,
                                              size: AppStyles.iconSize + 5,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(7),
                                                border: Border.all(
                                                    color: Colors.grey,
                                                    width: 0.7)),
                                            child: Text(
                                              quantityProvider
                                                  .getQuantity(productId)
                                                  .toString(),
                                              style:
                                                  const TextStyle(fontSize: 20),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          InkWell(
                                            onTap: () {
                                              quantityProvider
                                                  .increaseQty(productId);
                                              cartViewModel
                                                  .updateProductQuantity(
                                                      productId,
                                                      quantityProvider
                                                          .getQuantity(
                                                              productId));
                                            },
                                            child: Icon(
                                              Icons.add,
                                              color: Colors.black54,
                                              size: AppStyles.iconSize + 5,
                                            ),
                                          )
                                        ],
                                      ),
                                      IconButton(
                                        onPressed: onDelete,
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Quantity : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        "${quantityProvider.getQuantity(productId)} units",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w400),
                                      )
                                    ],
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Text(
                      "Estimated arrival ${DateFormat('MMMM d, yyyy').format(DateTime.now().add(const Duration(days: 7)))}"),
                ),
                const Divider(color: Colors.grey),
              ],
            ),
          );
        },
      ),
    );
  }
}
