// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:flutter/foundation.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:mambo/services/Notifications/Local%20Notifications/app.local_notification.dart';
import 'package:provider/provider.dart';

import 'package:mambo/models/Database%20models/cart_model.dart';
import 'package:mambo/models/Network%20models/product_model.dart';
// import 'package:mambo/models/Network%20models/review_model.dart';
import 'package:mambo/utils/app.styles.dart';
import 'package:mambo/view%20models/cart_view_model.dart';

class ShopToAddToCartButton extends StatelessWidget {
  final String productName;
  final String productPrice;
  final int productID;
  final int quantity;
  final String productImgUrl;
  final List<Attribute> attributes;

  final int index;

  final int vendorID;
  final String vendorName;

  const ShopToAddToCartButton({
    super.key,
    required this.productName,
    required this.productPrice,
    required this.productID,
    required this.quantity,
    required this.productImgUrl,
    required this.attributes,
    required this.index,
    required this.vendorID,
    required this.vendorName,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CartViewModel>(builder: (context, cartViewModel, child) {
      return Container(
          decoration: BoxDecoration(
              color: const Color.fromARGB(237, 255, 255, 255),
              borderRadius: BorderRadius.circular(50)),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: GestureDetector(
              onTap: () {
                Map<String, String> selectedAttributes = {};
                if (!cartViewModel.isAdded) {
                  List.generate(attributes.length, (index) {
                    selectedAttributes[attributes[index].name!] =
                        attributes[index].options.first;
                  });

                  LocalNotificationSevice.showNotifications(
                      bigPicture: productImgUrl,
                      notificationLayout: NotificationLayout.BigPicture,
                      title: "Mambo • Cart",
                      body: '$productName by $vendorName added to Cart');
                  cartViewModel.addItemInCart(ProductCartModel(
                    productName: productName,
                    productPrice: productPrice,
                    productID: productID,
                    quantity: quantity,
                    productImgUrl: productImgUrl,
                    vendorID: vendorID,
                    vendorName: vendorName,
                    attributes: attributes,
                    selectedAttributes: selectedAttributes,
                  ));
                }
              },
              child: Icon(
                weight: 10,
                Icons.shopping_cart_outlined,
                color: Colors.black87,
                size: (AppStyles.iconSize),
              ),
            ),
          ));
    });
  }
}
