// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mambo/utils/app.styles.dart';

import '../../../providers/quantity_provider.dart';


class CartQuantityWidget extends StatelessWidget {
  String productID;
   CartQuantityWidget({
    Key? key,
    required this.productID,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<QuantityProvider>(
      builder: (context, value, child) => Row(
        children: [
          InkWell(
            onTap: () {
              value.decreaseQty(productID);
            },
            child: Icon(
              Icons.remove,
              color: Colors.black54,
              size: AppStyles.iconSize + 5,
            ),
          ),
          const SizedBox(width: 10),
          Text(
           " ${value.getQuantity(productID)}",
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: () {
              value.increaseQty(productID);
            },
            child: Icon(Icons.add,
                color: Colors.black54, size: AppStyles.iconSize + 5),
          )
        ],
      ),
    );
  }
}
