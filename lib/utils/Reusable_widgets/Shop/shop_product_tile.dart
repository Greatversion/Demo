// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mambo/models/Database%20models/wishlist_model.dart';
import 'package:mambo/models/Network%20models/product_model.dart';
import 'package:mambo/services/Notifications/Local%20Notifications/app.local_notification.dart';
import 'package:mambo/utils/Reusable_widgets/explore/price_tag_widget.dart';
import 'package:mambo/utils/app.styles.dart';
import 'package:mambo/view%20models/wishlist_view_model.dart';
import 'package:provider/provider.dart';
// import 'package:mambo/models/Network%20models/review_model.dart';
import 'package:mambo/utils/Reusable_widgets/Shop/shop_atc_button.dart';
import 'package:mambo/view%20models/vendor_view_model.dart';

import '../../../routes/app.nameRoutes.dart';

class ShopProductTile extends StatelessWidget {
  final int index;
  final ProductModel productModel;

  const ShopProductTile({
    super.key,
    required this.index,
    required this.productModel,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<WishlistViewModel, VendorProvider>(
        builder: (context, wishlistViewModel, vendorProvider, child) {
      bool isLiked =
          wishlistViewModel.isItemInWishlist(productModel.id.toString());

      return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              RoutesName.productScreen,
              arguments: {
                "screenName": vendorProvider.vendor!.storeName,
                "isPushedFromReelScreen": false,
                "productID": productModel.id,
                "index": index,
              },
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                // Product image
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CachedNetworkImage(
                    fit: BoxFit.fill,
                    imageUrl: productModel.images.first.src!,
                    placeholder: (context, url) => Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported_rounded,
                          size: 40),
                    ),
                  ),
                ),
                PriceTagWidget(
                  productPice: "₹${productModel.price}.00",
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(237, 255, 255, 255),
                          borderRadius: BorderRadius.circular(50)),
                      child: Consumer<WishlistViewModel>(
                          builder: (context, wishlistViewModel, child) {
                        return IconButton(
                          onPressed: () {
                            if (isLiked) {
                              wishlistViewModel.deleteWishlistItem(
                                WishListModel(
                                  vendor: Vendor(
                                    vendorId: productModel.store!.id,
                                    vendorName:
                                        "${vendorProvider.vendor!.firstName} ${vendorProvider.vendor!.lastName}",
                                    vendorStore:
                                        vendorProvider.vendor!.storeName,
                                  ),
                                  product: Product(
                                    productId: productModel.id,
                                    productName: productModel.name,
                                  ),
                                  price: (productModel.onSale!)
                                      ? productModel.salePrice
                                      : productModel.price,
                                  category: productModel.categories.first.name,
                                  imageUrl: productModel.images.first.src,
                                  createdAt: DateTime.now(),
                                ),
                              );
                            } else {
                              LocalNotificationSevice.showNotifications(
                                  notificationLayout:
                                      NotificationLayout.BigPicture,
                                  bigPicture: productModel.images.first.src,
                                  title: "Mambo • Wishlist",
                                  body:
                                      '${productModel.name} by ${productModel.store!.shopName} added to Wishlist');
                              wishlistViewModel.createWishlistItem(
                                WishListModel(
                                  vendor: Vendor(
                                    vendorId: productModel.store!.id,
                                    vendorName:
                                        "${vendorProvider.vendor!.firstName} ${vendorProvider.vendor!.lastName}",
                                    vendorStore:
                                        vendorProvider.vendor!.storeName,
                                  ),
                                  product: Product(
                                    productId: productModel.id,
                                    productName: productModel.name,
                                  ),
                                  price: (productModel.onSale!)
                                      ? productModel.salePrice
                                      : productModel.price,
                                  category: productModel.categories.first.name,
                                  imageUrl: productModel.images.first.src,
                                  createdAt: DateTime.now(),
                                ),
                              );
                            }
                          },
                          icon: isLiked
                              ? const Icon(Icons.favorite)
                              : const Icon(Icons.favorite_border),
                          color: isLiked ? Colors.red : Colors.black,
                          iconSize: (AppStyles.iconSize),
                        );
                      }),
                    ),
                  ),
                ),
                // Only show the button ifproductModel is not null

                Positioned(
                  bottom: 8,
                  right: 8,
                  child: ShopToAddToCartButton(
                    productName: productModel.name!,
                    productPrice: (productModel.onSale!)
                        ? productModel.salePrice!
                        : productModel.price!,
                    productID: productModel.id!,
                    quantity: 1,
                    productImgUrl: productModel.images.first.src!,
                    attributes: productModel.attributes,
                    index: index,
                    vendorID: productModel.store!.id!,
                    vendorName: productModel.store!.name!,
                  ),
                )
              ],
            ),
          ));
    });
  }
}
