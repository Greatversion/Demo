// ignore_for_file: use_build_context_synchronously

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:mambo/models/Database%20models/cart_model.dart';
import 'package:mambo/models/Network%20models/product_model.dart';
import 'package:mambo/routes/app.nameRoutes.dart';
import 'package:mambo/services/Notifications/Local%20Notifications/app.local_notification.dart';
import 'package:mambo/utils/Reusable_widgets/app.snackBar.dart';
import 'package:mambo/view%20models/cart_view_model.dart';
import 'package:provider/provider.dart';

import '../../app.styles.dart';

class AddToCartButton extends StatelessWidget {
  final String productName;
  final String productPrice;
  final int productID;
  final String productImgUrl;
  final int vendorID;
  final String vendorName;
  final List<Attribute> attributes;
  final Map<String, String> selectedAttributes;
  final int quantity;
  final int index;

  const AddToCartButton({
    super.key,
    required this.productName,
    required this.productPrice,
    required this.productID,
    required this.productImgUrl,
    required this.vendorID,
    required this.vendorName,
    required this.attributes,
    required this.selectedAttributes,
    required this.quantity,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    CartViewModel provider = Provider.of<CartViewModel>(context, listen: false);

    return GestureDetector(
      onTap: () async {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Added to Cart"),
          duration: Duration(milliseconds: 200),
        ));
        // Check if all attributes are selected
        bool allAttributesSelected = attributes.isEmpty ||
            selectedAttributes.length == attributes.length &&
                selectedAttributes.values.every((value) => value.isNotEmpty);

        if (allAttributesSelected) {
          if (!provider.isAdded) {
            await LocalNotificationSevice.showNotifications(
              bigPicture: productImgUrl,
              notificationLayout: NotificationLayout.BigPicture,
              title: "Mambo • Cart",
              body: '$productName by $vendorName added to Cart',
            ).then((context) {
              provider.addItemInCart(ProductCartModel(
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
            }).then((_) {});
          }

          // Navigator.pushNamed(
          //   context,
          //   RoutesName.cartScreen, // Assuming this is the correct route name
          //   arguments: {
          //     'productName': productName,
          //     'productPrice': productPrice,
          //     'productID': productID,
          //     'productImgUrl': productImgUrl,
          //     'vendorID': vendorID,
          //     'vendorName': vendorName,
          //     'attributes': attributes,
          //     'selectedAttributes': selectedAttributes,
          //     'quantity': quantity,
          //     'index': index,
          //   },
          // );

          debugPrint('Selected Attributes: $selectedAttributes');
          debugPrint('Selected Quantity: $quantity');
        } else {
          // customSnackBar(context, 'Please select all attributes');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select all attributes')),
          );
        }
      },
      child: Container(
        height: 43, //Modified
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
          child: Center(
            child: Text(
              "Add to cart",
              style: AppStyles.whiteColoredText
                  .copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}
