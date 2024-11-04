// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:mambo/models/Database%20models/wishlist_model.dart';

import 'package:mambo/utils/app.styles.dart';
import 'package:mambo/view%20models/wishlist_view_model.dart';
import 'package:provider/provider.dart';

class AddToWishListButton extends StatelessWidget {
  final int index;
  const AddToWishListButton({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final WishlistViewModel wishlistViewModel =
        Provider.of<WishlistViewModel>(context);
    final product = wishlistViewModel.userwishlist[index];
    final isLiked = wishlistViewModel
        .isItemInWishlist(product.product!.productId!.toString());
    return Positioned(
      top: 8,
      right: 8,
      child: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
              color: const Color.fromARGB(237, 255, 255, 255),
              borderRadius: BorderRadius.circular(100)),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Consumer<WishlistViewModel>(
              builder: (context, wishlistViewModel, child) => GestureDetector(
                onTap: () {
                  //Add to wishlist

                  if (isLiked) {
                    wishlistViewModel.deleteWishlistItem(
                      WishListModel(
                        vendor: Vendor(
                          vendorId: product.vendor!.vendorId!,
                          vendorName: product.vendor!.vendorName!,
                          vendorStore: product.vendor!.vendorStore!,
                        ),
                        product: Product(
                          productId: product.product!.productId,
                          productName: product.product!.productName,
                        ),
                        price: product.price,
                        category: product.category,
                        imageUrl: product.imageUrl,
                        createdAt: DateTime.now(),
                      ),
                    );
                  } else {
                    wishlistViewModel.createWishlistItem(
                      WishListModel(
                        vendor: Vendor(
                          vendorId: product.vendor!.vendorId!,
                          vendorName: product.vendor!.vendorName!,
                          vendorStore: product.vendor!.vendorStore!,
                        ),
                        product: Product(
                          productId: product.product!.productId,
                          productName: product.product!.productName,
                        ),
                        price: product.price,
                        category: product.category,
                        imageUrl: product.imageUrl,
                        createdAt: DateTime.now(),
                      ),
                    );
                  }
                },
                child: isLiked
                    ? Icon(
                        weight: 10,
                        Icons.favorite,
                        color: Colors.red,
                        size: (AppStyles.iconSize),
                      )
                    : Icon(
                        weight: 10,
                        Icons.favorite_border,
                        color: Colors.black,
                        size: (AppStyles.iconSize),
                      ),
              ),
            ),
          )),
    );
  }
}
