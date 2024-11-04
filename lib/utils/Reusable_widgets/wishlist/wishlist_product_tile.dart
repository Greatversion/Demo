import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mambo/models/Database%20models/cart_model.dart';
import 'package:mambo/models/Network%20models/product_model.dart';
import 'package:mambo/providers/online_connectivity_provider.dart';
import 'package:mambo/services/Notifications/Local%20Notifications/app.local_notification.dart';
import 'package:mambo/view%20models/cart_view_model.dart';
import 'package:provider/provider.dart';

import 'package:mambo/models/Database%20models/wishlist_model.dart';
import 'package:mambo/providers/wishlist_action_provider.dart';
import 'package:mambo/routes/app.nameRoutes.dart';
import 'package:mambo/utils/Reusable_widgets/explore/add_to_wishlist_button.dart';
import 'package:mambo/utils/Reusable_widgets/explore/price_tag_widget.dart';
import 'package:mambo/utils/app.styles.dart';
import 'package:mambo/view%20models/product_view_model.dart';
import 'package:mambo/view%20models/wishlist_view_model.dart';

class WishlistProductTiles extends StatefulWidget {
  final int index;
  final int productID;

  const WishlistProductTiles({
    super.key,
    required this.index,
    required this.productID,
  });

  @override
  State<WishlistProductTiles> createState() => _WishlistProductTilesState();
}

class _WishlistProductTilesState extends State<WishlistProductTiles> {
  @override
  Widget build(BuildContext context) {
    bool isProductSelected(WishlistactionProvider value, int index) {
      return value.currentInd == index && value.isSelected;
    }

    void showDeleteDialog() {
      showDialog(
        context: context,
        builder: (context) => SimpleDialog(
          contentPadding: const EdgeInsets.all(20),
          elevation: 2,
          children: [
            Text(
              "Delete from wishlist?",
              style: AppStyles.boldText,
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Reset the selection state after deletion
                      Provider.of<WishlistactionProvider>(context,
                              listen: false)
                          .resetSelection();
                    },
                    child: Text(
                      "Cancel",
                      style: AppStyles.regularText
                          .copyWith(fontWeight: FontWeight.w400, fontSize: 16),
                    )),
                Consumer<WishlistViewModel>(
                    builder: (context, wishlistViewModel, child) {
                  return OutlinedButton(
                      style: const ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll(Colors.black)),
                      onPressed: () {
                        wishlistViewModel.deleteWishlistItem(
                          WishListModel(
                            vendor: Vendor(
                              vendorId: wishlistViewModel
                                  .userwishlist[widget.index].vendor!.vendorId,
                              vendorName: wishlistViewModel
                                  .userwishlist[widget.index]
                                  .vendor!
                                  .vendorName,
                              vendorStore: wishlistViewModel
                                  .userwishlist[widget.index]
                                  .vendor!
                                  .vendorStore,
                            ),
                            product: Product(
                              productId: wishlistViewModel
                                  .userwishlist[widget.index]
                                  .product!
                                  .productId,
                              productName: wishlistViewModel
                                  .userwishlist[widget.index]
                                  .product!
                                  .productName,
                            ),
                            price: wishlistViewModel
                                .userwishlist[widget.index].price,
                            category: wishlistViewModel
                                .userwishlist[widget.index].category,
                            imageUrl: wishlistViewModel
                                .userwishlist[widget.index].imageUrl,
                            createdAt: DateTime.now(),
                          ),
                        );
                        // Reset the selection state after navigation
                        Provider.of<WishlistactionProvider>(context,
                                listen: false)
                            .resetSelection();
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Confirm",
                        style: AppStyles.regularText.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 16),
                      ));
                }),
              ],
            )
          ],
        ),
      );
    }

    return Consumer5<WishlistactionProvider, WishlistViewModel, ProductProvider,
            CartViewModel, ConnectivityService>(
        builder: (context, value, wishlistViewModel, productProvider,
            cartProvider, connectivityService, child) {
      return GestureDetector(
        onLongPress: () {
          value.setCurrentIndex(widget.index);
          value.selectProduct(widget.index);
          debugPrint("Long pressed: ${widget.index}");
        },
        onTap: () async {
          if (isProductSelected(value, widget.index)) {
            value.deSelectProduct();
          } else {
            debugPrint("Navigate to the product-${widget.index} page");

            if (connectivityService.isOnline) {
              Navigator.pushNamed(
                context,
                RoutesName.productScreen,
                arguments: {
                  "isPushedFromReelScreen": false,
                  "productID": widget.productID,
                  "index": widget.index,
                  "screenName": "Wishlist",
                },
              ).then((_) {
                // Reset the selection state after navigation
                Provider.of<WishlistactionProvider>(context, listen: false)
                    .resetSelection();
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Please Connect to the Internet")));
            }
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Stack(
            children: [
              Opacity(
                opacity: isProductSelected(value, widget.index) ? 0.5 : 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Stack(
                    children: [
                      // Product image...
                      CachedNetworkImage(
                        imageUrl: wishlistViewModel
                            .userwishlist[widget.index].imageUrl!,
                        placeholder: (context, url) => Container(
                          height: 200,
                          color: Colors.grey[300],
                          child:
                              const Center(child: CircularProgressIndicator()),
                        ),
                        errorWidget: (context, url, error) => Container(
                          height: 200,
                          width: double.infinity,
                          color: Colors.grey[300],
                          child: const Icon(Icons.image_not_supported_rounded,
                              size: 40),
                        ),
                      ),
                      // Price tag
                      PriceTagWidget(
                        productPice:
                            "₹ ${wishlistViewModel.userwishlist[widget.index].price}",
                      ),
                      AddToWishListButton(index: widget.index)
                    ],
                  ),
                ),
              ),

              // Visible on long press on the product
              Positioned(
                bottom: 4,
                top: 4,
                left: 4,
                right: 4,
                child: Visibility(
                  visible: isProductSelected(value, widget.index),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // Delete from wishlist
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white70,
                              borderRadius: BorderRadius.circular(100)),
                          child: IconButton(
                              onPressed: () {
                                showDeleteDialog();
                              },
                              iconSize: AppStyles.iconSize - 5,
                              icon: const Icon(
                                Icons.delete_outline,
                              )),
                        ),

                        // Add to cart
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white70,
                              borderRadius: BorderRadius.circular(100)),
                          child: IconButton(
                              onPressed: () {
                                productProvider.fetchProductById(
                                    wishlistViewModel.userwishlist[widget.index]
                                        .product!.productId!);
                                cartProvider
                                    .addItemInCart(ProductCartModel(
                                  productName: wishlistViewModel
                                      .userwishlist[widget.index]
                                      .product!
                                      .productName!,
                                  productPrice: wishlistViewModel
                                      .userwishlist[widget.index].price!,
                                  productID: wishlistViewModel
                                      .userwishlist[widget.index]
                                      .product!
                                      .productId!,
                                  quantity: 1,
                                  productImgUrl: wishlistViewModel
                                      .userwishlist[widget.index].imageUrl!,
                                  vendorID: wishlistViewModel
                                      .userwishlist[widget.index]
                                      .vendor!
                                      .vendorId!,
                                  vendorName: wishlistViewModel
                                      .userwishlist[widget.index]
                                      .vendor!
                                      .vendorStore!,
                                  attributes:
                                      productProvider.productByID!.attributes,
                                  selectedAttributes: {},
                                ))
                                    .then((_) async {
                                  if (mounted) {
                                    await LocalNotificationSevice.showNotifications(
                                        title: "Mambo • Cart",
                                        body:
                                            '${wishlistViewModel.userwishlist[widget.index].product!.productName!} by ${wishlistViewModel.userwishlist[widget.index].vendor!.vendorStore!} added to Cart');
                                    // Reset the selection state after adding to cart
                                    Provider.of<WishlistactionProvider>(context,
                                            listen: false)
                                        .resetSelection();
                                  }
                                });
                              },
                              iconSize: AppStyles.iconSize - 5,
                              icon: const Icon(Icons.shopping_cart_outlined)),
                        ),
                      ]),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
