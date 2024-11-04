// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mambo/models/Database%20models/wishlist_model.dart';
import 'package:mambo/models/Network%20models/product_model.dart';
import 'package:mambo/models/Network%20models/review_model.dart';
import 'package:mambo/routes/app.nameRoutes.dart';
import 'package:mambo/utils/app.styles.dart';
import 'package:mambo/view%20models/product_view_model.dart';
import 'package:mambo/view%20models/wishlist_view_model.dart';
import 'package:provider/provider.dart';

class ProductTilesWidget extends StatelessWidget {
  final int index;
  const ProductTilesWidget({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ProductProvider, WishlistViewModel>(
      builder: (context, productProvider, wishlistViewModel, child) {
        List<ProductModel> productData = [];
        if (productProvider.products == null ||
            productProvider.products!.isEmpty) {
          return const Center(child: Text(''));
        }

        final product = productProvider.products![index];
        final isLiked =
            wishlistViewModel.isItemInWishlist(product.id.toString());

        productData = productProvider.products!;

        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              RoutesName.productScreen,
              arguments: {
                "isPushedFromReelScreen": false,
                "productID": productData[index].id,
                "index": index,
                "screenName": "ExplorePage",
              },
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Stack(children: [
                CachedNetworkImage(
                  imageUrl: product.images.first.src ?? '',
                  placeholder: (context, url) => Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child:
                        const Icon(Icons.image_not_supported_rounded, size: 40),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(237, 255, 255, 255),
                        borderRadius: BorderRadius.circular(50)),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8, top: 3, bottom: 3),
                      child: Text("₹${product.regularPrice}",
                          style: AppStyles.semiBoldText),
                    ),
                  ),
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
                      child: IconButton(
                        onPressed: () {
                          if (isLiked) {
                            wishlistViewModel.deleteWishlistItem(
                              WishListModel(
                                vendor: Vendor(
                                  vendorId: product.store!.id,
                                  vendorName: product.store!.name,
                                  vendorStore: product.store!.shopName,
                                ),
                                product: Product(
                                  productId: product.id,
                                  productName: product.name,
                                ),
                                price: (product.onSale!)
                                    ? product.salePrice
                                    : product.regularPrice,
                                category: product.categories.first.name,
                                imageUrl: product.images.first.src,
                                createdAt: DateTime.now(),
                              ),
                            );
                          } else {
                            wishlistViewModel.createWishlistItem(
                              WishListModel(
                                vendor: Vendor(
                                  vendorId: product.store!.id,
                                  vendorName: product.store!.name,
                                  vendorStore: product.store!.shopName,
                                ),
                                product: Product(
                                  productId: product.id,
                                  productName: product.name,
                                ),
                                price: (product.onSale!)
                                    ? product.salePrice
                                    : product.regularPrice,
                                category: product.categories.first.name,
                                imageUrl: product.images.first.src,
                                createdAt: DateTime.now(),
                              ),
                            );
                          }
                        },
                        icon: isLiked
                            ? const Icon(Icons.favorite)
                            : const Icon(Icons.favorite_border),
                        color: isLiked ? Colors.red : Colors.black,
                        iconSize: (AppStyles.iconSize - 2),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        );
      },
    );
  }
}
