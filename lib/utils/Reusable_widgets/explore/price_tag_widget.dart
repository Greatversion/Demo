import 'package:flutter/material.dart';
import 'package:mambo/utils/app.styles.dart';

class PriceTagWidget extends StatelessWidget {
  final String productPice;
  const PriceTagWidget({
    super.key,
    required this.productPice,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 8,
      left: 8,
      child: Container(
        decoration: BoxDecoration(
            color: const Color.fromARGB(237, 255, 255, 255),
            borderRadius: BorderRadius.circular(50)),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 8.0, right: 8, top: 3, bottom: 3),
          child: Text(productPice, style: AppStyles.semiBoldText),
        ),
      ),
    );
  }
}
