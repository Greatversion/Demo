// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mambo/providers/quantity_provider.dart';
import 'package:mambo/utils/app.constants.dart';
import 'package:mambo/utils/app.styles.dart';

class SelectQuantityWidget extends StatelessWidget {
  String productID;
  SelectQuantityWidget({
    super.key,
    required this.productID,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Quantity",
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 5),
        Consumer<QuantityProvider>(
          builder: (context, quantityProvider, child) => Row(
            children: [
              InkWell(
                onTap: () {
                  quantityProvider.decreaseQty(productID);
                },
                child: Icon(
                  Icons.remove_circle_outline,
                  color: Colors.black54,
                  size: AppStyles.iconSize + 5,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                "${quantityProvider.getQuantity(productID)}",
                style: TextStyle(fontSize: AppConst.isDeviceAPhone() ? 16 : 20),
              ),
              const SizedBox(width: 10),
              InkWell(
                onTap: () {
                  quantityProvider.increaseQty(productID);
                },
                child: Icon(
                  Icons.add_circle_outline,
                  color: Colors.black54,
                  size: AppStyles.iconSize + 5,
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
